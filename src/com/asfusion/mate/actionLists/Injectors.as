package com.asfusion.mate.actionLists
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.utils.debug.DebuggerUtil;
	
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
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
		
		/**
		 * Flag indicating if the includeDerivatives property has been changed.
		 */
		 protected var includeDerivativesChanged:Boolean;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Setters and Getters
		//-----------------------------------------------------------------------------------------------------------
		//.........................................target..........................................
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
		
		//.........................................targets..........................................
		private var _targets:Array;
		/**
		 * An array of classes that, when an object is created, should trigger the <code>InjectorHandlers</code> to run. 
		 * 
		 *  @default true
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
		
		//.........................................includeDerivatives..........................................
		private var _includeDerivatives:Boolean = false;
		/**
		 * If this property is true, the injector will inject not only the Class in the
		 * target property, but also all the classes that extend from that class. 
		 * If the target is an interface, it will inject all the objects that implement
		 * the interface.
		 * 
		 *  @default false
		 * */
		public function get includeDerivatives():Boolean
		{
			return _includeDerivatives;
		}
		public function set includeDerivatives(value:Boolean):void
		{
			var oldValue:Boolean = _includeDerivatives;
	        if (oldValue !== value)
	        {
	        	_includeDerivatives = value;
	        	includeDerivativesChanged = true;
	        	validateNow()
	        }
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Constructor
		//------------------------------------------------------------------------------------------------------------	
		/**
		 * Constructor
		 */
		 public function Injectors()
		 {
		 	super();
		 }
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Methods
		//-------------------------------------------------------------------------------------------------------------
		
		
		//.........................................errorString..........................................
		/**
		 * @inheritDoc
		 */ 
		override public function errorString():String
		{
			var str:String = "Injector target:"+ DebuggerUtil.getClassName(target) + ". Error was found in a Injectors list in file " 
							+ DebuggerUtil.getClassName(document);
			return str;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Protected Methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................commitProperties..........................................
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
			
			
			if(!targetRegistered && target)
			{
				var type:String = getQualifiedClassName(target);
				dispatcher.addEventListener( type, fireEvent, false, 0, true );
				targetRegistered = true;
			}
			
			if(!targetsRegistered && targets)
			{
				for each( var currentTarget:* in targets)
				{
					var currentType:String = ( currentTarget is Class) ? getQualifiedClassName( currentTarget ) : currentTarget;
					dispatcher.addEventListener( currentType, fireEvent, false, 0, true);
				}
				targetsRegistered = true;
			}
			
			if( target ||  targets) 
			{
				manager.addListenerProxy( dispatcher );
				if(includeDerivativesChanged)
				{
					includeDerivativesChanged = false;
					if(includeDerivatives)
					{
						dispatcher.addEventListener( InjectorEvent.INJECT_DERIVATIVES, injectDerivativesHandler, false, 0, true);
					}
					else
					{
						dispatcher.removeEventListener( InjectorEvent.INJECT_DERIVATIVES, injectDerivativesHandler );
					}
				}
			}
		}
		
		//.........................................fireEvent..........................................
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
		
		//.........................................unregister..........................................
		/**
		 * Unregisters a target or targets. Used internally whenever a new target/s is set or dispatcher changes.
		*/
		protected function unregister():void
		{
			if(!dispatcher) return;
			
			if( targetRegistered && target )
			{
				var type:String = getQualifiedClassName(target);
				dispatcher.removeEventListener(type, fireEvent);
				targetRegistered = false;
			}
			
			if( targets && targetsRegistered )
			{
				for each( var currentTarget:* in targets)
				{
					var currentType:String = ( currentTarget is Class) ? getQualifiedClassName(currentTarget) : currentTarget;
					dispatcher.removeEventListener(currentType, fireEvent);
				}
				targetsRegistered = false;
			}
		}
		//.........................................setDispatcher..........................................
		/**
		 * @inheritDoc
		 */ 
		override public function setDispatcher(value:IEventDispatcher, local:Boolean = true):void
		{
			if(currentDispatcher && currentDispatcher != value)
			{
				unregister();
			}
			super.setDispatcher(value,local);
		}
		
		//.........................................injectDerivativesHandler..........................................
		/**
		 * This function is a handler for the injection event, if the target it is a 
		 * derivative class the injection gets triggered
		 */ 
		protected function injectDerivativesHandler( event:InjectorEvent ):void
		{
			if( isDerivative( event.injectorTarget, target  ) )
			{
				fireEvent( event );
			}
			else if( targets )
			{
				for each( var currentTarget:* in targets)
				{
					if( isDerivative( event.injectorTarget, currentTarget  ) )
					{
						fireEvent( event );
					}
				}
			}
		}
		
		//.........................................isDerivative..........................................
		/**
		 * Check if the current object is a derivative class and return a boolean value
		 * true / false.
		 */
		 protected function isDerivative( injectorTarget:Object, targetClass:* ):Boolean
		 {
		 	if( !targetClass ) return false;
		 	
		 	var foundDerivative:Boolean = false;
		 	
		 	var compareClass:Class = ( targetClass is Class ) ? targetClass : getDefinitionByName( targetClass ) as Class;
		 	if( injectorTarget is compareClass )
		 	{
		 		var targetClassName:String = getQualifiedClassName( injectorTarget );
		 		var compareClassName:String = getQualifiedClassName( compareClass );
		 		foundDerivative = ( targetClassName !==  compareClassName );
		 	}
		 	return foundDerivative;
		 }
		
	}
}