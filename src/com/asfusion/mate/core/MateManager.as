/*
Copyright 2008 Nahuel Foronda/AsFusion

Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License. Y
ou may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, s
oftware distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and limitations under the License

Author: Nahuel Foronda, Principal Architect
        nahuel at asfusion dot com
                
@ignore
*/
package com.asfusion.mate.core
{	
	
	/**
	 * <code>MateManager</code> is in charge of returning an instance of the
	 * <code>IMateManager</code> that is one of the core classes of Mate.
	 */
	public class MateManager
	{
		
		/*-----------------------------------------------------------------------------------------------------------
        *                                          Public setters and Getters
        -------------------------------------------------------------------------------------------------------------*/
        /*-.........................................instance..........................................*/
		private static var _instance:IMateManager
		/**
		 * Returns a single <code>IMateManager</code> instance. 
		 */
		public static function get instance():IMateManager
		{
			var inst:IMateManager = (!_instance)? createInstance():_instance;
			return inst;
		}
		
        /*-----------------------------------------------------------------------------------------------------------
        *                                          Static Private Methods
        -------------------------------------------------------------------------------------------------------------*/
        /*-.........................................createInstance........................................*/
        /**
        * Creates the <code>IMateManager</code> instance.
        */
        protected static function createInstance():IMateManager
        {
        	_instance = new MateManagerInstance();
        	return _instance;
        }
	}
}

/******************************************************************************************************************
*                                         Inner Class MateManagerInstance
*******************************************************************************************************************/	
import com.asfusion.mate.core.IMateManager;
import com.asfusion.mate.events.InjectorEvent;
import com.asfusion.mate.events.MateManagerEvent;
import com.asfusion.mate.utils.SystemManagerFinder;
import com.asfusion.mate.utils.debug.*;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import mx.core.Application;
import mx.events.FlexEvent;
import mx.logging.ILoggingTarget;
import mx.managers.ISystemManager;

class MateManagerInstance extends EventDispatcher implements IMateManager
{
	private var cacheInstances:Dictionary = new Dictionary();
	private var listenerProxyRegistered:Boolean = false;
	private var methodQueue:Dictionary = new Dictionary();
	private var listenerProxyType:String = FlexEvent.CREATION_COMPLETE;
	
	/*-----------------------------------------------------------------------------------------------------------
     *                                          Public setters and Getters
     -------------------------------------------------------------------------------------------------------------*/
     
    /*-.........................................application..........................................*/
    private var _application:Application;
	public function get application():Application
	{
		return Application.application as Application;
	}
	
	/*-.........................................systemManager..........................................*/
	public function get systemManager():ISystemManager
	{
		return (application.systemManager) ? application.systemManager.topLevelSystemManager : SystemManagerFinder.find().topLevelSystemManager;
	}
	
	/*-.........................................loggerClass........................................*/
	private var _loggerClass:Class = Logger;
	public function set loggerClass(value:Class):void
	{
		_loggerClass = value;
	}
	public function get loggerClass():Class
	{
		return _loggerClass;
	}
	
	/*-.........................................debugger........................................*/
	private  var _debugger:ILoggingTarget;
	public function set debugger(value:ILoggingTarget):void
	{
		_debugger = value;
	}
	public function get debugger():ILoggingTarget
	{
		return _debugger;
	}
	
	/*-.........................................dispatcher........................................*/
	private  var _dispatcher:IEventDispatcher;
	public function set dispatcher(value:IEventDispatcher):void
	{
		var oldDispatcher:IEventDispatcher = (_dispatcher == null ) ? application: _dispatcher;
		if(oldDispatcher !== value)
		{
			_dispatcher = value;
			var event:MateManagerEvent = new MateManagerEvent(MateManagerEvent.DISPATCHER_CHANGE);
			event.oldDispatcher = oldDispatcher;
			event.newDispatcher = _dispatcher;
			dispatchEvent(event);
		}
	}
	public function get dispatcher():IEventDispatcher
	{
		return (_dispatcher == null ) ? application: _dispatcher;
	}
	
	/*-.........................................responseDispatcher........................................*/
	private var _responseDispatcher:IEventDispatcher = new EventDispatcher();
	public function get responseDispatcher():IEventDispatcher
	{
		return _responseDispatcher;
	}
	/*-----------------------------------------------------------------------------------------------------------
     *                                          Public Methods
     -------------------------------------------------------------------------------------------------------------*/
      /*-.........................................callLater........................................*/
	public function callLater(method:Function):void
	{
		methodQueue[method] = method;
		addListeners();
	}
	
    /*-.........................................getLogger........................................*/
    public function getLogger(active:Boolean):IMateLogger
    {
    	var logger:IMateLogger;
    	if(debugger)
    	{
    		logger = new loggerClass(active);
    		debugger.addLogger(logger);
    	}
    	else
    	{
    		logger = new loggerClass(false);
    	}
    	return logger;
    }
    /*-.........................................getCachedInstance........................................*/
    public function getCachedInstance(template:Class):Object
    {
    	return cacheInstances[template];
    }
    /*-.........................................addCachedInstance........................................*/
    public function addCachedInstance(template:Class, instance:Object):void
    {
    	cacheInstances[template] = instance;
    }
    
    /*-.........................................addEventAdapter........................................*/
	public function addListenerProxy(type:String = null):void
	{
		type = (type == null) ? listenerProxyType : type;
		
		if(listenerProxyType != type && listenerProxyRegistered)
		{
			removeListenerProxy(listenerProxyType);
		}
		if(!listenerProxyRegistered)
		{
			application.addEventListener(type, listenerProxyHandler, true,1);
			application.addEventListener(type, listenerProxyHandler, false,1);
			systemManager.addEventListener(type, listenerProxyHandler, true,1);
			listenerProxyType = type;
			listenerProxyRegistered = true;
		}
	}
    
    /*-.........................................removeEventAdapter........................................*/
	public function removeListenerProxy(type:String = null):void
	{
		type = (type == null) ? listenerProxyType : type;
		application.removeEventListener(type, listenerProxyHandler, true);
		application.removeEventListener(type, listenerProxyHandler, false);
		systemManager.removeEventListener(type, listenerProxyHandler, true);
		listenerProxyRegistered = false;
	}
    
	/*-----------------------------------------------------------------------------------------------------------
     *                                          Private Methods
     -------------------------------------------------------------------------------------------------------------*/
	
	/*-.........................................addListeners........................................*/
	private function addListeners():void
	{
		systemManager.stage.addEventListener(Event.ENTER_FRAME, callLaterDispatcher);
	}
	
	/*-.........................................removeListeners........................................*/
	private function removeListeners():void
	{
		systemManager.stage.removeEventListener(Event.ENTER_FRAME, callLaterDispatcher);
	}
	
	/*-.........................................callLaterDispatcher........................................*/
	private function callLaterDispatcher(event:Event):void
	{
		for each(var method:Function in methodQueue)
		{
			method();
		}
		methodQueue = new Dictionary();
		removeListeners();
	}
	
	/*-----------------------------------------------------------------------------------------------------------
     *                                          Event Handlers
     -------------------------------------------------------------------------------------------------------------*/
	/*-.........................................eventAdapterHandler........................................*/
	private function listenerProxyHandler(event:Event):void
	{
		var type:String = getQualifiedClassName(event.target);
		if(dispatcher.hasEventListener(type))
		{
			var adapterEvent:InjectorEvent = new InjectorEvent(type);
			adapterEvent.injectorTarget = event.target;
			if(event.target.hasOwnProperty("id"))
				adapterEvent.uid = event.target["id"];
			dispatcher.dispatchEvent(adapterEvent);
		}
	}
	
}