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
	import com.asfusion.mate.actions.IAction;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.ActionListEvent;
	import com.asfusion.mate.events.MateManagerEvent;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	import flash.events.*;
	
	import mx.core.IMXMLObject;
	
	use namespace mate;
	
	[DefaultProperty("actions")]
	[Exclude(name="activate", kind="event")]
	[Exclude(name="deactivate", kind="event")]
	
	/**
	 *  This event is dispatched right before the list of IActions are called, 
	 *  when the IActionList starts execution.
	 * 
	 *  @eventType com.asfusion.mate.events.ActionListEvent.START
	 */
	[Event(name="start", type="com.asfusion.mate.events.ActionListEvent")]
	

	/**
	 *  This event is dispatched right after all the IActions have been called, 
	 *  when the IActionList ends execution (although this event might be dispatched before asynchronous calls have returned).
	 * 
	 *  @eventType com.asfusion.mate.events.ActionListEvent.END
	 */
	[Event(name="end", type="com.asfusion.mate.events.ActionListEvent")]
	
	/**
	 * AbstractHandlers is a base class for all the IActionList implementations.
	 */
	public class AbstractHandlers extends EventDispatcher implements IMXMLObject, IActionList
	{
		
		/**
		 * Internal instance of <code>IMateManager</code>.
		 */
		protected var manager:IMateManager;
		
		/**
		 * Parent scope that is passed to the IActionList when it is a sub-ActionList.
		 */
		protected var inheritedScope:IScope;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................actions..........................................*/
		private var _actions:Array;
		/**
		 * @inheritDoc
		 */
		public function get actions():Array
		{
			return _actions;
		}
		[ArrayElementType("com.asfusion.mate.actions.IAction")]
		public function set actions(value:Array):void
		{
			_actions = value;
		}
		
		
		
		/*-.........................................debug..........................................*/
		private var _debug:Boolean;
		/**
		 * @inheritDoc
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
		*                                          Mate Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................dispatcher........................................*/
		private  var _dispatcher:IEventDispatcher;
		/**
		 * 	The IActionList registers itself as an event listener of the dispatcher specified in this property. 
		 *  By the default, this dispatcher is the Application. dispatcher property only available when using mate namespace
		 * 
		 *  @default Application.application
		 * 
		 */
		mate function get dispatcher():IEventDispatcher
		{
			return (_dispatcher == null ) ? manager.dispatcher : _dispatcher;
		}
		mate function set dispatcher(value:IEventDispatcher):void
		{
			var oldValue:IEventDispatcher = _dispatcher;
			if(_dispatcher !== value)
			{
				_dispatcher = value;
			}
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		 public function AbstractHandlers()
		 {
		 	manager = MateManager.instance;
			manager.addEventListener(MateManagerEvent.DISPATCHER_CHANGE, handleDispatcherChange);
		 }
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................setDispatcher..........................................*/
		/**
		 * @inheritDoc
		 */ 
		public function setDispatcher(value:IEventDispatcher):void
		{
			dispatcher = value;
		}
		
		/*-.........................................invalidateProperties..........................................*/
		/**
		*  @inheritDoc
		*/
		public function invalidateProperties():void
		{
			manager.callLater(commitProperties)
		}
		
		/*-.........................................setInheritScope..........................................*/
		/**
		 * @inheritDoc
		 */ 
		public function setInheritedScope(inheritedScope:IScope):void
		{
			this.inheritedScope = inheritedScope;
		}
		
		/*-.........................................validateNow..........................................*/
		/**
		 * @inheritDoc
		 */ 
		public function validateNow():void
		{
			commitProperties();
		}
		
		/*-.........................................errorString..........................................*/
		/**
		 * @inheritDoc
		 */ 
		public function errorString():String
		{
			var str:String = "Error was found in a AbstractHandlers in file " + document;
			return str;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................runSequence..........................................*/
		/**
		 * Goes over all the listeners (<code>IAction</code>s)
		 * and calls the method <code>trigger</code> on them, passing the scope as an argument.
		 * It also dispatches the <code>start</code> and <code>end</code> sequence events.  
		*/
		protected function runSequence(scope:IScope, actionList:Array):void
		{
			scope.getLogger().info( LogTypes.SEQUENCE_START, new LogInfo(scope, null ));
			dispatchEvent( new ActionListEvent(ActionListEvent.START, scope.event));
			
			for each(var action:IAction in actionList)
			{
				if(scope.isRunning()) 
				{
					scope.currentTarget = action;
					scope.getLogger().info( LogTypes.SEQUENCE_TRIGGER, new LogInfo( scope,  null ));
					action.trigger(scope);
				}
			}
			
			dispatchEvent(new ActionListEvent(ActionListEvent.END));
			scope.getLogger().debug( LogTypes.SEQUENCE_END, new LogInfo(scope, null));
		}
		
		/*-.........................................commitProperties..........................................*/
		/**
		 * Processes the properties set on the component.
		*/
		protected function commitProperties():void
		{
			// this method is abstract it will be implemented by children
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Event Handlers
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................handleDispatcherChange..........................................*/
		/**
		 * A handler for the mate dispatcher changed.
		 * This method is called by <code>IMateManager</code> when the dispatcher changes.
		*/
		protected function handleDispatcherChange(event:MateManagerEvent):void
		{
			setDispatcher(event.newDispatcher);
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Implementation of IMXMLObject interface
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................document..........................................*/
		/**
		 * Internal storage for the document object.
		 */
		protected var document:Object;
		
		/*-.........................................getDocument..........................................*/
		/**
		 * @inheritDoc
		 */
		public function getDocument():Object
		{
			return document;
		}
		
		/*-.........................................initialized..........................................*/
		/**
		 * Called automatically by the MXML compiler if the IActionList is set up using a tag.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
		}
	}
}