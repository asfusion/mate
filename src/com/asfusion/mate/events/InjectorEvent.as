package com.asfusion.mate.events
{
	import flash.events.Event;
	
	/**
	 * This event is used by the InjectorRegistry to register a target for Injection.
	 */
	public class InjectorEvent extends Event
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Target that wants to register for Injection.
		 */
		public var injectorTarget:Object;
		
		/**
		 * Unique identifier to distinguish the target
		 */
		public var uid:*;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		/**
		 * Constructor
		 */
		public function InjectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}