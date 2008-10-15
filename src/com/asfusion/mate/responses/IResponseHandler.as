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
package com.asfusion.mate.responses
{
	import flash.events.IEventDispatcher;
	import com.asfusion.mate.events.Dispatcher;
	/**
	 * This interface is required by response handlers to be placed inside
	 * the Dispatcher tag
	 */ 
	public interface IResponseHandler
	{
		/**
		 * This method receives an eventDispatcher to register as a listener for a response for a specific event.
		 * It is called by the Dispatcher before the event gets dispatched.
		 */
		function addReponderListener(type:String, dispatcher:IEventDispatcher, owner:Dispatcher):void
		
		/**
		 * This method removes the response listener.
		 * It is called by the Dispatcher after the response is back.
		 */
		function removeResponderListener(type:String, dispatcher:IEventDispatcher):void
	}
}