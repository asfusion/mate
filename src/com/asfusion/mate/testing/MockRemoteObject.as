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

Author: Laura Arguello, Principal Architect
        http://www.asfusion.com/
                
@ignore
*/
package com.asfusion.mate.testing
{
	import flash.utils.Dictionary;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;

	[DefaultProperty("methods")]
	[Exclude(name="destination", kind="property")]
	[Exclude(name="channelSet", kind="property")]
	[Exclude(name="concurrency", kind="property")]
	[Exclude(name="endpoint", kind="property")]
	[Exclude(name="makeObjectsBindable", kind="property")]
	[Exclude(name="operations", kind="property")]
	[Exclude(name="requestTimeout", kind="property")]
	[Exclude(name="source", kind="property")]
	[Exclude(name="invoke", kind="event")]
	
	
	public class MockRemoteObject extends RemoteObject
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
		/**		 * Indicates whether any unhandled errors thrown by the service method should be caught		 * and dispatched as a fault. Default is true.		 */		public var useFault:Boolean = true;		/**
		 * @todo
		 */
		protected var methodsDictionary:Dictionary;
		
		// -------------------------------
		private var _methods:Array;
		/**
		 * @todo
		 */
		public function get methods():Array
		{
			return _methods;
		}
		
		[ArrayElementType("com.asfusion.mate.testing.MockMethod")]
		public function set methods(value:Array):void
		{
			_methods = value;
			
			for each (var method:MockMethod in value) {
				if (method.delay == -1) {
					//set parent's default delay
					method.delay = delay;
				}
				if (method.mockGeneratorMethod == null) {
					method.mockGeneratorMethod = method.name;
				}
				methodsDictionary[method.name] = method;
			}
		}
		
		//--------------------------------------------------------------------------
	    // Contructor
	    //--------------------------------------------------------------------------
	    /**
	    * Contructor
	    */
		public function MockRemoteObject(destination:String=null)
		{
			super(destination);
			methodsDictionary = new Dictionary();
		}
			
		// -------------------------------
		/**
		 * @todo
		 */
		override public function getOperation(name:String):AbstractOperation
	    {   
	    	var operation:MockOperation = new MockOperation(name, getMethod(name), showBusyCursor, useFault);
	    	//add fault and result listeners
	    	operation.addEventListener(ResultEvent.RESULT, dispatchResult, false, 0, true);
	    	operation.addEventListener(FaultEvent.FAULT, dispatchFault, false, 0, true);
	        return operation;
	    }

	
		// These two functions dispatch the result and fault events
		// that trigger the inner handlers
		// -------------------------------
		protected function dispatchResult(event:ResultEvent):void 
		{
			dispatchEvent(ResultEvent.createEvent(event.result, event.token));
		}
		
		// -------------------------------
		protected function dispatchFault(event:FaultEvent):void 
		{
			dispatchEvent(FaultEvent.createEvent(event.fault, event.token));
		}
		
		
		// -------------------------------
		protected function getMethod(name:String):MockMethod 
		{
			
			if (methodsDictionary[name] == null ) 
			{
				
				var newMethod:MockMethod = new MockMethod();
				newMethod.name = name;
				newMethod.delay = delay;
				newMethod.mockGeneratorMethod = name;
				newMethod.mockGenerator = mockGenerator;
				newMethod.cache = cache;
				methodsDictionary[name] = newMethod;
			}
			
			var method:MockMethod = methodsDictionary[name];
			
			//we need to do this here and not in the methods() 
			// setter because it seems that the mockGenerator
			// variables has not been set by then
			if (method.mockGenerator == null) 
			{
				method.mockGenerator = mockGenerator;
			}
			return method;
		}
	}
}