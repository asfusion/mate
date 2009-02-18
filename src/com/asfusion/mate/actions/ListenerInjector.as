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

package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.events.InjectorEvent;
	import mx.core.EventPriority;
	import flash.events.IEventDispatcher;
	
	/**
	 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
	 */
	public class ListenerInjector extends AbstractAction implements IAction
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Setters and Getters
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................dispatcher..........................................
		private var _dispatcher:Object;
		/**
		 * Event Dispatcher to which we will register to listen to events.
		 * It can be an ISmartObject or an IEventDispatcher.
		 */
		public function get dispatcher():Object
		{
			return _dispatcher;
		}
		public function set dispatcher(value:Object):void
		{
			_dispatcher = value;
		}
		
		//.........................................eventType..........................................
		private var _eventType:String;
		/**
		 * The type of event that we want to register to listen to.
		 */
		public function get eventType():String
		{
			return _eventType;
		}
		public function set eventType(value:String):void
		{
			_eventType = value;
		}
		
		//.........................................method..........................................
		private var _method:String;
		/**
		 * The listener function that processes the event. This function must accept an Event object
		 * as its only parameter and must return nothing
		 */
		public function get method():String
		{
			return _method;
		}
		public function set method(value:String):void
		{
			_method = value;
		}
		
		//.........................................useCapture..........................................
		private var _useCapture:Boolean;
		/**
		 * Determines whether the listener works in the capture phase or the target and bubbling phases. 
		 * If useCapture is set to true, the listener processes the event only during the capture phase 
		 * and not in the target or bubbling phase. If useCapture is false, the listener processes the 
		 * event only during the target or bubbling phase.
		 */
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
		public function set useCapture(value:Boolean):void
		{
			_useCapture = value;
		}
		
		//.........................................useWeakReference..........................................
		private var _useWeakReference:Boolean = true;
		/**
		 * Determines whether the reference to the listener is strong or weak. A strong reference 
		 * prevents your listener from being garbage-collected. A weak reference does not.
		 * 
		 *  @default true
		 */
		public function get useWeakReference():Boolean
		{
			return _useWeakReference;
		}
		public function set useWeakReference(value:Boolean):void
		{
			_useWeakReference = value;
		}
		
		//.........................................priority..........................................
		private var _priority:int = EventPriority.DEFAULT;
		/**
		 * The priority level of the event listener. The priority is designated by a signed 32-bit integer. 
		 * The higher the number, the higher the priority. All listeners with priority n are processed 
		 * before listeners of priority n-1. If two or more listeners share the same priority, they 
		 * are processed in the order in which they were added. The default priority is 0.
		 */
		public function get priority():int
		{
			return _priority;
		}
		public function set priority(value:int):void
		{
			_priority = value;
		}
		
		//........................................targetId..........................................
		private var _targetId:String;
		/**
		 * This tag will run if any of the following statements is true:
		 * If the targetId is null.
		 * If the id of the target matches the targetId.
		 * 
		 * Note:Target is the instance of the target class.
		 * 
		 * @default null
		 * */
		public function get targetId():String
		{
			return _targetId;
		}
		public function set targetId(value:String):void
		{
			_targetId = value;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Override protected methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................run.................................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(!scope.event is InjectorEvent) return;
			
			var event:InjectorEvent = InjectorEvent(scope.event);
			if(eventType && (targetId == null || targetId == event.uid))
			{
				if(event.injectorTarget.hasOwnProperty(method) && event.injectorTarget[method] is Function)
				{
					var targetFunction:Function = event.injectorTarget[method];
					var currentDispatcher:Object = (currentDispatcher is ISmartObject) ? ISmartObject(currentDispatcher).getValue(scope) : currentDispatcher;
					if(!currentDispatcher) currentDispatcher = scope.dispatcher;
					
					if(currentDispatcher is IEventDispatcher)
					{
						IEventDispatcher(currentDispatcher).addEventListener(eventType, targetFunction, useCapture, priority, useWeakReference);
					}
				}
			}
		}
	}
}
