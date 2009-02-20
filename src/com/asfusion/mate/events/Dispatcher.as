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
package com.asfusion.mate.events
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.responses.IResponseHandler;
	import com.asfusion.mate.utils.debug.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	import mx.events.DynamicEvent;
	import mx.utils.*;
	
	[DefaultProperty("responseHandlers")]
	
	/**
	 * The Dispatcher can be used to dispatch an event from anywhere in your application. 
	 * It can be used as a tag within your views and can be instantiated in ActionScript classes. 
	 * Although views can dispatch events using their "dispatchEvent()" method, if these views as used within Popup windows, 
	 * the event will not be received by other views or the <code>EventMap</code>. 
	 * By using the <code>Dispatcher</code>, we can guarantee that the event will be received by all registered listeners.
	 * 
	 * <p>Using the dispatcher as a tag allows you to dispatch an event from any MXML component. 
	 * You can use the dispatcher attributes to make the dispatcher create the event for you or you 
	 * can create an event and use the dispatcher only to dispatch the already created event.</p>
	 * <p>It also allows you to receive direct responses such that only the object that dispatched the event receives this response.</p>
	 * 
  	 * @mxml
 	 * <p>The <code>&lt;Dispatcher&gt;</code> tag has the following tag attributes:</p>
 	 * <pre>
	 * &lt;Dispatcher
 	 * <b>Properties</b>
	 * generator="Class"
	 * constructorArgs="Object|Array"
	 * eventProperties="EventProperties"
	 * type="String"
	 * bubbles="true|false"
	 * cancelable="true|false"
	 * responders="Array"
 	 * /&gt;
	 * </pre>
	 * 
	 * @see com.asfusion.mate.responses.ServiceResponseHandler
	 * @see com.asfusion.mate.responses.ResponseHandler
	 */
	public class Dispatcher implements ILoggerProvider, IMXMLObject
	{
		/**
		 * Instance of the <code>IEventDispatcher</code> that will be used to dispatch all the events.
		 */
		protected var dispatcher:IEventDispatcher;
		
		/**
		 * Instance of the <code>IEventDispatcher</code> that will be used to dispatch all the reponses.
		 */
		protected var responseDispatcher:IEventDispatcher;
		
		/**
		 * Instance of <code>IMateLogger</code> used to debug.
		 */
		protected var logger:IMateLogger;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                        Public Setters and Getters
		//-----------------------------------------------------------------------------------------------------------
		//.........................................eventProperties..........................................
		private var _eventProperties:EventProperties;
		/**
		 *  <code>eventProperties</code> allows you to add properties to the event that will be created by the
		 * Dispatcher.
		 *  <p>These properties will be set before dispatched.
		 *  These properties must be public.</p>
		 * 	<p>The <code>eventProperties</code> property is usually specified by using the <em>EventProperties</em> tag.</p>
		*/
		public function get eventProperties():EventProperties
		{
			return _eventProperties;
		}
		public function set eventProperties(value:EventProperties):void
		{	
			_eventProperties = value;
		}
		
		
		//.........................................generator..........................................
		private var _generator:Class = DynamicEvent;
		/**
		*  The generator attribute specifies what class should be used to instantiate the 
		 * event when using the <code>createAndDispatchEvent</code> method.
		* 
		*  @default null
		*/
		public function get generator():Class
		{
			return _generator;
		}
		public function set generator(value:Class):void
		{
	        _generator = value;
		}
		
		//.........................................type..........................................
		private var _type:String;
		/**
		*  The type attribute specifies the event type you want to dispatch.
		* Property of the event to create when using <code>createAndDispatchEvent</code> method.
		 * 
		*  @default null
		*/
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			_type = value;
		}
		
		//.........................................bubbles..........................................
		private var _bubbles:Boolean;
		/**
		* Property of the event to create when using <code>createAndDispatchEvent</code> method.
		* Although you can specify the event's bubbles property, whether you set it to true or false will have little effect, 
		* as the event will be dispatched from the Mate Dispatcher itself (the Application by default).
		* 
		*  @default false
		*/
		public function get bubbles():Boolean
		{
			return _bubbles;
		}
		public function set bubbles(value:Boolean):void
		{
			_bubbles = value;
		}
		
		
		//.........................................cancelable..........................................
		private var _cancelable:Boolean = true;
		/**
		* Indicates whether the behavior associated with the event can be prevented.
		* Property of the event to create when using <code>createAndDispatchEvent</code> method.
		*  @default true
		*/
		public function get cancelable():Boolean
		{
			return _cancelable;
		}
		public function set cancelable(value:Boolean):void
		{
			_cancelable = value;
		}
		
		//.........................................constructorArguments..........................................
		private var _constructorArguments:* = undefined;
		/**
		*  The constructorArgs allows you to pass an Object or an Array of objects to the contructor 
		*  of the event when it is created by using the <code>createAndDispatchEvent</code> method.
		*  <p>You can use an array to pass multiple arguments or use a simple Object if your 
		 * signature has only one parameter.</p>
		*
		*    @default undefined
		*/
		public function get constructorArguments():*
		{
			return _constructorArguments;
		}
		public function set constructorArguments(value:*):void
		{
	 		_constructorArguments = value;
		}
		
		//.........................................responseHandlers..........................................
		private var _responseHandlers:Array = [];
		/**
		 * Array <code>IResponseListeners</code> that are interested in listening to responses
		 * after the event is dispatched.
		 */
		public function get responseHandlers():Array
		{
			return _responseHandlers;
		}
		
		[ArrayElementType("com.asfusion.mate.responses.IResponseHandler")]
		public function set responseHandlers(value:Array):void
		{
			_responseHandlers = value;
		}
		
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Constructor
		//------------------------------------------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function Dispatcher()
		{
			var manager:IMateManager = MateManager.instance;
			dispatcher = manager.dispatcher;
			logger = manager.getLogger(true);
			responseDispatcher = MateManager.instance.responseDispatcher;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public methods
		//-----------------------------------------------------------------------------------------------------------
		//.........................................dispatchEvent..........................................
		/**
		 * Dispatches the given event into the event flow. The event target is the EventDispatcher object.
		 * If bubble is false the default is the global mate dispatcher.
		 * If bubble is true wil try to use the document(parent) as a dispatcher.
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			addReponders(event);
			var success:Boolean;
			if(!bubbles)
			{
				success = dispatcher.dispatchEvent(event);
			}
			else
			{
				if(document && document is DisplayObject)
				{
					success = DisplayObject(document).dispatchEvent(event);
				}
			}
			return success;
		}
		
		//.........................................generateEvent..........................................
		/**
		 * Creates an event with the <code>generator</code> template and dispatches it into the event flow.
		 * All the eventProperties and the Object of name-value pairs passed in this method are copied 
		 * to the new event before dispatching it.
		 */
		public function generateEvent(inlineProperties:Object = null):Boolean
		{
			
			var instance:Object;
			var creator:Creator = new Creator( generator );
			if(constructorArguments !== undefined)
			{
				var realParams:Array = (constructorArguments is Array) ? constructorArguments as Array : [constructorArguments];
				instance = creator.create( null, false, realParams);
			}
			else
			{
				if(type)
				{
					instance= creator.create( this, false, [type, bubbles, cancelable]);
				}
				else
				{
					logger.error(LogTypes.TYPE_NOT_FOUND, new LogInfo(this));
				}
			}
			
			if(eventProperties)		copyProperties(instance, eventProperties);
			if(inlineProperties)	copyProperties(instance, inlineProperties);
			
			if(instance is Event)
			{
				var wasSuccessful:Boolean = dispatchEvent(instance as Event);
			}
			
			return wasSuccessful;
		}
		
		//.........................................getCurrentTarget..........................................
		/**
		*  @private
		*  No documentation about this yet
		*/
		public function getCurrentTarget():Object
		{
			return this;
		}
		//.........................................getLogger..........................................
		/**
		*  @private
		*  No documentation about this yet
		*/
		public function getLogger():IMateLogger
		{
			return logger;
		}
		
		//........................................getDocument..........................................
		/**
		 * @inheritDoc
		 */
		public function getDocument():Object
		{
			return document;
		}
		
		//.........................................errorString..........................................
		/**
		 * @inheritDoc
		 */
		public function errorString():String
		{
			var str:String = "EventType:"+ type + ". Error was found in a Dispatcher in file " 
							+ DebuggerUtil.getClassName( document);
			return str;
		}
		//.........................................removeReponders..........................................
		/**
		*  After a response is back, this method removes all the reponders for a specific event.
		*/
		public function removeReponders(event:Event):void
		{
			if(responseHandlers.length)
			{
				for each(var responder:IResponseHandler in responseHandlers)
				{
					responder.removeResponderListener(event.type, responseDispatcher);
				}
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                           Protected methods
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................addReponders..........................................
		/**
		* Before dispatching the event, this method is called to add all the responders for that specific event.
		*/
		protected function addReponders(event:Event):void
		{
			if(responseHandlers.length)
			{
				var uidu:String = UIDUtil.getUID(event);
				for each(var responder:IResponseHandler in responseHandlers)
				{
					responder.addReponderListener(uidu,responseDispatcher, this);
				}
			}
		}
		
		//.........................................copyProperties..........................................
		/**
		* Copies the properties from an  Object of name-value pairs to the destination.
		* The destination is the new <code>event</code> instance.
		*/
		protected function copyProperties(destination:*, properties:Object):void
		{
			if(destination)
			{
				for (var propertyName:String in properties)
				{
					destination[propertyName] =  properties[propertyName];
				}
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                      Implementation of IMXMLObject interface
		//-----------------------------------------------------------------------------------------------------------
		//.........................................document..........................................
		/**
		 * Internal storage for the document object.
		 */
		protected var document:Object;
		
		//.........................................initialized..........................................
		/**
		 * Called automatically by the MXML compiler if the IActionList is set up using a tag.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
		}
	}
}