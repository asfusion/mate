package com.asfusion.mate.actionLists
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.utils.debug.DebuggerUtil;
	
	import flash.events.IEventDispatcher;
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
	        	if(targetRegistered) unregister();
	        	_target = value;
	        	validateNow();
	        }
		}
		
		//.........................................lazyTarget..........................................*/
		private var _lazyTarget:String;
		/**
		 * The whole string path class that, when an object is created, should trigger the <code>InjectorHandlers</code> to run. 
		 * 
		 *  @default null
		 * */
		public function get lazyTarget():String
		{
			return _lazyTarget;
		}
		public function set lazyTarget(value:String):void
		{
			var oldValue:String = _lazyTarget;
	        if (oldValue !== value)
	        {
	        	if(targetRegistered) unregister();
	        	_lazyTarget = value;
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
	        	if(targetRegistered) unregister();
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
			if(!dispatcher) return;
			
			if(dispatcherTypeChanged)
			{
				dispatcherTypeChanged = false;
				unregister();
			}
			if(!targetRegistered)
			{
				var type:String;
				type = (target) ? getQualifiedClassName(target) : lazyTarget;
				if(type)
				{
					dispatcher.addEventListener(type,fireEvent,false,0, true);
					targetRegistered = true;
					manager.addListenerProxy(dispatcher);				
				}				
			}
			
			if(!targetsRegistered && targets)
			{
				for each( var currentTarget:Class in targets)
				{
					var currentType:String = getQualifiedClassName(currentTarget);
					dispatcher.addEventListener(currentType,fireEvent,false,0, true);
				}
				targetsRegistered = true;
				manager.addListenerProxy(dispatcher);
			}
		}
		
		/*-.........................................fireEvent..........................................*/
		/**
		 * Called by the dispacher when the event gets triggered.
		 * This method creates a scope and then runs the sequence.
		*/
		protected function fireEvent(event:InjectorEvent):void
		{
			var currentScope:Scope = new Scope(event, debug, map, inheritedScope);
			currentScope.owner = this;
			setScope(currentScope);
			runSequence(currentScope, actions);
		}
		
		/*-.........................................unregister..........................................*/
		/**
		 * Unregisters a target or targets. Used internally whenever a new target/s is set or dispatcher changes.
		*/
		protected function unregister():void
		{
			if(!dispatcher) return;
			
			if(target || lazyTarget)
			{
				if(targetRegistered)
				{
					var type:String = (target) ? getQualifiedClassName(target) : lazyTarget;
					dispatcher.removeEventListener(type, fireEvent);
					targetRegistered = false;
				}
			}
			if(targets && targetsRegistered)
			{
				if(targetsRegistered)
				{
					for each( var currentTarget:Class in targets)
					{
						var currentType:String = getQualifiedClassName(currentTarget);
						dispatcher.removeEventListener(currentType, fireEvent);
					}
					targetsRegistered = false;
				}
			}
		}
		/*-.........................................setDispatcher..........................................*/
		/**
		 * @inheritDoc
		 */ 
		override public function setDispatcher(value:IEventDispatcher, local:Boolean = true):void
		{
			if(currentDispatcher && currentDispatcher != value)
			{
				if(targetRegistered)
				{
					unregister();
				}
				if(targetsRegistered)
				{
					unregister();
				}
			}
			super.setDispatcher(value,local);
		}

	}
}