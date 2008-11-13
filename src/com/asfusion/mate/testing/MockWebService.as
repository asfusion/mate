package com.asfusion.mate.testing
{
	import flash.utils.Dictionary;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.mxml.WebService;

	[DefaultProperty("methods")]
	[Exclude(name="destination", kind="property")]
	[Exclude(name="channelSet", kind="property")]
	[Exclude(name="concurrency", kind="property")]
	[Exclude(name="endpointURI", kind="property")]
	[Exclude(name="makeObjectsBindable", kind="property")]
	[Exclude(name="operations", kind="property")]
	[Exclude(name="requestTimeout", kind="property")]
	[Exclude(name="description", kind="property")]
	[Exclude(name="httpHeaders", kind="property")]
	[Exclude(name="port", kind="property")]
	[Exclude(name="rootURL", kind="property")]
	[Exclude(name="service", kind="property")]
	[Exclude(name="useProxy", kind="property")]
	[Exclude(name="wsdl", kind="property")]
	[Exclude(name="xmlSpecialCharsFilter", kind="property")]
	[Exclude(name="invoke", kind="event")]
	[Exclude(name="load", kind="event")]
	
	
	public class MockWebService extends WebService
	{
		public var mockGenerator:Class;
		
		public var delay:uint = 0;
		
		
		private var methodsDictionary:Dictionary;
		
		// -------------------------------
		private var _methods:Array;
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
		
		// -------------------------------
		public function MockWebService(destination:String=null)
		{
			super(destination);
			methodsDictionary = new Dictionary();
		}
		
		// -------------------------------
		override public function loadWSDL(uri:String=null):void {
			// ignore, we are not going to laod anything
		}
		
		// -------------------------------
		override public function getOperation(name:String):AbstractOperation
	    {   
	    	var operation:MockOperation = new MockOperation(name, getMethod(name), showBusyCursor);
	    	//add fault and result listeners
	    	operation.addEventListener(ResultEvent.RESULT, dispatchResult, false, 0, true);
	    	operation.addEventListener(FaultEvent.FAULT, dispatchFault, false, 0, true);
	        return operation;
	    }

	
		// These two functions dispatch the result and fault events
		// that trigger the inner handlers
		// -------------------------------
		private function dispatchResult(event:ResultEvent):void {
		
			dispatchEvent(ResultEvent.createEvent(event.result, event.token));
		}
		
		// -------------------------------
		private function dispatchFault(event:FaultEvent):void {
			
			dispatchEvent(FaultEvent.createEvent(event.fault, event.token));
			
		}
		
		
		// -------------------------------
		private function getMethod(name:String):MockMethod {
			
			if (methodsDictionary[name] == null ) {
				
				var newMethod:MockMethod = new MockMethod();
				newMethod.name = name;
				newMethod.delay = delay;
				newMethod.mockGeneratorMethod = name;
				newMethod.mockGenerator = mockGenerator;
				methodsDictionary[name] = newMethod;
			}
			
			var method:MockMethod = methodsDictionary[name];
			
			//we need to do this here and not in the methods() 
			// setter because it seems that the mockGenerator
			// variables has not been set by then
			if (method.mockGenerator == null) {
				method.mockGenerator = mockGenerator;
			}
			return method;
		}
	}
}