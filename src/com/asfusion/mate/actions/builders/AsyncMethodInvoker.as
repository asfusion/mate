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
	import com.asfusion.mate.actionLists.*;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.ActionListEvent;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * AsyncMethodInvoker allows to calling an asynchronous function specified in the <code>method</code> 
	 * attribute on the newly created <code>EventDispatcher</code> object or in the instance if that is provided. 
	 * Because the method is asynchronous, we register to a success and falut events in this object and run the 
	 * successHandlers or faultHandlers depending of the result. When you are making the asynchronous call, 
	 * you can pass arguments to this function that come from a variety of sources, such as the event itself, 
	 * a server result object, or any other value.Unless you specify cache="none", this <code>AsyncMethodInvoker</code> 
	 * instance will be "cached" and not instantiated again. If you are using an instace we never generate the 
	 * object and use the same instance.
	 */
	public class AsyncMethodInvoker extends MethodInvoker
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Protected Properties
		-------------------------------------------------------------------------------------------------------------*/
		
		/**
		 * Index used to store groups of inner handlers.
		 */
		protected var currentIndex:int = 0;
		
		/**
		 * Inner handlers list that stores all inner handlers indexed by the currentIndex.
		 */
		protected var innerHandlersList:Array = new Array();
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................successHandlers..........................................*/
		private var _successHandlers:Array;
		/**
		 * A set of inner-handlers to run when the call returns a <em>success</em>. Inside this inner-handlers, 
		 * you can use the same tags you would in the main body of a <code>IActionList</code>,
		 * including service calls.
		 * 
		 * @default null
		 */
		public function get successHandlers():Array
		{
			return _successHandlers;
		}
		
		[ArrayElementType("com.asfusion.mate.actions.IAction")]
		public function set successHandlers(value:Array):void
		{
			_successHandlers = value;
		}
		
		/*-.........................................successType..........................................*/
		private var _successType:String;
		/**
		 * Event type that will be used to register to the success event.
		 */
		public function get successType():String
		{
			return _successType;
		}
		
		public function set successType(value:String):void
		{
			_successType = value;
		}
		
		/*-.........................................faultType..........................................*/
		private var _faultType:String;
		/**
		 * Event type that will be used to register to the fault event.
		 */
		public function get faultType():String
		{
			return _faultType;
		}
		
		public function set faultType(value:String):void
		{
			_faultType = value;
		}
		
		/*-.........................................faultHandlers..........................................*/
		private var _faultHandlers:Array;
		/**
		 * A set of inner-handlers to run when the call returns a <em>fault</em>. Inside this inner-handlers, 
		 * you can use the same tags you would in the main body of a <code>IActionList</code>,
		 * including service calls.
		 * 
		 * @default null
		 */
		public function get faultHandlers():Array
		{
			return _faultHandlers;
		}
		
		[ArrayElementType("com.asfusion.mate.actions.IAction")]
		public function set faultHandlers(value:Array):void
		{
			_faultHandlers = value;
		}
		
		/*-.........................................debug..........................................*/
		private var _debug:Boolean;
		/**
		 * Whether to show debugging information for its <em>inner-handlers</em>s. If true, 
		 * console output will show debugging information for all <em>inner-handlers</em> 
		 * (resultHandlers and faultHandlers)
		 * 
		 * @default false
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		[Inspectable(enumeration="true,false")]
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}
		
		/*-.........................................innerHandlersClass..........................................*/
		private var _innerHandlersClass:Class = EventHandlers;
		/**
		 * Class that is used as a template to create the inner-handlers
		 * 
		 * @default EventHandlers
		 */
		public function get innerHandlersClass():Class
		{
			return _innerHandlersClass;
		}
		public function set innerHandlersClass(value:Class):void
		{
			_innerHandlersClass = value;
		}
		
		/*-.........................................instance..........................................*/
		/**
		 * If this property is null, a new object instance is created on 
		 * the <code>prepare</code> method. Otherwise, this instance will be used.
		 * The class that will be used to create the instance if none is provided is
		 * the one specified in the generetor property.
		 * 
		 * @default null
		 */
		public function get instance():IEventDispatcher
		{
			return currentInstance;
		}
		public function set instance(value:IEventDispatcher):void
		{
			currentInstance = value;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................prepare..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			super.prepare(scope);
			currentIndex++;
		}
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(successHandlers && successType)
			{
				var successHandlersInstance:IActionList = createInnerHandlers(scope,  
																				successType, 
																				successHandlers, 
																				currentInstance);
				successHandlersInstance.validateNow();
			}
			if(faultType && faultHandlers)
			{
				var faultHandlersInstance:IActionList = createInnerHandlers(scope,  
																				faultType, 
																				faultHandlers, 
																				currentInstance); 
				faultHandlersInstance.validateNow();
			}
			super.run(scope);
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................createInnerHandlers..........................................*/
		/**
		 * Creates IActionList and sets the properties:
		 * debug, type, listeners, dispatcher and inheritScope in the newly IActionList (inner-handlers).
		 * 
		 */
		protected function createInnerHandlers(scope:IScope,  
											innerType:String, 
											actionList:Array,
											innerDispatcher:IEventDispatcher):IActionList
		{
			var innerHandlers:IActionList = new innerHandlersClass();
			innerHandlers.setInheritedScope(scope);
			innerHandlers.setDispatcher(innerDispatcher);
			innerHandlers.actions = actionList;
			innerHandlers.initialized(document, null);
			
			if(innerHandlers is EventHandlers)
			{
				EventHandlers(innerHandlers).type = innerType;
			}
			
			var siblings:Array =  innerHandlersList[currentIndex];
			if(siblings == null)
			{
				siblings = new Array();
				innerHandlersList[currentIndex] = siblings;
			}
			innerHandlers.setGroupId(currentIndex);
			innerHandlers.addEventListener(ActionListEvent.START, actionListStartHandler, false, 0, true);
			siblings.push(innerHandlers);
			
			innerHandlers.debug = debug;
			return innerHandlers;
		}
		
		/*-.........................................actionListStartHandler..........................................*/
		/**
		 * Handler that will be fired when the first of the innerHandlers starts executing.
		 */
		protected function actionListStartHandler(event:ActionListEvent):void
		{
			if(event.target is IActionList)
			{
				var innerHandlers:IActionList = IActionList(event.target);
				var siblings:Array = innerHandlersList[innerHandlers.getGroupId()];
				for each(var handlers:IActionList in siblings)
				{
					handlers.removeEventListener(ActionListEvent.START, actionListStartHandler);
					handlers.clearReferences();
				}
				innerHandlersList[innerHandlers.getGroupId()] = null;
			}
		}
	}
}