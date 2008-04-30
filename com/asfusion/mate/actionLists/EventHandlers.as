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
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.MateManagerEvent;
	import com.asfusion.mate.utils.debug.DebuggerUtil;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	use namespace mate;

	/**
	 * A <code>EventHandlers</code> defined in the <code>EventMap</code> will run whenever an event of the type specified in the <code>EventHandlers</code>'s "type" argument is dispatched. 
	 * Note that in order for the <code>EventMap</code> to be able to listen for the given event, 
	 * this event must have its bubbling setting as true and be dispatched from an object that has Application as its root ancestor, 
	 * or the event must be dispatched by a Mate Dispatcher (such is the case when dispatching events from a PopUp window).
	 * 
	 * @example
	 * 
	 * <listing version="3.0">
	 *  &lt;EventHandlers type="myEventType"&gt;
	 *       ... here what you want to happen when this event is dispatched...
	 *  &lt;/EventHandlers&gt;
	 *  </listing>
	 */
	public class EventHandlers extends AbstractHandlers
	{
		
		/**
		 * Flag indicating if this <code>EventHandlers</code> tag is registered to listen to an event or not.
		 */
		protected var registered:Boolean;
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................type..........................................*/
		private var _type:String;
		/**
		 * The event type that, when dispatched, should trigger the handlers to run. 
		 * It should match the type specified in the event when created. 
		 * All events extending from flash.events.Event have a "type" property.
		 * The type is case-sensitive.
		 * 
		 *  @default null
		 * */
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			var oldValue:String = _type;
	        if (oldValue !== value)
	        {
	        	_type = value;
	         	unregister(oldValue, dispatcher);
	         	validateNow();
	        }
		}
		
		
		/*-.........................................priority..........................................*/
		private var _priority:int = 0;
		/**
		 * (default = 0) — The priority level of the <code>EventHandlers</code>. 
		 * The higher the number, the higher the priority. All <code>EventHandlers</code> with priority n are 
		 * processed before <code>EventHandlers</code> of priority n-1. 
		 * If two or more <code>EventHandlers</code> share the same priority, they are processed 
		 * in the order in which they were added. The default priority is 0.
		 * 
		 *  @default 0
		 * */
		public function get priority():int
		{
			return _priority;
		}
		public function set priority(value:int):void
		{
	        if (_priority !== value)
	        {
	        	_priority = value;
	         	unregister(type, dispatcher);
	         	validateNow();
	        }
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Mate Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................dispatcher........................................*/
		private  var _dispatcher:IEventDispatcher;
		/**
		 * 	The <code>EventHandlers</code> registers itself as an event listener of the dispatcher specified in this property. 
		 *  By the default, this dispatcher is the Application. dispatcher property only available when using mate namespace
		 * 
		 *  @default Application.application
		 * 
		 */
		override mate function get dispatcher():IEventDispatcher
		{
			return (_dispatcher == null ) ? manager.dispatcher : _dispatcher;
		}
		override mate function set dispatcher(value:IEventDispatcher):void
		{
			var oldValue:IEventDispatcher = _dispatcher;
			if(_dispatcher !== value)
			{
				_dispatcher = value;
				unregister(type, oldValue);
				validateNow();
			}
		}
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		 public function EventHandlers()
		 {
		 	super();
		 }
		 
		 
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Methods
		-------------------------------------------------------------------------------------------------------------*/	
		
		
		/*-.........................................errorString..........................................*/
		/**
		 * @inheritDoc
		 */ 
		override public function errorString():String
		{
			var str:String = "EventType:"+ type + ". Error was found in a EventHandlers list in file " 
							+ DebuggerUtil.getClassName(document);
			return str;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Methods
		-------------------------------------------------------------------------------------------------------------*/	
		
		/*-.........................................commitProperties..........................................*/
		/**
		 * Processes the properties set on the component.
		*/
		override protected function commitProperties():void
		{
			if(!registered && type)
			{
				dispatcher.addEventListener(type,fireEvent,false, priority);
				registered = true;
			}
		}
		
		/*-.........................................unregister..........................................*/
		/**
		*  Un-register as a listener of the event type provided.  
		*/
		protected function unregister(oldType:String, oldDispatcher:IEventDispatcher ):void
		{
			if(oldDispatcher && oldType)
			{
				oldDispatcher.removeEventListener(oldType, fireEvent);
				registered = false;
			}
		}
		
		/*-.........................................fireEvent..........................................*/
		/**
		 * Called by the dispacher when the event gets triggered.
		 * This method creates a scope and then runs the sequence.
		*/
		protected function fireEvent(event:Event):void
		{
			var currentScope:Scope = new Scope(event, debug, inheritedScope);
			currentScope.owner = this;
			setScope(currentScope);
			runSequence(currentScope, actions);
		}
		


		/*-----------------------------------------------------------------------------------------------------------
		*                                      Event Handlers
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................handleDispatcherChange..........................................*/
		/**
		 * A handler for the mate dispatcher changed.
		 * This method is called by <code>IMateManager</code> when the dispatcher changes.
		*/
		override protected function handleDispatcherChange(event:MateManagerEvent):void
		{
			if(_dispatcher == null)
			{
				unregister(type, event.oldDispatcher);
				validateNow();
			}
		}
		
	}
}