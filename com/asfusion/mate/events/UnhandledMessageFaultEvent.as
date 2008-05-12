package com.asfusion.mate.events
{
	import flash.events.Event;
	
	import mx.messaging.messages.ErrorMessage;
	
	/**
	 * The event that is dispatched when there are no <code>faultHandlers</code> inside the <code>MessageHandlers</code> tag
	 */
	public class UnhandledMessageFaultEvent extends Event
	{
		/**
		 * The FAULT event type.
		 */
		public static const FAULT:String = "faultUnhandledMessageFaultEvent";
		
		/**
		 * Provides access to the destination specific failure code.
		 */
		public var faultCode:String;
		
		/**
		 * Provides destination specific details of the failure.
		 */
		public var faultDetail:String;
		
		/**
		 * Provides access to the destination specific reason for the failure.
		 */
		public var faultString:String;
		
		/**
		 * Provides access to the root cause of the failure, if one exists.
		 */
		 public var rootCause:Object;
		 
		 /**
		 * The ErrorMessage for this event.
		 */
		 public var message:ErrorMessage;
		
		public function UnhandledMessageFaultEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}