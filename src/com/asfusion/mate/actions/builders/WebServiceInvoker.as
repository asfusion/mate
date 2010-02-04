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
	import mx.rpc.soap.mxml.WebService;
	
	use namespace com.asfusion.mate.core.mate;
	
	/**
	 * The <code>WebServiceInvoker</code> tag allows you to create a Web Service (<code>mx.rpc.soap.mxml.WebService</code>) 
	 * in your <code>IActionList</code> and call a method on that web service, in one step. 
	 * To use this tag, you need to specify its <code>wsdl</code> attribute that will determine the
	 * address of the webservice. You also need to specify the <code>method</code> to call.
	 * In addition to those two, this tag will accept all <code>mx.rpc.soap.WebService</code>
	 * tag attributes (with the exception of xmlSpecialCharsFilter and operations). 
	 */
	public class WebServiceInvoker extends ServiceInvoker implements IAction
	{
		/**
		*  @private
		*  No documentation about this yet
		*/
		protected var proxyChanged:Boolean;
		
		/*-.........................................arguments..........................................*/
		private var _arguments:* = undefined;
		/**
		* The property <code>arguments</code> allows you to pass an Object or an 
		* Array of objects when calling the function defined in the property <code>method</code>.
		* You can use an array to pass multiple arguments or use a simple Object 
		* if the signature of the <code>method</code> has only one parameter.
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
		
		/*-.........................................rootURL..........................................*/
		private var _rootURL:String;
		/**
		 * The URL that the WebService object should use when computing relative URLs. 
		 * This property is only used when going through the proxy. 
		 * When the <code>useProxy</code> property is set to <code>false</code>, the relative URL is computed automatically
		 * based on the location of the SWF running this application. If not set explicitly <code>rootURL</code>
		 * is automatically set to the URL of mx.messaging.config.LoaderConfig.url.
		 */
		public function get rootURL():String
		{
			return _rootURL;
		}
		
		public function set rootURL(value:String):void
		{
			_rootURL = value;
		}
		
		/*-.........................................useProxy..........................................*/
		private var _useProxy:Boolean;
		/**
		 * Specifies whether to use the Flex proxy service. The default value is <code>false</code>. If you do not specify true to proxy
		 * requests though the Flex server, you must ensure that the player can reach the target URL. 
		 * You also cannot use destinations defined in the services-config.xml file if the <code>useProxy</code> property is set to <code>false</code>.
		 * 
		 * @defult false
		 */
		public function get useProxy():Boolean
		{
			return _useProxy;
		}
		
		public function set useProxy(value:Boolean):void
		{
			_useProxy = value;
			proxyChanged = true;
		}
		
		/*-.........................................wsdl..........................................*/
		private var _wsdl:String;
		/**
		 * The location of the WSDL document for this WebService. If you use a relative URL, make sure that the rootURL has been specified or that you created the WebService in MXML.
		 * 
		 */
		public function get wsdl():String
		{
			return _wsdl;
		}
		
		public function set wsdl(value:String):void
		{
			_wsdl = value;
		}
		
		
		/*-.........................................port..........................................*/
		private var _port:String;
		/**
		 * Specifies the port within the WSDL document that this WebService should use
		 * 
		 */
		public function get port():String
		{
			return _port;
		}
		
		public function set port(value:String):void
		{
			_port = value;
		}
		
			
		/*-.........................................service..........................................*/
		private var _service:String;
		/**
		 * Specifies the service within the WSDL document that this WebService should use.
		 * 
		 */
		public function get service():String
		{
			return _service;
		}
		
		public function set service(value:String):void
		{
			_service = value;
		}
		
		
		/*-.........................................endpointURI..........................................*/
		private var _endpointURI:String;
		/**
		 * The location of the WebService. Normally, the WSDL document specifies the location of the services, 
		 * but you can set this property to override that location.
		 * 
		 */
		public function get endpointURI():String
		{
			return _endpointURI;
		}
		
		public function set endpointURI(value:String):void
		{
			_endpointURI = value;
		}
		
		
		/*-.........................................description..........................................*/
		private var _description:String;
		/**
		 * The description of the service for the currently active port.
		 * 
		 */
		public function get description():String
		{
			return _description;
		}
		
		public function set description(value:String):void
		{
			_description = value;
		}
		
		
		
		/*-.........................................httpHeaders..........................................*/
		private var _httpHeaders:Object;
		/**
		 * Custom HTTP headers to be sent to the SOAP endpoint. If multiple headers need to be sent with the same name the value should be specified as an Array.
		 * 
		 */
		public function get httpHeaders():Object
		{
			return _httpHeaders;
		}
		
		public function set httpHeaders(value:Object):void
		{
			_httpHeaders = value;
		}
		
		
		/*-.........................................instance..........................................*/
		/**
		 * If this property is null, a new WebService instance is created on 
		 * the <code>prepare</code> method. Otherwise, this instance will be used.
		 * The class that will be used to create the instance if none is provided is
		 * <code>mx.rpc.soap.mxml.WebService</code>.
		 * 
		 * @default null
		 */
		public function get instance():WebService
		{
			return currentInstance;
		}
		public function set instance(value:WebService):void
		{
			currentInstance = value;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override protected methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................prepare..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			super.prepare(scope);
			if(!currentInstance)currentInstance = new WebService();
			var webServiceInstance:WebService = currentInstance;
			
			if(channelSet)				webServiceInstance.channelSet = channelSet;
			if(description)				webServiceInstance.description = description;
			if(destination) 			webServiceInstance.destination = destination;
			if(endpointURI)				webServiceInstance.endpointURI = endpointURI;
			if(httpHeaders)				webServiceInstance.httpHeaders = httpHeaders;
			if(objectsBindableChanged) 	webServiceInstance.makeObjectsBindable = makeObjectsBindable;
			if(port) 					webServiceInstance.port = port;
			if(requestTimeoutChanged)	webServiceInstance.requestTimeout = requestTimeout
			if(rootURL)					webServiceInstance.rootURL = rootURL;
			if(proxyChanged)			webServiceInstance.useProxy = useProxy;	
			if(wsdl)					webServiceInstance.wsdl = wsdl;
			if(service)					webServiceInstance.service = service;
			
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
				webServiceInstance.setCredentials(username as String, password as String);
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
				webServiceInstance.setRemoteCredentials(remoteUsername as String, remotePassword as String);
			}
			
			if (!webServiceInstance.ready) {
				webServiceInstance.loadWSDL();
			}
		}
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			var argumentList:Array = (new SmartArguments()).getRealArguments(scope, this.arguments);
			var webServiceInstance:WebService = currentInstance;
			var operation:AbstractOperation;
			
			if(method)
			{
				var realMethod:Object = ( method is ISmartObject ) ?  ISmartObject( method ).getValue( scope ) : method;
				if( realMethod is String )
				{
					operation = webServiceInstance.getOperation( realMethod as String );
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
				var logInfo:LogInfo = new LogInfo( scope, webServiceInstance, null, null, argumentList);
				scope.getLogger().error(LogTypes.METHOD_UNDEFINED, logInfo);
			}
			scope.lastReturn = token;
		}
	}
}