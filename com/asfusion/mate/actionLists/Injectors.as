package com.asfusion.mate.actionLists
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.events.MateManagerEvent;
	import com.asfusion.mate.utils.debug.DebuggerUtil;
	
	import flash.utils.getQualifiedClassName;
	
	use namespace mate;
	
	
	/**
	 * An <code>Injectors</code> defined in the <code>EventMap</code> will run whenever an instance of the 
	 * class specified in the <code>Injectors</code>'s "target" argument is created.
	 */
	public class Injectors extends AbstractHandlers
	{
		/**
		 * Flag indicating if this <code>InjectorHandlers</code> is registered to listen to a target or not.
		 */
		protected var targetRegistered:Boolean;
		
		/**
		 * Flag indicating if this <code>InjectorHandlers</code> is registered to listen to a target list or not.
		 */
		protected var targetsRegistered:Boolean;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................target..........................................*/
		private var _target:Class;
		/**
		 * The class that, when an object is created, should trigger the <code>InjectorHandlers</code> to run. 
		 * 
		 *  @default null
		 * */
		public function get target():Class
		{
			return _target;
		}
		public function set target(value:Class):void
		{
			var oldValue:Class = _target;
	        if (oldValue !== value)
	        {
	        	if(targetRegistered) unregister(oldValue);
	        	_target = value;
	        	validateNow();
	        }
		}
		
		/*-.........................................targets..........................................*/
		private var _targets:Array;
		/**
		 * An array of classes that, when an object is created, should trigger the <code>InjectorHandlers</code> to run. 
		 * 
		 *  @default null
		 * */
		public function get targets():Array
		{
			return _targets;
		}
		public function set targets(value:Array):void
		{
			var oldValue:Array = _targets;
	        if (oldValue !== value)
	        {
	        	if(targetRegistered) unregister(oldValue);
	        	_targets = value;
	        	validateNow()
	        }
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		 public function Injectors()
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
			var str:String = "Injector target:"+ DebuggerUtil.getClassName(target) + ". Error was found in a Injectors list in file " 
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
			if(!targetRegistered && target)
			{
				var type:String = getQualifiedClassName(target);
				dispatcher.addEventListener(type,fireEvent);
				targetRegistered = true;
			}
			
			if(!targetsRegistered && targets)
			{
				for each( var currentTarget:Class in targets)
				{
					var currentType:String = getQualifiedClassName(currentTarget);
					dispatcher.addEventListener(currentType,fireEvent);
				}
				targetsRegistered = true;
			}
			manager.addListenerProxy();
		}
		
		/*-.........................................fireEvent..........................................*/
		/**
		 * Called by the dispacher when the event gets triggered.
		 * This method creates a scope and then runs the sequence.
		*/
		protected function fireEvent(event:InjectorEvent):void
		{
			var currentScope:Scope = new Scope(event, debug, inheritedScope);
			currentScope.owner = this;
			setScope(currentScope);
			runSequence(currentScope, actions);
		}
		
		/*-.........................................unregister..........................................*/
		/**
		 * Unregisters a target/s. Used internally whenever a new target/s is set.
		*/
		protected function unregister(obj:Object):void
		{
			if(obj is Class)
			{
				var type:String = getQualifiedClassName(obj);
				dispatcher.removeEventListener(type, fireEvent);
			}
			else if(obj is Array)
			{
				for each( var currentTarget:Class in targets)
				{
					var currentType:String = getQualifiedClassName(currentTarget);
					dispatcher.removeEventListener(currentType, fireEvent);
				}
			}
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
			if(targetRegistered)
			{
				var type:String = getQualifiedClassName(target);
				event.oldDispatcher.removeEventListener(type, fireEvent);
				dispatcher.addEventListener(type,fireEvent);
			}
			if(targetsRegistered)
			{
				for each( var currentTarget:Class in targets)
				{
					var currentType:String = getQualifiedClassName(currentTarget);
					event.oldDispatcher.removeEventListener(currentType, fireEvent);
					dispatcher.addEventListener(currentType,fireEvent);
				}
			}
		}

	}
}