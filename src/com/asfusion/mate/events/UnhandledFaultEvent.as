package com.asfusion.mate.events
{
	import flash.events.Event;
	
	import mx.messaging.messages.IMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;

	/**
	 * The event that is dispatched where there are no <code>faultHandlers</code> inside a service tag such as
	 * <code>RemoteObjectInvoker</code>,  <code>WebServiceObjectInvoker</code>,  <code>HTTPServiceObjectInvoker</code>
	 */
	public class UnhandledFaultEvent extends Event
	{
		/**
		 * The FAULT event type.
		 */
		public static const FAULT:String = "faultUnhandledFaultEvent";
		
		/**
		 * The Message associated with this event.
		 */
		public var message:IMessage;
		
		/**
		 * The Fault object that contains the details of what caused this event.
		 */
		public var fault:Fault;
		
		/**
		 * In certain circumstances, headers may also be returned with a fault to provide further context to the failure.
		 */
		public var headers:Object;
		
		/**
		 * The token that represents the call to the method.
		 */
		public var token:AsyncToken;
		
		/**
		 * The message ID associated with this event.
		 */
		public var messageId:String;
		
		public function UnhandledFaultEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}