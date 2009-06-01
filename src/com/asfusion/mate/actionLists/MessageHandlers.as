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
	import com.asfusion.mate.events.UnhandledMessageFaultEvent;
	import com.asfusion.mate.utils.debug.DebuggerUtil;
	import com.asfusion.mate.core.mate;
	
	import mx.messaging.*;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	
	use namespace mate;
	/**
	 * The <code>MessageHandlers</code> tag allows you to register a set of handlers as a consumer of a Flex Messaging Service. 
	 * All the tags inside the <code>MessageHandlers</code> tag will be executed in order when a <code>Message</code> matching the 
	 * criteria is received. This tag accepts the same attributes as the <code>Consumer</code> tag.
	 */
	public class MessageHandlers extends AbstractHandlers
	{
		
		/**
		 * An internal reference to the Consumer instance
		 */
		protected var consumer:Consumer;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Setters and Getters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................autoSubscribe ..........................................
		private var consumerSubscribedCalled:Boolean = false;
		private var _autoSubscribe:Boolean = true;
		/**
		 *  If this flag is true the consumer will be automatically subscribed when the <code>MessageHandlers</code> is created.
		 */
		public function get autoSubscribe ():Boolean
		{
			return _autoSubscribe;
		}
		public function set autoSubscribe (value:Boolean):void
		{
			_autoSubscribe = value;
		}
		
		//........................................destination ..........................................
		/**
		 * Provides access to the destination for the <code>MessageAgent</code>. Changing the destination will disconnect the 
		 * <code>MessageAgent</code> if it is currently connected.
		 */
		public function get destination ():String
		{
			return consumer.destination;
		}
		public function set destination (value:String):void
		{
			consumer.destination = value;
			invalidateProperties();
			
		}
		
		//.........................................selector..........................................
		/**
		 * The selector for the Consumer. This is an expression that is passed to the destination which
		 * uses it to filter the messages delivered to the Consumer.
		 * 
		 * <p>Before a call to the subscribe() method, this property can be set with no side effects. 
		 * After the Consumer has subscribed to its destination, changing this value has the side effect
		 *  of updating the Consumer's subscription to use the new selector expression immediately.</p>
		 * 
		 * <p>The remote destination must understand the value of the selector expression.</p>
		 */
		public function get selector():String
		{
			return consumer.selector;
		}
		public function set selector(value:String):void
		{
			consumer.selector = value;
			invalidateProperties();
		}
		
		
		//.........................................subtopic..........................................
		/**
		 * Provides access to the subtopic for the remote destination that the MessageAgent uses.
		 */
		public function get subtopic():String
		{
			return consumer.subtopic;
		}
		public function set subtopic(value:String):void
		{
			consumer.subtopic = value;
			invalidateProperties();
		}
		
		
		//.........................................resubscribeAttempts..........................................
		/**
		 * The number of resubscribe attempts that the Consumer makes in the event that the destination is unavailable 
		 * or the connection to the destination fails. A value of -1 enables infinite attempts. 
		 * A value of zero disables resubscribe attempts.
		 * 
		 * <p>Resubscribe attempts are made at a constant rate according to the resubscribe interval value. 
		 * When a resubscribe attempt is made if the underlying channel for the Consumer is not connected or attempting
		 * to connect the channel will start a connect attempt. Subsequent Consumer resubscribe attempts that occur while 
		 * the underlying channel connect attempt is outstanding are effectively ignored until the outstanding 
		 * channel connect attempt succeeds or fails.</p>
		 */
		public function get resubscribeAttempts():int
		{
			return consumer.resubscribeAttempts;
		}
		public function set resubscribeAttempts(value:int):void
		{
			consumer.resubscribeAttempts = value;
		}
		
		
		//.........................................resubscribeInterval..........................................
		/**
		 * The number of milliseconds between resubscribe attempts. If a Consumer doesn't receive an acknowledgement
		 * for a subscription request, it will wait the specified number of milliseconds before attempting to resubscribe.
		 * Setting the value to zero disables resubscriptions.
		 * 
		 * <p>Resubscribe attempts are made at a constant rate according to this value. 
		 * When a resubscribe attempt is made if the underlying channel for the Consumer is not connected or 
		 * attempting to connect the channel will start a connect attempt. Subsequent Consumer resubscribe attempts
		 * that occur while the underlying channel connect attempt is outstanding are effectively ignored until 
		 * the outstanding channel connect attempt succeeds or fails.</p>
		 */
		public function get resubscribeInterval():int
		{
			return consumer.resubscribeInterval;
		}
		public function set resubscribeInterval(value:int):void
		{
			consumer.resubscribeInterval = value;
		}
		
		
		//.........................................faultHandlers..........................................
		private var _faultHandlers:Array;
		/**
		 * 	An array of actions (IAction) contained in this fault action-list. 
		 * If the consumer dispatches a <code>faultEvent</code>, 
		 * the handlers are processed in the order in which they were added to the list.
		 * 
		 *  @default null
		 * */
		public function get faultHandlers():Array
		{
			return _faultHandlers;
		}
		
		[ArrayElementType("com.asfusion.mate.actions.IAction")]
		public function set faultHandlers(value:Array):void
		{
			_faultHandlers = value;
		}
		

		//-----------------------------------------------------------------------------------------------------------
		//                                         Constructor
		//------------------------------------------------------------------------------------------------------------	
		/**
		 * Constructor
		 */
		public function MessageHandlers()
		{
			super();
			getConsumer();
			
		}
		
		//.........................................getConsumer..........................................
		/**
		 * Returns an instance of the <code>Consumer</code> used in this <code>MessageHandlers</code>
		 */
		public function getConsumer():Consumer
		{
			if(!consumer)
			{
				consumer = new Consumer();
				consumer.addEventListener(MessageEvent.MESSAGE, fireEvent,false,0,true);
				consumer.addEventListener(MessageFaultEvent.FAULT,  fireFaultEvent,false,0,true);
			}
			return consumer;
		}
		
		//.........................................subscribe..........................................
		/**
		 * Subscribes to the remote destination.
		 */
		
		public function subscribe(clientId:String = null):void
		{
			consumer.subscribe(clientId);
		}
		
		//.........................................unsubscribe..........................................
		/**
		 * Unsubscribes from the remote destination. In the case of durable JMS subscriptions, 
		 * this will destroy the durable subscription on the JMS server.
		 */
		public function unsubscribe():void
		{
			consumer.unsubscribe();
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Override Public methods
		//-----------------------------------------------------------------------------------------------------------
		//.........................................toString..........................................
		/**
		 * @inheritDoc
		 */ 
		override public function errorString():String
		{
			var str:String = "Destination:"+ destination + ". Error was found in a MessageHandlers list in file " 
							+ DebuggerUtil.getClassName(document);
			return str;
		}
		
		//.........................................clearReferences..........................................
		/**
		 *  @inheritDoc
		*/
		override public function clearReferences():void
		{
			consumer.unsubscribe();
			consumer.removeEventListener(MessageEvent.MESSAGE, fireEvent);
			consumer.removeEventListener(MessageFaultEvent.FAULT,  fireFaultEvent);
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                         Protected methods
		//-----------------------------------------------------------------------------------------------------------
		//.........................................fireFaultEvent..........................................
		/**
		 * Called by the consumer when the fault event gets triggered.
		 * This method creates a scope and then runs the sequence.
		*/
		protected function fireFaultEvent(event:MessageFaultEvent):void
		{
			if(faultHandlers && faultHandlers.length > 0)
			{
				var currentScope:MessageScope = new MessageScope(event,debug, map, inheritedScope);
				currentScope.owner = this;
				currentScope.message = event.message;
				currentScope.currentEvent = event;
				runSequence(currentScope, faultHandlers);
			}
			else
			{
				var faultEvent:UnhandledMessageFaultEvent = new UnhandledMessageFaultEvent(UnhandledMessageFaultEvent.FAULT);
				faultEvent.faultCode = event.faultCode;
				faultEvent.faultDetail = event.faultDetail;
				faultEvent.faultString = event.faultString;
				faultEvent.message = event.message;
				faultEvent.rootCause = event.rootCause;
				dispatcher.dispatchEvent(faultEvent);
			}
		}
		
		//.........................................fireEvent..........................................
		/**
		 * Called by the consumer when the message event gets triggered.
		 * This method creates a scope and then runs the sequence.
		*/
		protected function fireEvent(event:MessageEvent):void
		{
			var currentScope:MessageScope = new MessageScope(event,debug, map, inheritedScope);
			currentScope.owner = this;
			currentScope.message = event.message;
			currentScope.currentEvent = event;
			runSequence(currentScope, actions);
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                         Override Protected methods
		//-------------------------------------------------------------------------------------------------------------
		
		//.........................................commitProperties..........................................
		/**
		 * Processes the properties set on the component.
		*/
		override protected function commitProperties():void
		{	
			if(autoSubscribe && !consumerSubscribedCalled)
			{
				consumer.subscribe();
				consumerSubscribedCalled = true;
			}
		}
	}
}