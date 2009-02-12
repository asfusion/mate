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

package com.asfusion.mate.testing
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.core.EventPriority;
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	use namespace flash_proxy;
	
	public class MockDelegate extends Proxy implements IEventDispatcher
	{
		/**
		 * Class to instantiate that will generate the mock result.
		 * This attribute needs to be supplied here or in the individual MockMethod tags. 
		 */
		public var mockGenerator:Class;
		
		/**
		 * Number of seconds to take to return the result or fault after making the call. This helps making
		 * the illusion that the service is taking time to respond. Default is 0 (no delay).
		 */
		public var delay:uint = 0;
		
		/**
		 * @todo
		 */
		public var cache:Boolean =  true;
		
		/**
		 * If true, a busy cursor is displayed while a service is executing.
		 */
		public var showBusyCursor:Boolean = false;
		
		/**
		 * @todo
		 */
		protected var operationsDictionary:Dictionary;
		
		/**
		 * @todo
		 */
		protected var eventDispatcher:EventDispatcher;
		
		
		//---------------------------------
		//   Proxy methods
		//---------------------------------
		/**
		 * @private
		 */
		override flash_proxy function getProperty( name:* ):*
		{
			// We want to return the actual function reference here, so we 
			// use ["send"] syntex to avoid compiler (when using .send syntax)
			return getOperation( name )[ "send" ];
		}
	
		/**
		 * @private
		 */
		override flash_proxy function setProperty( name:*, value:* ):void
		{
			throw new Error( "Cannot set " + name + " in MockDelegate" );
		}
	
		/**
		 * @private
		 */
		override flash_proxy function callProperty(name:*, ... args:Array):*
		{
			return getOperation( name ).send.apply( null, args );
		}
		
		override flash_proxy function hasProperty( name:* ):Boolean
		{
			// Return true only if the method name exists in the mockGenerator class
			return new mockGenerator().hasOwnProperty( name );
		}

		//---------------------------------
		//   EventDispatcher methods
		//---------------------------------
	
		/**
		 * @private
		 */
		public function addEventListener( type:String, listener:Function,
											useCapture:Boolean = false, priority:int = 0, 
											useWeakReference:Boolean = false ):void
		{
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
	
		/**
		 * @private
		 */
		public function dispatchEvent( event:Event ):Boolean
		{
			return eventDispatcher.dispatchEvent( event );
		}
	
		/**
		 * @private
		 */
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			eventDispatcher.removeEventListener( type, listener, useCapture );
		}
	
		/**
		 * @private
		 */
		public function hasEventListener( type:String ):Boolean
		{
			return eventDispatcher.hasEventListener( type );
		}
		
		/**
		 * @private
		 */
		public function willTrigger( type:String ):Boolean
		{
			return eventDispatcher.willTrigger( type );
		}
		

		/**
		 * Constructor
		 */
		public function MockDelegate()
		{
			eventDispatcher = new EventDispatcher( this );
			operationsDictionary = new Dictionary();
		}
		
		/**
		 * @todo
		 */
		public function getOperation( name:String ):AbstractOperation
		{   
			if ( operationsDictionary[ name ] == null )
			{
				var operation:MockOperation = new MockOperation( name, getMethod( name ), showBusyCursor );
				// add fault and result listeners
				operation.addEventListener( ResultEvent.RESULT, dispatchResult, false, EventPriority.DEFAULT, true );
				operation.addEventListener( FaultEvent.FAULT, dispatchFault, false, EventPriority.DEFAULT, true );
				
				operationsDictionary[ name ] = operation;
			}
			
			return AbstractOperation( operationsDictionary[ name ] );
		}
		
		/**
		 * @todo
		 */
		protected function getMethod( name:String ):MockMethod
		{
			var method:MockMethod = new MockMethod();
			method.name = name;
			method.delay = delay;
			method.mockGeneratorMethod = name;
			method.cache = cache;
			method.mockGenerator = mockGenerator;
			
			return method;
		}
		
		// These two functions dispatch the result and fault events
		// that trigger the inner handlers
		// -------------------------------
		protected function dispatchResult( event:ResultEvent ):void 
		{
			dispatchEvent( ResultEvent.createEvent( event.result, event.token ) );
		}
		
		// -------------------------------
		protected function dispatchFault( event:FaultEvent ):void 
		{
			dispatchEvent( FaultEvent.createEvent( event.fault, event.token ) );
		}

	}
}