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
package com.asfusion.mate.events
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * Event that notifies when Dispatcher changes.
	 */
	public class DispatcherEvent extends Event
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Static Constants
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Type that indicates that the dispatcher has been changed.
		 */
		public static const CHANGE:String = "changeDispatcherEvent"
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Reference to the previous dispatcher.
		 */
		public var oldDispatcher:IEventDispatcher;
		
		/**
		 * Reference to the new dispatcher.
		 */
		public var newDispatcher:IEventDispatcher;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		public function DispatcherEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * Returns a new Event object that is a copy of the original instance of the Event object. 
		 * You do not normally call clone(); the EventDispatcher class calls it automatically when you 
		 * redispatch an event—that is, when you call dispatchEvent(event) from a handler that is handling event.
		 */
		override public function clone():Event
		{
			var event:DispatcherEvent = new DispatcherEvent(type);
			event.newDispatcher = newDispatcher;
			event.oldDispatcher = oldDispatcher;
			return event;
		}
	}
}