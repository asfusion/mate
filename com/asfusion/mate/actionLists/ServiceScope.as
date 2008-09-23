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
	import flash.events.Event;
	
	/**
	 * ServiceScope is an object created by the <code>IActionList</code>.
	 * <p>It represents the running scope of a <code>IActionList</code>. 
	 * The <code>IActionList</code> and its actions share this object to transfer data
	 * between them.</p>
	 * ServiceScope contains service-specific properties such as the result and fault
	 * returned by service calls.
	 */
	public class ServiceScope extends Scope
	{
		/**
		 * Result Object returned from the service
		 */
		public var result:Object;
		
		/**
		 * Fault Object returned from the service
		 */
		public var fault:Object;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function ServiceScope(event:Event, active:Boolean, inheritScope:IScope = null)
		{
			super(event, active, inheritScope.eventMap, inheritScope);
		}

	}
}