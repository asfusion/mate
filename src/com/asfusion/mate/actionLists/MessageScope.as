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
	
	import flash.events.Event;
	
	import mx.messaging.messages.IMessage;
	
	/**
	 * <code>MessageScope</code> is an object created by the <code>MessageHandlers</code>.
	 * <p>It represents the running scope of a <code>IActionList</code>. 
	 * The <code>IActionList</code> and its actions share this object to transfer data
	 * between them.</p>
	 */
	public class MessageScope extends Scope
	{
		/**
		 * A message received by the consumer.
		 */
		public var message:IMessage;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		public function MessageScope(event:Event, active:Boolean, map:IEventMap, inheritScope:IScope = null)
		{
			super(event, active, map, inheritScope);
		}
		
	}
}