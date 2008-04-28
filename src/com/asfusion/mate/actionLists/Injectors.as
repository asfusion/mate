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
		protected var registered:Boolean;
		
		/**
		 * The scope of this <code>InjectorHandlers</code> tag. The <code>InjectorHandlers</code> creates a new scope each time a call to
		 * <code>fireEvent</code> occurs.
		 */
		protected var scope:Scope;
		
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
	        	_target = value;
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
			if(!registered && target)
			{
				var type:String = getQualifiedClassName(target);
				dispatcher.addEventListener(type,fireEvent);
				registered = true;
				manager.addListenerProxy();
			}
		}
		
		/*-.........................................fireEvent..........................................*/
		/**
		 * Called by the dispacher when the event gets triggered.
		 * This method creates a scope and then runs the sequence.
		*/
		protected function fireEvent(event:InjectorEvent):void
		{
			scope = new Scope(event, debug, inheritedScope);
			scope.owner = this;
			runSequence(scope, actions);
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
			if(registered)
			{
				var type:String = getQualifiedClassName(target);
				event.oldDispatcher.removeEventListener(type, fireEvent);
				dispatcher.addEventListener(type,fireEvent);
			}
		}

	}
}