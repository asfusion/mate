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
package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.InternalResponseEvent;
	import com.asfusion.mate.actionLists.IScope;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.utils.*;
	
	use namespace mate;
	
	/**
	 * The ResponseAnnouncer tag is placed inside a <code>IActionList</code>, so that when an object dispatches an event, 
	 * and the list runs, this tag will allow you to send responses directly to the object that dispatched the event.
	 *  
	 * <p>These responses are actually custom events that you need to create 
	 * (if no generator class is specified, a DynamicEvent will be created). </p>
	 * <p>Using the ResponseAnnouncer tag is very similar in form and purpose of the EventAnnouncer tag, 
	 * with the important difference that when using the EventAnnouncer tag, all listeners of that event will be notified, 
	 * whereas when using the ResponseAnnouncer tag, only the object that dispatched the original event will be notified.</p>
	 * 
	 * <p>The use of this tag will have no effect if the original event was not dispatched using the Dispatcher tag. Moreover, 
	 * this tag will have no effect if no Response tag was added as an inner tag to the Dispatcher tag.</p>
	 * 
	 * @mxml
 	 * <p>The <code>&lt;ResponseAnnouncer&gt;</code> tag has the following tag attributes:</p>
 	 * <pre>
	 * &lt;ResponseAnnouncer
 	 * <b>Properties</b>
	 * generator="Class"
	 * constructorArgs="Object|Array"
	 * properties="Properties"
	 * type="String"
	 * bubbles="true|false"
	 * cancelable="true|false"
 	 * /&gt;
	 * </pre>
	 * 
	 * @see com.asfusion.mate.actions.builders.EventAnnouncer
	 * @see com.asfusion.mate.actions.builders.ServiceResponseAnnouncer
	 */
	public class ResponseAnnouncer extends EventAnnouncer
	{
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			var event:Event = scope.event;
			if(event)
			{
				var uidu:String = UIDUtil.getUID(event);
				var dispatcher:IEventDispatcher = scope.getManager().responseDispatcher;
				var hasEventListener:Boolean = dispatcher.hasEventListener(uidu);
				if(hasEventListener)
				{
					var internalEvent:InternalResponseEvent = new InternalResponseEvent(uidu);
					internalEvent.event = currentInstance;
					dispatcher.dispatchEvent(internalEvent);
				}
				scope.lastReturn = hasEventListener;
			}
		}
	}
}