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
	 * Event used by <code>ServiceResponseHandler</code> to notify
	 * responses.
	 */
	public dynamic class ResponseEvent extends Event
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Static Properties
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Indicates that a response has been received.
		 */
		public static const RESPONSE:String = "response";
		
		/**
		 * Indicates that a result has been received.
		 * Recomended to be dispatched from a resultHandlers.
		 */
		public static const RESULT:String 	= "result";
		
		/**
		 * Indicates that a fault has been received.
		 * Recomended to be dispatched from a faultHandlers.
		 */
		public static const FAULT:String 	= "fault";
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Properties
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Data Object (holder for custom data)
		 */
		public var data:Object;
		
		/**
		 * Fault Object from a service
		 */
		public var fault:Object;
		
		/**
		 * Result Object from a service
		 */
		public var result:Object;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */	
		public function ResponseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}