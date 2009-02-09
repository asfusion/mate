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

Author: Darron Schall, Principal Architect
        http://www.darronschall.com/
                
@ignore
*/

package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actionLists.ServiceHandlers;
	import com.asfusion.mate.actions.IAction;
	import com.asfusion.mate.core.SmartArguments;
	import com.asfusion.mate.events.UnhandledFaultEvent;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	import flash.events.EventDispatcher;
	
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	/**
	 * The DelegateInvoker can be used with any method that returns an AsyncToken. 
	 * Behind the scenes, the DelegateInvoker attaches a responder to the AsyncToken
	 * returned by the method. The responder listens for success/failure and triggers 
	 * the inner handlers when the method call returns. If the method does not return 
	 * an AsyncToken to attach a responder to a runtime error is logged.
	 */
	public class DelegateInvoker extends ServiceInvokerBuilder implements IAction
	{
		
		/**
		 * Generated when making asynchronous RPC operations.
		 * The same object is available in the <code>result</code> and <code>fault</code> events in
		 * the <code>token</code> property.
		 */
		protected var token:AsyncToken;
		
		// ---------------------------------------------------
		//  instance property
		// ---------------------------------------------------
		
		/**
		 * The instance of the Delegate to use.
		 * 
		 * @default null
		 */
		public function get instance():*
		{
			return currentInstance;
		}
		public function set instance( value:* ):void
		{
			currentInstance = value;
		}
		
		// ---------------------------------------------------
		//  method property
		// ---------------------------------------------------
		
		private var _method:String;
		/**
		 * The <code>method</code> attribute specifies what function to call on the delegate instance.
		 * 
		 * @default null
		 */
		public function get method():String
		{
			return _method;
		}
		
		public function set method( value:String ):void
		{
			_method = value;
		}
		
		// ---------------------------------------------------
		//  arguments property
		// ---------------------------------------------------
		
		private var _arguments:* = undefined;
		/**
		* The property <code>arguments</code> allows you to pass an Object or an Array of objects
		* when calling the function defined in the property <code>method</code>. 
		* You can use an array to pass multiple arguments or use a simple Object if the 
		* signature of the <code>method</code> has only one parameter.
		* 
		*  @default undefined
		*/ 
		public function get arguments():*
		{
			return _arguments;
		}
		public function set arguments( value:* ):void
		{
			_arguments = value;
		}
		
		// ---------------------------------------------------
		//  showBusyCursor property
		// ---------------------------------------------------
		
		/**
		 * If true, a busy cursor is displayed while a service is executing. The default value is false.
		 * 
		 * @default false
		 */
		public var showBusyCursor:Boolean = false;
		
		/**
		 * Contructor
		 */
		public function DelegateInvoker()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function prepare( scope:IScope ):void
		{
			currentIndex++;
			
			if( !instance )
			{
				createInstance( scope );
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function run( scope:IScope ):void
		{
			var logInfo:LogInfo;
			var argumentList:Array = ( new SmartArguments() ).getRealArguments( scope, this.arguments );
			
			if ( !currentInstance )
			{
				logInfo = new LogInfo( scope, currentInstance, null, method, argumentList );
				scope.getLogger().error( LogTypes.INSTANCE_UNDEFINED, logInfo );
			}
			else if ( method && currentInstance.hasOwnProperty( method ) )
			{
				token = currentInstance[ method ].apply( currentInstance, argumentList );
				
				// Make sure we got a token back so we can add responders to it
				if ( token == null )
				{
					logInfo = new LogInfo( scope, currentInstance, null, method );
					scope.getLogger().error( "Delegate method must return an AsyncToken", logInfo );
				}
				else
				{
					if ( showBusyCursor )
					{
						CursorManager.setBusyCursor();
					}
				}
			}
			else
			{
				logInfo = new LogInfo( scope, currentInstance, null, method, argumentList );
				scope.getLogger().error( LogTypes.METHOD_UNDEFINED, logInfo );
			}
			
			scope.lastReturn = token;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function complete( scope:IScope ):void
		{
			// Error state when we don't have a token.  Maybe we called a method that returned
			// void instead?
			if ( token == null )
			{
				return;
			}
			
			// Create a dispatcher to be invoked from the token responder that dispatches
			// the result/fault event the handlers listen to
			var dispatcher:EventDispatcher = new EventDispatcher();
			
			// Generate a responder associated with the token and dispatcher, and add it
			// to the list of responds for the token
			token.addResponder( createResponder( token, dispatcher ) );
			
			// The inner handlers dispatcher is the internal dispatcher the responder uses
			innerHandlersDispatcher = dispatcher;
			
			if ( resultHandlers && resultHandlers.length > 0 )
			{
				var resultHandlersInstance:ServiceHandlers = createInnerHandlers( scope,  
																				ResultEvent.RESULT, 
																				resultHandlers, 
																				ServiceHandlers ) as ServiceHandlers;
				resultHandlersInstance.token = token;
				resultHandlersInstance.validateNow();
			}
			
			if ( (faultHandlers && faultHandlers.length > 0 )
				|| scope.dispatcher.hasEventListener( UnhandledFaultEvent.FAULT ) )
			{
				var faultHandlersInstance:ServiceHandlers = createInnerHandlers( scope,  
																				FaultEvent.FAULT, 
																				faultHandlers, 
																				ServiceHandlers ) as ServiceHandlers; 
				faultHandlersInstance.token = token;
				faultHandlersInstance.validateNow();
			}
		}
		
		/**
		 * Creates a responder for a given token.  When the responder is invoked, the data is converted
		 * into an event and dispatched by the dispatcher.  This will then trigger the inner handlers
		 * since the dispatcher passed in will be the same dispatcher that the inner handlers are
		 * listening to.
		 */
		protected function createResponder( token:AsyncToken, dispatcher:EventDispatcher ):Responder
		{
			return new Responder( 
				function( data:Object ):void
				{
					if ( showBusyCursor )
					{
						CursorManager.removeBusyCursor();
					}
					
					// Convert the result into a result event and notify inner handlers
					var resultEvent:ResultEvent;
					if ( data is ResultEvent )
					{
						resultEvent = ResultEvent.createEvent( ResultEvent( data ).result, token );
					}
					else
					{
						resultEvent = ResultEvent.createEvent( data, token );
					}
					dispatcher.dispatchEvent( resultEvent );
				},
				function( info:Object ):void
				{
					if ( showBusyCursor )
					{
						CursorManager.removeBusyCursor();
					}
					
					// Convert the error into a fault event and notify inner handlers
					var faultEvent:FaultEvent;
					if ( info is FaultEvent )
					{
						faultEvent = FaultEvent.createEvent( FaultEvent( info ).fault, token );
					}
					else if ( info is Fault )
					{
						faultEvent = FaultEvent.createEvent( Fault( info ), token );
					}
					else
					{
						faultEvent = FaultEvent.createEvent( new Fault( info.toString(), info.toString() ), token );
					}
					dispatcher.dispatchEvent( faultEvent );
				} );
		}
	}
}