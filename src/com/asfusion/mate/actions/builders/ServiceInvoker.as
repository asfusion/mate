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
package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.actionLists.*;
	import com.asfusion.mate.actions.AbstractServiceInvoker;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.UnhandledFaultEvent;
	
	import mx.messaging.ChannelSet;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	/**
	 * ServiceInvoker is the base class for the following service actions:
	 * <ul><li>RemoteObjectInvoker</li>
	 * <li>HTTPServiceInvoker</li>
	 * <li>WebServiceInvoker</li></ul>
	 * 
	 * @see com.asfusion.mate.actions.builders.RemoteObjectInvoker
	 * @see com.asfusion.mate.actions.builders.HTTPServiceInvoker
	 * @see com.asfusion.mate.actions.builders.WebServiceInvoker
	 */
	public class ServiceInvoker extends AbstractServiceInvoker
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Generated when making asynchronous RPC operations.
		 * The same object is available in the <code>result</code> and <code>fault</code> events in the <code>token</code> property.
		 */
		protected var token:AsyncToken;
		
		/**
		*  @private
		*  No documentation about this yet
		*/
		protected var requestTimeoutChanged:Boolean;
		/**
		*  @private
		*  No documentation about this yet
		*/
		protected var objectsBindableChanged:Boolean;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
			
		/*-.........................................method..........................................*/
		private var _method:Object;
		/**
		 * The <code>method</code> attribute specifies what function to call on the service instance.
		 * It can be a SmartObject or String
		 * 
		 * @default null
		 */
		public function get method():Object
		{
			return _method;
		}
		
		public function set method(value:Object):void
		{
			_method = value;
		}
		
		/*-.........................................makeObjectsBindable..........................................*/
		private var _makeObjectsBindable:Boolean = true;
		/**
		 * When this value is true, anonymous objects returned are forced to bindable objects.
		 * 
		 * @default true
		 */
		public function get makeObjectsBindable():Boolean
		{
			return _makeObjectsBindable;
		}
		public function set makeObjectsBindable(value:Boolean):void
		{
			_makeObjectsBindable = value;
			objectsBindableChanged = true;
		}
		
		
		/*-.........................................channelSet..........................................*/
		private var _channelSet:ChannelSet;
		/**
		 * Provides access to the ChannelSet used by the service. The ChannelSet can be manually constructed and assigned,
		 * or it will be dynamically created to use the configured Channels for the <code>destination</code> for this service.
		 */
		public function get channelSet():ChannelSet
		{
			return _channelSet;
		}
		public function set channelSet(value:ChannelSet):void
		{
			_channelSet = value;
		}
		
		
		/*-.........................................requestTimeout..........................................*/
		private var _requestTimeout:int;
		/**
		 * Provides access to the request timeout in seconds for sent messages. A value less than or equal to zero prevents request timeout.
		 */
		public function get requestTimeout():int
		{
			return _requestTimeout;
		}
		public function set requestTimeout(value:int):void 
		{
			_requestTimeout = value;
			requestTimeoutChanged = true;
		}
		
		/*-.........................................destination..........................................*/
		private var _destination:String;
		/**
		 * The destination of the service. This value should match a destination entry in the services-config.xml file.
		 */
		public function get destination():String
		{
			return _destination;
		}
		
		public function set destination(value:String):void 
		{
			_destination = value;
		}
		
    
		/*-.........................................username..........................................*/
		private var _username:Object;
		/**
		 * Username to supply to <code>setCredentials</code> method
		 */
		public function get username():Object
		{
			return _username;
		}
		public function set username(value:Object):void
		{
			_username = value;
		}
		
		
		/*-.........................................password..........................................*/
		private var _password:Object;
		/**
		 * Password to supply to <code>setCredentials</code> method
		 */
		public function get password():Object
		{
			return _password;
		}
		public function set password(value:Object):void
		{
			_password = value;
		}
		
		
		/*-.........................................remoteUsername..........................................*/
		private var _remoteUsername:Object;
		/**
		 * Username to supply to <code>setCredentials</code> method
		 */
		public function get remoteUsername():Object
		{
			return _remoteUsername;
		}
		public function set remoteUsername(value:Object):void
		{
			_remoteUsername = value;
		}
		
		
		/*-.........................................remotePassword..........................................*/
		private var _remotePassword:Object;
		/**
		 * Password to supply to <code>setCredentials</code> method
		 */
		public function get remotePassword():Object
		{
			return _remotePassword;
		}
		public function set remotePassword(value:Object):void
		{
			_remotePassword = value;
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................complete..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function complete(scope:IScope):void
		{
			innerHandlersDispatcher = currentInstance;
			
			if(resultHandlers && resultHandlers.length > 0)
			{
				var resultHandlersInstance:ServiceHandlers = createInnerHandlers(scope,  
																				ResultEvent.RESULT, 
																				resultHandlers, 
																				ServiceHandlers)  as ServiceHandlers;
				resultHandlersInstance.token = token;
				resultHandlersInstance.validateNow();
			}
			if( (faultHandlers && faultHandlers.length > 0) || scope.dispatcher.hasEventListener(UnhandledFaultEvent.FAULT))
			{
				var faultHandlersInstance:ServiceHandlers = createInnerHandlers(scope,  
																				FaultEvent.FAULT, 
																				faultHandlers, 
																				ServiceHandlers)  as ServiceHandlers; 
				faultHandlersInstance.token = token;
				faultHandlersInstance.validateNow();
			}
		}
	}
}