package com.asfusion.mate.events
{
	import flash.events.Event;
	
	/**
	 * Event that notifies when InjectorSettings changes.
	 */
	public class InjectorSettingsEvent extends Event
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Static Constants
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Type that indicates that the injectors type has been changed.
		 */
		public static const TYPE_CHANGE:String = "changeInjectorSettingsEvent";
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * The new injectors event type value.
		 */
		public var globalType:String;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/	
		public function InjectorSettingsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}