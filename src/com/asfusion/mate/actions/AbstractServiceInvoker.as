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
	import com.asfusion.mate.actionLists.*;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.ActionListEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	
	/**
	 * AbstractServiceInvoker is the base class for all the <code>IAction</code> that have inner-handlers/actions.
	 * 
	 * <p>This class has 2 inner-handlers <code>resultHandlers</code> and <code>faultHandlers</code>, but
	 * it provides the ability to have more by creating new inner-handlers with the method <code>createInnerHandlers</code>.</p>
	 */
	public class AbstractServiceInvoker extends BaseAction
	{
		
		/**
		 * Dispatcher that will trigger the inner-handlers execution by 
		 * dispatching events (ie: ResultEvent or FaultEvent).
		 */
		protected var innerHandlersDispatcher:IEventDispatcher;
		
		/**
		 * Class that is used as a template to create the inner-handlers
		 * 
		 * @default EventHandlers
		 */
		protected var innerHandlersClass:Class = EventHandlers;
		
		/**
		 * Index used to store groups of inner handlers.
		 */
		protected var currentIndex:int = 0;
		
		/**
		 * When auto unregistration is true, all inner handlers will be
   		 * unregistered after the first inner handlers fires.
		 */
		protected var autoUnregistration:Boolean = true;
		
		/**
		 * Inner handlers list that stores all inner handlers indexed by the currentIndex.
		 */
		protected var innerHandlersList:Array = new Array();
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................resultHandlers..........................................*/
		private var _resultHandlers:Array;
		/**
		 * A set of inner-handlers to run when the server call returns a <em>result</em>. Inside this inner-handlers, 
		 * you can use the same tags you would in the main body of a <code>IActionList</code>,
		 * including other service calls.
		 * 
		 * @default null
		 */
		public function get resultHandlers():Array
		{
			return _resultHandlers;
		}
		
		[ArrayElementType("com.asfusion.mate.actions.IAction")]
		public function set resultHandlers(value:Array):void
		{
			_resultHandlers = value;
		}
		
		
		/*-.........................................faultHandlers..........................................*/
		private var _faultHandlers:Array;
		/**
		 * A set of inner-handlers to run when the server call returns a <em>fault</em>. Inside this inner-handlers, 
		 * you can use the same tags you would in the main body of a <code>IActionList</code>,
		 * including other service calls.
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
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................prepare..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			currentIndex++;
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
											innerHandlersClass:Class = null):IActionList
		{
			var innerHandlers:IActionList = (innerHandlersClass != null) ? new innerHandlersClass() : new this.innerHandlersClass();
			innerHandlers.setInheritedScope(scope);
			innerHandlers.setDispatcher(innerHandlersDispatcher);
			innerHandlers.actions = actionList;
			innerHandlers.initialized(document, null);
			
			if(innerHandlers is EventHandlers)
			{
				EventHandlers(innerHandlers).type = innerType;
			}
			if(autoUnregistration)
			{
				var siblings:Array =  innerHandlersList[currentIndex];
				if(siblings == null)
				{
					siblings = new Array();
					innerHandlersList[currentIndex] = siblings;
				}
				innerHandlers.setGroupId(currentIndex);
				innerHandlers.addEventListener(ActionListEvent.START, actionListStartHandler, false, 0, true);
				siblings.push(innerHandlers);
			}
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