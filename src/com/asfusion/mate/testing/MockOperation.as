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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.managers.CursorManager;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class MockOperation extends AbstractOperation
	{
		private var method:MockMethod;
		private var token:AsyncToken;
		private var mock:Object;
		private var showCursor:Boolean;
		
		//--------------------------------------------------------------------------
	    // Contructor
	    //--------------------------------------------------------------------------
		public function MockOperation(name:String, method:MockMethod, showBusyCursor:Boolean)
		{
			this.method = method;
			var generator:Class = method.mockGenerator;
			mock = new generator();
			showCursor = showBusyCursor;
			
			super(service, name);
		}
		
		// --------------------------------------------------------------
		// The function that gets called when the service should be called
		override public function send(... args:Array):AsyncToken 
		{
			if (showCursor) 
			{
				CursorManager.setBusyCursor();
			}
			
			token = new AsyncToken(null);
			
			if (args.length > 0) 
			{
				this.arguments = args;
			}
			
			// check whether we need to load data
			if (method.dataUrl != null) 
			{
				//load data before calling helper method
				// and pass that loaded data as the last argument of the method call
				loadData();	
			}
			else 
			{
				//otherwise, call directly
				makeCall();
			}
		
			return token;
		}
		
		// -------------------------------
		private function loadData():void 
		{
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, dataLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, dataLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dataLoadError);
			
			try 
			{
		       loader.load(new URLRequest(method.dataUrl));
			} 
			catch (error:Error) 
			{
				startFault(new Fault(error.name, error.name, error.message));
			}
		}
		
		// -------------------------------
		private function dataLoaded(event:Event):void 
		{
			//save the result as the last argument
			if (this.arguments is Array) 
			{
				this.arguments.push(event.target.data);
			}
			else 
			{ 
				this.arguments = [event.target.data];
			}
			
			//now continue with the normal call
			makeCall();
		}
		
		
		// --------------------------------
		private function makeCall():void 
		{
			try 
			{
	    		if (method.async) 
	    		{
	    			//add listeners for asynchronous method calls
	    			mock.addEventListener(ResultEvent.RESULT, handleAsyncResult);
	    			mock.addEventListener(FaultEvent.FAULT, handleAsyncFault);
	    		}
	    		
				var result:Object = callMockHelperMethod();
				if (!method.async) 
				{
					startResult(result);
				}
			}
			
			catch (error:Error) 
			{
				startFault(new Fault(error.name, error.name, error.message));
			}
		}
		
		// --------------------------------
		// call the mock generator, which may return a result, or it might be an async request
		// -------------------------------
		private function callMockHelperMethod():Object 
		{
			var result:Object;
				
			if (this.arguments is Array) 
			{
				result = mock[method.mockGeneratorMethod].apply(null, this.arguments);
			}
			else 
			{
				result = mock[method.mockGeneratorMethod].apply(null);
			}
				
			return result;
		}
		
		// -------------------------------
		// Used to add a delay when we already have a result that we 
		// need to dispatch
		private function startResult(result:*):void 
		{
			new AsyncDispatcher(dispatchResult, [result], method.delay * 1000);
		}
		
		// -------------------------------
		// Used to add a delay when we already have a fault that we 
		// need to dispatch
		private function startFault(fault:Fault):void 
		{
			new AsyncDispatcher(dispatchFault, [fault], method.delay * 1000);
		}
		
		// -------------------------------
		private function handleAsyncResult(event:ResultEvent):void 
		{
			startResult(event.result);
			
			mock.removeEventListener(ResultEvent.RESULT, handleAsyncResult);
	    	mock.removeEventListener(FaultEvent.FAULT, handleAsyncFault);
		}
		
		// -------------------------------
		private function handleAsyncFault(event:FaultEvent):void 
		{
			startFault(event.fault);
			
			mock.removeEventListener(ResultEvent.RESULT, handleAsyncResult);
	    	mock.removeEventListener(FaultEvent.FAULT, handleAsyncFault);
		}
		
		// These two functions dispatch the result and fault events
		// -------------------------------
		private function dispatchResult(result:*):void 
		{
			if (showCursor) 
			{
				CursorManager.removeBusyCursor();
			}
			
			var resultEvent:ResultEvent = ResultEvent.createEvent(result, token);
			for each ( var responder:IResponder in token.responders )
			{
				responder.result( resultEvent );
			}
			dispatchEvent( resultEvent );
		}
		
		// -------------------------------
		private function dispatchFault(fault:Fault):void 
		{
			if (showCursor) 
			{
				CursorManager.removeBusyCursor();
			}
			var faultEvent:FaultEvent = FaultEvent.createEvent(fault, token);
			for each ( var responder:IResponder in token.responders )
			{
				responder.fault( faultEvent );
			}
			dispatchEvent( faultEvent );
	
		}
		
		// -------------------------------
		// errors
		private function dataLoadError(event:ErrorEvent):void 
		{
			startFault(new Fault(event.type, event.text, event.text));
		}
	}
}