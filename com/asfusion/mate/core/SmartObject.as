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
package com.asfusion.mate.core
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actionLists.ScopeProperties;
	import com.asfusion.mate.utils.debug.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace com.asfusion.mate.core.mate;

	[Bindable (event="propertyChange")]
	/**
	 * The Smart Objects can be used within the <code>IActionList</code>.
	 * These objects expose temporary data such as the current event, 
	 * the value returned by a <code>MethodInvoker</code> or the result of a server call.
	 */
	public class SmartObject extends Proxy implements IEventDispatcher, ISmartObject
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Properties
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * A list of properties that has been accessed using the dot operator. 
		 * For example, if you a access an inner property like this: 
		 * myObject.property1.property2, the chain is equivalent to an array 
		 * with 2 items [property1,property2]
		 */
		protected var chain:Array = null;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................sourceKey..........................................*/
		private var _sourceKey:String;
		/**
		 * This is the name of the property that <code>getValue</code> will try to read in
		 * the source object.
		 */
		public function get sourceKey():String
		{
			return _sourceKey;
		}
		public function set sourceKey(value:String):void
		{
			_sourceKey = value;
		}
		
		
		/*-.........................................source..........................................*/
		private var _source:String;
		/**
		 * This is a string that refer to the name of the source that will be used in
		 * the method <code>getValue</code>.
		 * The possible values are:
		 * <ul>
		 * <li>event</li>
		 * <li>currentEvent</li>
		 * <li>result</li>
		 * <li>fault</li>
		 * <li>lastReturn</li>
		 * <li>scope</li>
		 * <li>message</li>
		 * <li>data</li>
		 * </ul>
		 */
		public function get source():String
		{
			return _source;
		}
		public function set source(value:String):void
		{
			_source = value;
		}
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Contructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function SmartObject(source:String = null, key:String = null, chain:Array = null):void
		{
			this.source = source;
			sourceKey = key;
			if(key)
			{
				this.chain = (chain) ? chain : new Array();
				this.chain.push( key );
			}
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................toString..........................................*/
		/**
		 * Returns the string representation of the specified object.
		 */
		public function toString():String
		{
			return (sourceKey) ? source + "." + sourceKey : source;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          flash_proxy Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................getProperty..........................................*/
		/**
		 * Overrides any request for a property's value. If the property can't be found, 
		 * the method returns undefined. For more information on this behavior, 
		 * see the ECMA-262 Language Specification, 3rd Edition, section 8.6.2.1.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var localName:String = (name is QName) ? QName(name).localName : name;
			var newSmarObject:SmartObject = new SmartObject(source, localName, chain);
			return newSmarObject;
		}
		/*-----------------------------------------------------------------------------------------------------------
		*                              Implementation of the ISmartObject interface
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................getValue..........................................*/
		/**
		 * @inheritDoc
		 */
		public function getValue(scope:IScope, debugCall:Boolean = false):Object
		{
			var realSource:Object = (source !=  ScopeProperties.SCOPE) ? scope[source]: scope;
			var value:*;
			if(realSource != null)
			{
				try
				{
					if(!sourceKey)
					{
						value = realSource;
					}
					else
					{
						var currentSource:Object = realSource;
						for each(var property:String in chain)
						{
							currentSource = currentSource[property]
						}
						value = currentSource;
					}
				}
				catch(error:ReferenceError)
				{
					if(debugCall)
					{
						value = "-Error-"
					}
					else
					{
						var stringChain:String = (chain) ? chain.join(".") : null;
						var logInfo:LogInfo = new LogInfo(scope, realSource, error, null, null, stringChain)
						scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo);
					}
				}
			}
			else
			{
				if(!debugCall)
					scope.getLogger().warn(LogTypes.SOURCE_NULL, new LogInfo(scope, this));
			}
			return value;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                             Implementation of IEventDispatcher interface 
		-------------------------------------------------------------------------------------------------------------*/
		private var dispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. 
		 * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void
	    {
	        dispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
	    }
	    
		/**
		 * Dispatches an event into the event flow. The event target is the EventDispatcher object upon which dispatchEvent() is called.
		 */
	    public function dispatchEvent(event:flash.events.Event):Boolean
	    {
	        return dispatcher.dispatchEvent(event);
	    }
	    
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event. 
		 * This allows you to determine where an EventDispatcher object has altered handling of an event type
		 * in the event flow hierarchy. To determine whether a specific event type will actually trigger an
		 * event listener, use <code>IEventDispatcher.willTrigger()</code>.
		 * 
		 * <p>The difference between <code>hasEventListener()</code> and <code>willTrigger()</code> is that <code>hasEventListener()</code>
		 * examines only the object to which it belongs, whereas <code>willTrigger()</code> examines the entire event
		 * flow for the event specified by the type parameter.</p>
		 */
	    public function hasEventListener(type:String):Boolean
	    {
	        return dispatcher.hasEventListener(type);
	    }
	    
		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with 
		 * the EventDispatcher object, a call to this method has no effect.
		 */
	    public function removeEventListener(type:String,
	                                        listener:Function,
	                                        useCapture:Boolean = false):void
	    {
	        dispatcher.removeEventListener(type, listener, useCapture);
	    }
	    
		/**
		 * Checks whether an event listener is registered with this EventDispatcher object
		 * or any of its ancestors for the specified event type. This method returns true
		 * if an event listener is triggered during any phase of the event flow when an 
		 * event of the specified type is dispatched to this EventDispatcher object or any of its descendants.
		 * 
		 * <p>The difference between <code>hasEventListener()</code> and <code>willTrigger()</code> is that <code>hasEventListener()</code>
		 * examines only the object to which it belongs, whereas <code>willTrigger()</code> examines the entire event
		 * flow for the event specified by the type parameter.</p>
		 */
	    public function willTrigger(type:String):Boolean
	    {
	        return dispatcher.willTrigger(type);
	    }
	}
}