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
	import com.asfusion.mate.events.DispatcherEvent;
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
		 * Internal instance of <code>IEventMap</code>.
		 */
		protected var map:IEventMap;
		
		/**
		 * Parent scope that is passed to the IActionList when it is a sub-ActionList.
		 */
		protected var inheritedScope:IScope;
		
		/**
		 * Flag indicating whether the <code>dispatcherType</code> has been changed and needs invalidation.
		 */
		protected var dispatcherTypeChanged:Boolean;
		
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
		
		
		
		/*-.........................................scope..........................................*/
		private var _scope:IScope;
		[Bindable (event="scopeChange")]
		/**
		 * @inheritDoc
		 */
		public function get scope():IScope
		{
			return _scope;
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
		
		/*-.........................................dispatcherType..........................................*/
		private var _dispatcherType:String = "inherit";
		/**
		 * String that defines whether the dispatcher used by this tag is <code>global</code> or 
		 * <code>inherit</code>. If it is <code>inherit</code>, the dispatcher used is the 
		 * dispatcher provided by the EventMap where this tag lives.
		 */
		public function get dispatcherType():String
		{
			return _dispatcherType;
		}
		[Inspectable(enumeration="inherit,global")]
		public function set dispatcherType(value:String):void
		{
			var oldValue:String = _dispatcherType;
			if(oldValue != value)
			{
				if(oldValue == "global")
				{
					manager.removeEventListener(DispatcherEvent.CHANGE, dispatcherChangeHandler, false);
				}
				else if(oldValue == "inherit" && map)
				{
					map.removeEventListener(DispatcherEvent.CHANGE, dispatcherChangeHandler, false);
				}
				if(value == "global")
				{
					manager.addEventListener(DispatcherEvent.CHANGE, dispatcherChangeHandler, false, 0, true);
				}
				else if(value == "inherit" && map)
				{
					map.addEventListener(DispatcherEvent.CHANGE, dispatcherChangeHandler, false, 0, true);
				}
				_dispatcherType = value;
				dispatcherTypeChanged = true;
				validateNow();
			}
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Mate Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................dispatcher........................................*/
		protected var currentDispatcher:IEventDispatcher;
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
			if(_dispatcher)
			{
				currentDispatcher = _dispatcher;
			}
			else
			{
				if(dispatcherType == "global")
				{
					currentDispatcher = manager.dispatcher;
				}
				else if(dispatcherType == "inherit" && map)
				{
					currentDispatcher = map.getDispatcher();
				}
			}
			return currentDispatcher;
		}
		mate function set dispatcher(value:IEventDispatcher):void
		{
			var oldValue:IEventDispatcher = _dispatcher;
			if(_dispatcher !== value)
			{
				currentDispatcher = _dispatcher = value;
				dispatcherType = "local";
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
		 }
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................setDispatcher..........................................*/
		/**
		 * @inheritDoc
		 */ 
		public function setDispatcher(value:IEventDispatcher, local:Boolean = true):void
		{
			if(local)
			{
				dispatcher = value;
			}
			else if(!_dispatcher)
			{
				currentDispatcher = value
			}
			validateNow();
		}
		
		/*-.........................................invalidateProperties..........................................*/
		private var needsInvalidation:Boolean;
		/**
		*  @inheritDoc
		*/
		public function invalidateProperties():void
		{
			if( !isInitialized ) needsInvalidation = true;
			else commitProperties();
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
		
		/**
		 * Internal storage for a group id.
		 */
		private var _groupId:int = -1;
		
		/*-.........................................setGroupIndex..........................................*/
		/**
		 *  @inheritDoc
		*/
		public function setGroupId(id:int):void
		{
			_groupId = id;
		}
		
		/*-.........................................clearReferences..........................................*/
		/**
		 *  @inheritDoc
		*/
		public function clearReferences():void
		{
			// this method is abstract it will be implemented by children
		}
		
		/*-.........................................getGroupIndex..........................................*/
		/**
		 * @inheritDoc
		*/
		public function getGroupId():int
		{
			return _groupId;
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
			_scope = null;
		}
		
		/*-.........................................commitProperties..........................................*/
		/**
		 * Processes the properties set on the component.
		*/
		protected function commitProperties():void
		{
			// this method is abstract it will be implemented by children
		}
		
		/*-.........................................setScope..........................................*/
		/**
		 * Set the scope on this IActionList.
		*/
		protected function setScope(scope:IScope):void
		{
			_scope = scope;
			dispatchEvent( new ActionListEvent(ActionListEvent.SCOPE_CHANGE));
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Event Handlers
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................handleDispatcherChange..........................................*/
		/**
		 * A handler for the mate dispatcher changed.
		 * This method is called by <code>IMateManager</code> when the dispatcher changes.
		*/
		protected function dispatcherChangeHandler(event:DispatcherEvent):void
		{
			setDispatcher(event.newDispatcher,false);
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
		private var isInitialized:Boolean;
		/**
		 * Called automatically by the MXML compiler if the IActionList is set up using a tag.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
			if(document is IEventMap)
			{
				map = IEventMap(document);
			}
			if(dispatcherType == "inherit" && map)
			{
				var inheritDispatcher:IEventDispatcher = map.getDispatcher();
				
				map.addEventListener(DispatcherEvent.CHANGE, dispatcherChangeHandler, false, 0, true);
				if(inheritDispatcher)
				{
					setDispatcher(inheritDispatcher, false);
				}
			}
			else if(dispatcherType == "global")
			{
				setDispatcher(manager.dispatcher,false);
			}
			
			if( needsInvalidation )
			{
				commitProperties();
				needsInvalidation = false;
			}
			isInitialized = true;
		}
	}
}