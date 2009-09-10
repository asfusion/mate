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
	import com.asfusion.mate.utils.debug.IMateLogger;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.logging.ILoggingTarget;
	import mx.managers.ISystemManager;
	/**
	 * <code>IMateManager</code> is the core class of Mate
	 */
	public interface IMateManager extends IEventDispatcher
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                     Getters and Setters
		//-----------------------------------------------------------------------------------------------------------
		

		//........................................dispatcher..........................................
		/**
		 * A reference to the IEventDispatcher instance that is used by the following tags:
		 * <ul><li><code>Dispatcher</code></li>
		 * <li><code>IActionList</code></li>
		 * <li><code>Listener</code></li></ul>
		 */
		function set dispatcher(value:IEventDispatcher):void
		function get dispatcher():IEventDispatcher
		
		//.........................................responseDispatcher..........................................
		/**
		 * A reference to the IEventDispatcher instance used by the <code>Response</code> tag
		 */
		function get responseDispatcher():IEventDispatcher
		
		//.........................................debugger..........................................
		/**
		 * An <code>ILoggingTarget</code> used by debugging purpose.
		 */
		function set debugger(value:ILoggingTarget):void
		function get debugger():ILoggingTarget
		
		//.........................................listenerProxyType..........................................
		/**
		 * The default event type used by the injectors.
		 */
		function set listenerProxyType(value:String):void
		function get listenerProxyType():String
		
		//.........................................getCacheCollection..........................................
		/**
		 * Global cache.
		 */
		function getCacheCollection():Dictionary
		
		//-----------------------------------------------------------------------------------------------------------
		//                                      Methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................getLogger..........................................
		/**
		 * An <code>IMateLogger</code> used to log errors.
		 * Similar to Flex <code>ILogger</code>
		 */
		function getLogger(active:Boolean):IMateLogger
		
		//.........................................addListenerProxy.........................................
		/**
		 * Adds a proxy listener for a specific type.
		 */
		function addListenerProxy(eventDispatcher:IEventDispatcher, type:String = null):ListenerProxy
	}
}