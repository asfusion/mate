package com.asfusion.mate.events
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * This event is used by the InjectorRegistry to register a target for Injection.
	 */
	public class InjectorEvent extends Event
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Constants
		//------------------------------------------------------------------------------------------------------------
		
		public static const INJECT_DERIVATIVES:String = "injectDerivativesInjectorEvent";
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Properties
		//------------------------------------------------------------------------------------------------------------
		/**
		 * Target that wants to register for Injection.
		 */
		public var injectorTarget:Object;
		
		/**
		 * Unique identifier to distinguish the target
		 */
		public var uid:*;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Constructor
		//-------------------------------------------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function InjectorEvent(type:String, target:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			injectorTarget = target;
			if(target.hasOwnProperty("id"))
			{
				uid = target["id"];
			}
			
			if( !type ) type = getQualifiedClassName(target);
				
			super(type, bubbles, cancelable);
		}
		
	}
}