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
	
	import mx.core.Application;
	import mx.logging.ILoggingTarget;
	import mx.managers.ISystemManager;
	/**
	 * <code>IMateManager</code> is the core class of Mate
	 */
	public interface IMateManager extends IEventDispatcher
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Getters and Setters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................application..........................................*/
		/**
		 * A reference to the Application instance
		 */
		function get application():Application
		
		/*-.........................................systemManager..........................................*/
		/**
		 * A reference to the ISystemManager instance
		 */
		function get systemManager():ISystemManager
		
		/*-.........................................dispatcher..........................................*/
		/**
		 * A reference to the IEventDispatcher instance that is used by the following tags:
		 * <ul><li><code>Dispatcher</code></li>
		 * <li><code>IActionList</code></li>
		 * <li><code>Listener</code></li></ul>
		 */
		function set dispatcher(value:IEventDispatcher):void
		function get dispatcher():IEventDispatcher
		
		/*-.........................................responseDispatcher..........................................*/
		/**
		 * A reference to the IEventDispatcher instance used by the <code>Response</code> tag
		 */
		function get responseDispatcher():IEventDispatcher
		
		/*-.........................................debugger..........................................*/
		/**
		 * An <code>ILoggingTarget</code> used by debugging purpose.
		 */
		function set debugger(value:ILoggingTarget):void
		function get debugger():ILoggingTarget
		
		/*-.........................................listenerProxyType..........................................*/
		/**
		 * The default event type used by the injectors.
		 */
		function set listenerProxyType(value:String):void
		function get listenerProxyType():String
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................callLater..........................................*/
		/**
		 * Queues a function to be called later.
		 * <p>Before each update of the screen, Flash Player or AIR calls the set of functions 
		 * that are scheduled for the update. Sometimes, a function should be called in the next 
		 * update to allow the rest of the code scheduled for the current update to be executed. 
		 * Some features, like effects, can cause queued functions to be delayed until the feature completes.</p>
		 */
		function callLater(method:Function):void
		
		/*-.........................................getLogger..........................................*/
		/**
		 * An <code>IMateLogger</code> used to log errors.
		 * Similar to Flex <code>ILogger</code>
		 */
		function getLogger(active:Boolean):IMateLogger
		
		/*-.........................................getCachedInstance..........................................*/
		/**
		 * Retrieves an instance from the cache.
		 */
		function getCachedInstance(template:Class):Object
		
		/*-.........................................addCachedInstance..........................................*/
		/**
		 * Adds an instance to the cache.
		 */
		function addCachedInstance(template:Class, instance:Object):void
		
		/*-.........................................clearCachedInstance..........................................*/
		/**
		 * Removes an instance from the cache.
		 */
		function clearCachedInstance(template:Class):void
		
		/*-.........................................addListenerProxy..........................................*/
		/**
		 * Adds a proxy listener for a specific type.
		 */
		function addListenerProxy(eventDispatcher:IEventDispatcher, type:String = null):void
	}
}