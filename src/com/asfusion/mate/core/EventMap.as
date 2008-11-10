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
	import com.asfusion.mate.actionLists.ScopeProperties;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IMXMLObject;
	
	[Exclude(name="activate", kind="event")]
	[Exclude(name="deactivate", kind="event")]
	
	/**
	 * A fundamental part of <strong>Mate</strong> is the <code>EventMap</code> tag which allows you define mappings for the events that your application creates. 
	 * It is basically a list of <code>IActionList</code> blocks, where each block matches an event type (if the block is an <code>EventHandlers</code>).
	 * 
     * @example
     * 
     * <listing version="3.0">
     * &lt;EventMap
	 *          xmlns:mx="http://www.adobe.com/2006/mxml"
	 *          xmlns:mate="http://mate.asfusion.com/"&gt;
	 * 
	 *          &lt;EventHandlers type="myEventType"&gt;
	 *               ... here what you want to happen when this event is dispatched...
	 *          &lt;/EventHandlers&gt;
	 * 
	 * &lt;/EventMap&gt;
     * </listing>
	 */
	public class EventMap extends EventDispatcher implements IMXMLObject, IEventMap
	{
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Public Getters (SmartObjects)
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................event..........................................*/
		private var _event:SmartObject = new SmartObject(ScopeProperties.EVENT);
		[Bindable(event="propertyChange")]
		/**
		 * It refers to the event that made the <code>EventHandlers</code> execute. The event itself or properties of the event
		 * can be used as arguments of <code>MethodInvoker</code> methods, service methods, properties of all the <code>IAction</code>, etc.
		 * 
		 * @see currentEvent
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get event():*
		{
			return _event;
		}
		
		/*-.........................................currentEvent..........................................*/
		private var _currentEvent:SmartObject = new SmartObject(ScopeProperties.CURENT_EVENT);
		[Bindable(event="propertyChange")]
		/**
		 * It refers to the currentEvent that made the action-list (or inner-action-list) execute.
		 * Inside the inner-action-list this property has the value of the current event while event has the
		 * value of the original event of the main action-list.
		 * The currentEvent itself or properties of the event  can be used as arguments of <code>MethodInvoker</code>
		 *  methods, service methods, properties of all the <code>IAction</code>, etc.
		 * 
		 * @see event
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get currentEvent():*
		{
			return _currentEvent;
		}
		
		/*-.........................................fault..........................................*/
		private var _fault:SmartObject = new SmartObject(ScopeProperties.FAULT);
		[Bindable(event="propertyChange")]
		/**
		 * It refers to the fault returned by a service that made the inner-action-list (<code>faultHandlers</code>) execute. 
		 * The fault itself or properties of the fault can be used as arguments of <code>MethodInvoker</code>
		 *  methods, service methods, properties of all the <code>IAction</code>, etc.
		 * 
		 * <p>Available only inside a <code>faultHandlers</code> inner tag.</p>
		 * 
		 * @see com.asfusion.mate.actionList.ServiceInvoker
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get fault():*
		{
			return _fault;
		}
		
		/*-.........................................resultObject..........................................*/
		private var _resultObject:SmartObject = new SmartObject(ScopeProperties.RESULT);
		[Bindable(event="propertyChange")]
		/**
		 * It refers to the result returned by a service that made the inner-action-list (<code>resultHandlers</code>) execute. 
		 * The result itself or properties of the result can be used as arguments of <code>MethodInvoker</code>
		 *  methods, service methods, properties of all the <code>IAction</code>, etc.
		 * 
		 * <p>Available only inside a <code>resultHandlers</code> inner tag.</p>
		 * 
		 * @see com.asfusion.mate.actionList.ServiceInvoker
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get resultObject():*
		{
			return _resultObject;
		}
		
		/*-.........................................lastReturn..........................................*/
		private var _lastReturn:SmartObject = new SmartObject(ScopeProperties.LAST_RETURN);
		[Bindable(event="propertyChange")]
		/**
		 * lastReturn is always available, although its value might be <code>null</code>. 
		 * It typically represents the value returned by a method call made on a <code>MethodInvoker</code>, 
		 * but other <code>IActions</code> might also return a value, such as:
		 * <ul><li><code>token</code>: returned by <code>RemoteObjectInvoker</code>, 
		 * <code>WebServiceInvoker</code> and <code>HTTPServiceInvoker</code> (value is returned before call result is received)</li>
		 * <li><code>Boolean value</code>: returned by <code>EventAnnouncer</code> after dispatching the event. True for successful dispatch, 
		 * false for unsuccessful (either a failure or when preventDefault() was called on the event).</li></ul>
		 * 
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get lastReturn():*
		{
			return _lastReturn;
		}
		
		/*-.........................................message..........................................*/
		private var _message:SmartObject = new SmartObject(ScopeProperties.MESSAGE);
		[Bindable(event="propertyChange")]
		/**
		 * It refers to the message received that made the <code>MessageHandlers</code> execute. 
		 * The message itself or properties of the message can be used as arguments of 
		 * <code>MethodInvoker</code> methods, service methods, properties of all the <code>IActions</code>, etc.
		 * <p>Available only inside a <code>MessageHandlers</code> tag.</p>
		 * 
		 * @see com.asfusion.mate.actionLists.MessageHandlers
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get message():*
		{
			return _message;
		}
		/*-.........................................data..........................................*/
		private var _data:SmartObject = new SmartObject(ScopeProperties.DATA);
		[Bindable(event="propertyChange")]
		/**
		 * Every <code>IActionList</code> contains a placeholder object called <code>data</code>. 
		 * This object can be used to store temporary data that many tags in the <code>IActionList</code> can share.
		 * 
		 * @see com.asfusion.mate.core.SmartObject
		 */
		public function get data():*
		{
			return _data;
		}
		
		/*-.........................................scope..........................................*/
		private var _scope:SmartObject = new SmartObject(ScopeProperties.SCOPE);
		[Bindable(event="propertyChange")]
		/**
		  * It refers to the <code>scope</code> of the <code>IActionList</code>. 
		  * The type of the <code>scope</code> is depending the type of <code>IActionList</code>.
		  * <p>Available types are:
		  * <ul><li><code>Scope</code> for <code>EventHandlers, InjectorHandlers</code></li>
		  * <li><code>ServiceScope</code> for <code>ServiceHandlers</code></li>
		  * <li><code>MessageScope</code> for <code>MessageHandlers</code></li></ul>
		  * </p>
		  * 
		  * @see com.asfusion.mate.core.SmartObject
		 */
		public function get scope():*
		{
			return _scope;
		}
		
		
		/*-.........................................cache..........................................*/
		protected var _cache:String = Cache.GLOBAL;
		/**
		  * @inheritDoc
		 */
		public function get cache():String
		{
			return _cache;
		}
		[Inspectable(enumeration="local,global")]
		public function set cache(value:String):void
		{
			if(_cache !== value)
			{
				_cache = value;
			}
		}
		
		/*-.........................................getCacheCollection..........................................*/
		protected var cacheCollection:Dictionary = new Dictionary();
		/**
		 *  @inheritDoc
		 */
		public function getCacheCollection():Dictionary
		{
			return cacheCollection;
		}
		
		/*-.........................................getCached..........................................*/
		/**
		 * Function to get cached instances from the framework.
		 * A Cache is returned instead of actual instance.
		 * 
		 * @see com.asfusion.mate.core.Cache
		 */
		public function getCached(template:Class,
								cacheType:String = Cache.INHERIT, 
								autoCreate:Boolean = true,
								registerTarget:Boolean = false, 
								constructorArguments:Array = null ):*
		{
			return new Cache(template, cacheType, autoCreate, registerTarget, constructorArguments);
		}
		
		
		//.........................................globalDispatcher..........................................
		public function get globalDispatcher():IEventDispatcher
		{
			return MateManager.instance.dispatcher;
		}
		
		/*-.........................................currentDispatcher..........................................*/
		/**
		 * Local storage for the current dispatcher. 
		 */
		private var _dispatcher:IEventDispatcher;
		
		/*-.........................................getDispatcher..........................................*/
		/**
		 * @inheritDoc
		 */ 
		public function getDispatcher():IEventDispatcher
		{
			if(!_dispatcher)
			{
				_dispatcher = globalDispatcher;
			}
			return _dispatcher;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Implementation of IMXMLObject interface
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................document..........................................*/
		/**
		 * A reference to the document object associated with this EventMap. A document object is an Object at the top
		 * of the hierarchy of a Flex application, MXML component, or AS component.
		 */
		protected var document:Object;
		/*-.........................................initialized..........................................*/
		/**
		 * Called automatically by the MXML compiler if the EventMap is set up using a tag.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
		}
	}
}