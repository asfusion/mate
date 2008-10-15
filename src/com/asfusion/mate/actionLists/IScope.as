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
package com.asfusion.mate.actionLists
{
	import com.asfusion.mate.core.IEventMap;
	import com.asfusion.mate.core.IMateManager;
	import com.asfusion.mate.utils.debug.*;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * Scope is an object created by the <code>IActionList</code>.
	 * <p>It represents the running scope of a that <code>IActionList</code>. 
	 * The <code>IActionList</code> and its <code>IAction</code>s inner tags share this object to transfer data
	 * between them.</p>
	 */
	public interface IScope extends ILoggerProvider
	{
		/**
		 * Data Object (holder for custom data)
		 */
		function get data():Object
		function set data(value:Object):void
		
		/**
		 * The <code>IActionList</code> that created this scope.
		 */
		function get owner():IActionList
		function set owner(value:IActionList):void
		
		/**
		 * Original Event that triggered the <code>IActionList</code>.
		 */
		function get event():Event
		function set event(value:Event):void
		
		/**
		 * return from the last <code>IAction</code> run
		 */
		function get lastReturn():*
		function set lastReturn(value:*):void
		
		/**
		 * The current target that is using this scope.
		 * This target is usually set by the <code>IActionList</code> before
		 * calling <code>trigger</code> on its <code>actions</code>.
		 */
		function get currentTarget():Object
		function set currentTarget(value:Object):void
		
		/**
		 * Instance of the <code>IEventDispatcher</code> that will be used to dispatch events
		 * or to register to events.
		 */
		function get dispatcher():IEventDispatcher
		function set dispatcher(value:IEventDispatcher):void
		
		
		/**
		 * Instance of the <code>EventMap</code> where this scope lives.
		 */
		function get eventMap():IEventMap
		function set eventMap(value:IEventMap):void
		
		/**
		 * Stops the <code>IActionList</code> flow.
		 * The next <code>IAction</code> will be not be called.
		 */
		function stopRunning():void
		
		/**
		 * Returns a boolean indicating if the <code>IActionList</code> is running or not.
		 */
		function isRunning():Boolean
		
		/**
		 * Returns an instance of <code>IMateManager</code> used to get the logger and dispatcher.
		 */
		function getManager():IMateManager
	}
}