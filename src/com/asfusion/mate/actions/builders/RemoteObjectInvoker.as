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
	import com.asfusion.mate.actions.IAction;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.utils.debug.*;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	use namespace com.asfusion.mate.core.mate;
	
	/**
	 * The <code>RemoteObjectInvoker</code> tag is used to create a <code>RemoteObject</code> instance and call 
	 * a method on the object created. To use this tag, you need to specify the same attributes you would
	 * when creating a remote object with the <code>RemoteObject</code> tag. In addition, you need to specify what
	 * method to call. This tag will also accept 
	 * all mx.rpc.remoting.RemoteObject tag attributes (with the exception of the "operations" property). 
	 */ 
	public class RemoteObjectInvoker extends ServiceInvoker implements IAction
	{
		/**
		*  @private
		*  No documentation about this yet
		*/
		protected var showCursorChanged:Boolean;
		
		/*-.........................................arguments..........................................*/
		private var _arguments:* = undefined;
		/**
		*  The property <code>arguments</code> allows you to pass an Object or an Array of objects when 
		 * calling the function defined in the property <code>method</code>. 
		*  You can use an array to pass multiple arguments or use a simple Object if the 
		 * signature of the <code>method</code> has only one parameter.
		* 
		*  @default undefined
		*/ 
		public function get arguments():*
		{
			return _arguments;
		}
		public function set arguments(value:*):void
		{
			_arguments = value;
		}
		
		/*-.........................................source..........................................*/
		private var _source:String;
		/**
		* Lets you specify a source value on the client; not supported for destinations that use the JavaAdapter. 
		* This allows you to provide more than one source that can be accessed from a single destination on the server.
		* 
		*/
		public function get source():String
		{
			return _source;
		}
		public function set source(value:String):void
		{
			_source = value;
		}
		
		
		/*-.........................................endpoint..........................................*/
		private var _endpoint:String;
		/**
		* This property allows the developer to quickly specify an endpoint for a RemoteObject destination without
		* referring to a services configuration file at compile time or programmatically creating a ChannelSet. 
		* It also overrides an existing ChannelSet if one has been set for the RemoteObject service.
		* 
		* <p>f the endpoint url starts with "https" a SecureAMFChannel will be used, otherwise an AMFChannel will be used. 
		* Two special tokens, {server.name} and {server.port}, can be used in the endpoint url to specify that the channel
		* should use the server name and port that was used to load the SWF.</p>
		* 
		* <p><strong>Note:</strong> This property is required when creating AIR applications.</p> 
		* 
		*/
		public function get endpoint():String
		{
			return _endpoint;
		}
		public function set endpoint(value:String):void
		{
			_endpoint = value;
		}
		
		/*-.........................................concurrency..........................................*/
		private var _concurrency:String;
		/**
		*  Value that indicates how to handle multiple calls to the same service. The default value is multiple. The following values are permitted:
		*  <ul><li>multiple Existing requests are not cancelled, and the developer is responsible for ensuring the consistency of returned data by carefully managing the event stream. This is the default.</li>
		*  <li>ingle Only a single request at a time is allowed on the operation; multiple requests generate a fault.</li>
		*  <li>last Making a request cancels any existing request.</li></ul>
		* 
		*  @default multiple
		*/ 
		public function get concurrency():String
		{
			return _concurrency;
		}
		
		public function set concurrency(value:String):void
		{
			_concurrency = value;
		}
		
		
		/*-.........................................showBusyCursor..........................................*/
		private var _showBusyCursor:Boolean;
		/**
		 * If true, a busy cursor is displayed while a service is executing. The default value is false.
		 * 
		 * @default false
		 */
		public function get showBusyCursor():Boolean
		{
			return _showBusyCursor;
		}
		public function set showBusyCursor(value:Boolean):void
		{
			_showBusyCursor = value;
			showCursorChanged = true;
		}
		
		/*-.........................................instance..........................................*/
		/**
		 * If this property is null, a new RemoteObject instance is created on 
		 * the <code>prepare</code> method. Otherwise, this instance will be used.
		 * The class that will be used to create the instance if none is provided is
		 *   <code>mx.rpc.remoting.mxml.RemoteObject</code>
		 * 
		 * @default null
		 */
		public function get instance():RemoteObject
		{
			return currentInstance;
		}
		public function set instance(value:RemoteObject):void
		{
			currentInstance = value;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override protected methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................createInstance..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			super.prepare(scope);
			if(!currentInstance) currentInstance = new RemoteObject();
			var remoteObjectInstance:RemoteObject = currentInstance;
			
			if(channelSet)				remoteObjectInstance.channelSet = channelSet;
			if(concurrency)				remoteObjectInstance.concurrency = concurrency;
			if(destination) 			remoteObjectInstance.destination = destination;
			if(endpoint)				remoteObjectInstance.endpoint = endpoint;
			if(objectsBindableChanged) 	remoteObjectInstance.makeObjectsBindable = makeObjectsBindable;
			if(requestTimeoutChanged)	remoteObjectInstance.requestTimeout = requestTimeout
			if(showCursorChanged)		remoteObjectInstance.showBusyCursor = showBusyCursor;
			if(source) 					remoteObjectInstance.source = source;
			
			if(username && password)
			{
				if(username is ISmartObject)
				{
					username = ISmartObject(username).getValue(scope);
				}
				if(password is ISmartObject)
				{
					password = ISmartObject(password).getValue(scope);
				}
				remoteObjectInstance.setCredentials(username as String, password as String);
			}
			if(remoteUsername && remotePassword)
			{
				if(remoteUsername is ISmartObject)
				{
					remoteUsername = ISmartObject(remoteUsername).getValue(scope);
				}
				if(remotePassword is ISmartObject)
				{
					remotePassword = ISmartObject(remotePassword).getValue(scope);
				}
				remoteObjectInstance.setRemoteCredentials(remoteUsername as String, remotePassword as String);
			}
		}
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			var argumentList:Array = (new SmartArguments()).getRealArguments(scope, this.arguments);
			var remoteObjectInstance:RemoteObject = currentInstance;
			var operation:AbstractOperation;
			
			if(method)
			{
				var realMethod:Object = ( method is ISmartObject ) ?  ISmartObject( method ).getValue( scope ) : method;
				if( realMethod is String )
				{
					operation = remoteObjectInstance.getOperation( realMethod as String );
				}
				else
				{
					throw( new Error( "Method can only be a String or a SmartObject that represents a String" ) );
				}
				if(argumentList)
				{
					operation.arguments = argumentList;
				}
				
				token = operation.send();
			}
			else
			{
				var logInfo:LogInfo = new LogInfo( scope, remoteObjectInstance, null, null, argumentList);
				scope.getLogger().error(LogTypes.METHOD_UNDEFINED, logInfo);
			}
			scope.lastReturn = token;
		}
	}
}