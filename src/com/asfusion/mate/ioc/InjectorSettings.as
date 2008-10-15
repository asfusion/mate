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
package com.asfusion.mate.ioc
{
	import mx.events.FlexEvent;
	import com.asfusion.mate.core.MateManager;
	
	/**
	 * InjectionSettings lets you have more control on how the injection
	 * occurs. You can turn off/on the auto-wiring and change the type of the event
	 * that will trigger the wiring. If auto-wiring is off, you need to use the <code>InjectorRegistry</code> or 
	 * <code>InjectorTarget</code> to wire the Injectors manually.
	 */
	public class InjectorSettings
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................eventType..........................................*/
		/**
		 * Event type that Mate will listen to that will be dispatched by the application views
		 * 
		 *  @default FlexEvent.CREATION_COMPLETE
		 * */
		public function get eventType():String
		{
			return MateManager.instance.listenerProxyType;
		}
		public function set eventType(value:String):void
		{
			MateManager.instance.listenerProxyType = value;
		}
	}
}