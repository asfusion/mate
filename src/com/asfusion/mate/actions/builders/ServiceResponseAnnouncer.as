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
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actionLists.ServiceScope;
	import com.asfusion.mate.actions.BaseAction;
	import com.asfusion.mate.actions.IAction;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.InternalResponseEvent;
	import com.asfusion.mate.events.ResponseEvent;
	import com.asfusion.mate.utils.debug.*;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.utils.*;
	
	use namespace mate;
	/**
	 * The <code>ServiceResponseAnnouncer</code> tag is placed inside a <code>IActionList</code>, so that when an object dispatches an event, 
	 * and the list runs, this tag will allow you to send responses directly to the object that dispatched the event.
	 *  
	 * <p>These responses are 3 predefined events:</p>
	 * <ul><li>response</li>
	 * <li>result</li>
	 * <li>fault</li></ul>
	 * 
	 * <p>Because of those predefined events, this tag is used inside a <code>resultHandlers</code> or 
	 * <code>faultHandlers</code> inner-action-list that are generated after server calls. </p>
	 * 
	 * <p>The use of this tag will have no effect if the original event was not dispatched using the <code>Dispatcher</code> tag. Moreover, 
	 * this tag will have no effect if no <code>ServiceResponseHandler</code> tag was added as an inner tag to the <code>Dispatcher</code> tag.</p>
	 * 
	 * @mxml
 	 * <p>The <code>&lt;ResponseAnnouncer&gt;</code> tag has the following tag attributes:</p>
 	 * <pre>
	 * &lt;ResponseAnnouncer
 	 * <b>Properties</b>
	 * type="result|fault|response"
	 * data="Object"
 	 * /&gt;
	 * </pre>
	 * 
	 * @see com.asfusion.mate.actions.builders.ResponseAnnouncer
	 */
	public class ServiceResponseAnnouncer extends BaseAction implements IAction
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................type..........................................*/
		private var _type:String;
		/**
		 * The type of response (case-sensitive).
		 * Possible types:
		 * <ul><li>response</li>
		 * <li>result</li>
		 * <li>fault</li></ul>
		 * 
		 * @see com.asfusion.mate.viewUtils.serviceResponse
		 */
		public function get type():String
		{
			return _type;
		}
		[Inspectable(enumeration="response,result,fault")]
		public function set type(value:String):void
		{
			_type = value;
		}
		
		
		/*-.........................................data..........................................*/
		private var _data:Object;
		/**
		 * <code>data</code> is a placeholder object.
		 * This object can be used to store temporary data to pass to the ServiceResponseListener.
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override protected methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................createInstance..........................................*/
		/**
		 * @inheritDoc
		 */
		protected function createInstance(scope:IScope):Object
		{
			if(type)
			{
				var event:ResponseEvent = new ResponseEvent(type);
				if(scope is ServiceScope)
				{
					event.fault = ServiceScope(scope).fault;
					event.result =ServiceScope(scope).result;
				}
				event.data = data;
				currentInstance = event;
			}
			else
			{
				scope.getLogger().error(LogTypes.TYPE_NOT_FOUND, new LogInfo(scope, null));
			}
			return currentInstance;
		}
		
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
		
		/*-.........................................prepare..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			createInstance(scope);
		}
	}
}