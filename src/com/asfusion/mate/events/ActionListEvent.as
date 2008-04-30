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
	
	/**
	 * Event indicating status changes in the IActionList (start, end, etc).
	 */
	public class ActionListEvent extends Event
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Static Constants
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Dispatched when the IActionList starts.
		 */
		public static const START:String = "start";
		
		/**
		 * Dispatched when the IActionList ends.
		 */
		public static const END:String = "end";
		
		/**
		 * Dispatched when the scope changes.
		 */
		public static const SCOPE_CHANGE:String = "scopeChange";
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Original Event that started the IActionList.
		 */
		public var originalEvent:Event;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		public function ActionListEvent(type:String, originalEvent:Event=null)
		{
			super(type);
			this.originalEvent = originalEvent;
		}
		
	}
}