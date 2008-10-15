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
	import com.asfusion.mate.core.*;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * The event that gets dispatched when an event of the type
	 * specified in the <code>type</code> attribute is dispatched.
	 */ 
	[Event(name="receive",type="*")]
	
	/**
	 * Listener allows you to register a view as a listener for an event type. 
	 * As long as the event bubbles up or is dispatched via the <code>mate:Dispatcher</code> tag or class, 
	 * the registered listeners will be notified.
	 */
	public class Listener implements IEventDispatcher
	{
		/**
		 * Instance of an <code>IEventDispatcher</code> to which this listener will be subscribed.
		 */
		protected var dispatcher:IEventDispatcher;
		/**
		 * Type of event that this class dispatches.
		 */
		protected var tagEventType:String;
		/**
		* Flag to mark if a method has been registerd
		*/
		protected var methodRegistered:Boolean;
		/**
		* Flag to mark if an inline method has been registerd
		*/
		protected var mxmlRegistered:Boolean;
		
		/**
		*	mxmlFunction is the function that Flex Builder passes when it wants to register the event "receive".
		*	This happens only when the user creates a tag and puts inline code in the "receive" tag argument
		*/
		private var mxmlFunction:Function;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................type..........................................*/
		private var _type:String;
		/**
		*  The type attribute specifies the event type you want to listen to.
		* 
		*  @default null
		*/
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			var oldValue:String = _type;
			
			if(oldValue != value)
			{
				
				/*
				*	Update the listeners because the type changed
				*/
				_type = value;
				updateListeners(value, oldValue);
			}
		}
		
		
		/*-.........................................method..........................................*/
		 
		private var _method:Function;
		/**
		 * Specifies the method to call when an event is received. Called method will automatically receive the event.
		 */
		public function get method():Function
		{
			return _method;
		}
		public function set method(value:Function):void
		{
			if(value != _method)
			{
				if(type)
				{
					if(_method != null && methodRegistered)
					{
						dispatcher.removeEventListener(type, _method);
					}
					dispatcher.addEventListener(type, value, false, priority, useWeakReference);
					methodRegistered = true;
				}
				_method = value;
			}
		}
		
		/*-.........................................priority..........................................*/
		private var _priority:int;
		
		/**
		 * 	(default = 0) — The priority level of the <code>Listener</code>. 
		 * 	The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. 
		 * 	If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.
		 * 
		 *  @default 0
		 * */
		public function get priority():int
		{
			return _priority;
		}
		public function set priority(value:int):void
		{
			_priority = value;
			updateListeners(type, type);
		}
		
		/*-.........................................useWeakReference..........................................*/
		private var _useWeakReference:Boolean = true;
		/**
		 * (default = true) — Determines whether the reference to the listener is strong or weak. 
		 * A strong reference (the default) prevents your listener from being garbage-collected. 
		 * A weak reference does not.
		 * When using modules, it is recomended to use weak references to garbage-collect unused modules
		 * 
		 *  @default true
		 * */
		public function get useWeakReference():Boolean
		{
			return _useWeakReference;
		}
		public function set useWeakReference(value:Boolean):void
		{
	        if (_useWeakReference !== value)
	        {
	        	_useWeakReference = value;
				updateListeners(type, type);
	        }
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Listener()
		{
			dispatcher = MateManager.instance.dispatcher;
			tagEventType = "receive";
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................hasEventListener..........................................*/
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event. 
		 * This allows you to determine where an EventDispatcher object has altered handling of an event type
		 * in the event flow hierarchy. To determine whether a specific event type will actually trigger an
		 * event listener, use <code>IEventDispatcher.willTrigger()</code>.
		 * 
		 * <p>The difference between <code>hasEventListener()</code> and <code>willTrigger()</code> is that <code>hasEventListener()</code>
		 * examines only the object to which it belongs, whereas <code>willTrigger()</code> examines the entire event
		 * flow for the event specified by the type parameter.</p>
		 */
		public function hasEventListener(type:String):Boolean
		{
			return (_type && type == tagEventType) ? dispatcher.hasEventListener(_type): false;
		}
		
		/*-.........................................willTrigger..........................................*/
		/**
		 * Checks whether an event listener is registered with this EventDispatcher object
		 * or any of its ancestors for the specified event type. This method returns true
		 * if an event listener is triggered during any phase of the event flow when an 
		 * event of the specified type is dispatched to this EventDispatcher object or any of its descendants.
		 * 
		 * <p>The difference between <code>hasEventListener()</code> and <code>willTrigger()</code> is that <code>hasEventListener()</code>
		 * examines only the object to which it belongs, whereas <code>willTrigger()</code> examines the entire event
		 * flow for the event specified by the type parameter.</p>
		 */
		public function willTrigger(type:String):Boolean
		{
			return (_type && type == tagEventType) ? dispatcher.hasEventListener(_type): false;
		}
		
		/*-.........................................addEventListener..........................................*/
		/*
		*	Usually this method is call by Flex Builder when a user put some inline code in the "eventFire" tag argument
		*	Instead of register "eventFire" type event we register the type that was set in the Listener tag.
		*	if that type is null we create a pending object to register it later
		*/
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. 
		 * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
		 */
		public function addEventListener(eventType:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=true):void
		{
			if(eventType == tagEventType)
			{
				if(type)
				{
					dispatcher.addEventListener(type, listener, useCapture, this.priority, useWeakReference);
					mxmlRegistered = true;
				}
				mxmlFunction = listener;
			}
		}
		
		/*-.........................................removeEventListener..........................................*/
		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with 
		 * the EventDispatcher object, a call to this method has no effect.
		 */
		public function removeEventListener(eventType:String, listener:Function, useCapture:Boolean=false):void
		{
			if(_type && eventType == tagEventType) 
				dispatcher.removeEventListener(_type, listener, useCapture);
		}
		
		/*-.........................................dispatchEvent..........................................*/
		/**
		 * Dispatches an event into the event flow. The event target is the EventDispatcher object upon which dispatchEvent() is called.
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher.dispatchEvent(event);
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Methods
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Updates the listeners when the type changes.
		 * This method unregisters the old values and registers the new values.
		 */
		protected function updateListeners(newType:String, oldType:String = null):void
		{
			
			/* 
			*	If registered, we need to unregister before register again with new values
			*/
			if(oldType)
			{
				/*
				*	If a method exists we need to remove that listener
				*/
				if(method != null && methodRegistered)
				{
					dispatcher.removeEventListener(oldType, method);
					methodRegistered = false;
				}
				/*
				*	If a mxmlFunction exists we need to remove that listener
				*/
				if(mxmlFunction != null && mxmlRegistered)
				{
					dispatcher.removeEventListener(oldType, mxmlFunction);
					mxmlRegistered = false;
				}
			}
			if(newType)
			{
				/*
				*	Checking if we need to register a method  with the new type and register it if we need it
				*/
				if(method != null)
				{
					dispatcher.addEventListener(newType, method,false, priority, useWeakReference);
					methodRegistered = true;
				}
				/*
				*	Checking if we need to register a method defined inline in the tag with the new type and register it if we need it
				*/
				if(mxmlFunction != null)
				{
					dispatcher.addEventListener(newType, mxmlFunction,false, priority, useWeakReference);
					mxmlRegistered = true;
				}
			}
		}
	}
}	
