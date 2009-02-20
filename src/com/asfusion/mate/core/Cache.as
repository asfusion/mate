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
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	use namespace mate;
	
	[Bindable (event="propertyChange")]
	/**
	 * The Cache allows getting cached objects within the event map's <code>IActionList</code>.
	 */
	public class Cache extends Proxy implements IEventDispatcher, ISmartObject
	{
		/** Does not use cache. */
		public static const NONE:String = "none";
		
		/** Local cache, it is the one that lives in the EventMap */
		public static const LOCAL:String = "local";
		
		/** Global cache */
		public static const GLOBAL:String = "global";
		
		/** Use same cache type that is defined in the EventMap.
		 * Can be either local or global*/
		public static const INHERIT:String = "inherit";
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Protected Fields
		//-----------------------------------------------------------------------------------------------------------
		
		/**
		 * A list of properties that has been accessed using the dot operator. 
		 * For example, if you a access an inner property like this: 
		 * myObject.property1.property2, the chain is equivalent to an array 
		 * with 2 items [property1,property2]
		 */
		protected var chain:Array = null;
		
		/**
		 * Whether we create a new instance of the object when we don't find one in the cache.
		 */
		protected var autoCreate:Boolean;
		
		/**
		 *  The constructorArgs allows you to pass an Array of objects to the contructor 
		 *  when the instance is created.
		 */
		protected var constructorArguments:Array;
		
		/**
		 * The cacheType property lets you specify whether we should use a local or cache.
		 */
		protected var cacheType:String;
		
		/**
		 * Registers the newly created object as an injector target. If true, this allows this object to be injected
		 * with properties using the <code>Injectors</code> tags.
		 */
		protected var registerTarget:Boolean;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Setters and Getters
		//------------------------------------------------------------------------------------------------------------
		//.........................................generatorKey..........................................
		private var _generatorKey:Class;
		/**
		 * A key used as index to get the cached objects. The Class name is the key
		 * used to cach objects.
		 */
		public function get generatorKey():Class
		{
			return _generatorKey;
		}
		public function set generatorKey(value:Class):void
		{
			_generatorKey = value;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Contructor
		//------------------------------------------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function Cache(key:Class, 
							 cacheType:String = Cache.INHERIT, 
							  autoCreate:Boolean = false,
							  registerTarget:Boolean = false, 
							  constructorArguments:Array = null):void
		{
			generatorKey = key;
			this.autoCreate = autoCreate;
			this.registerTarget = registerTarget;
			this.constructorArguments = constructorArguments;
			this.cacheType = cacheType;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                             Public Methods
		//-----------------------------------------------------------------------------------------------------------
		//.........................................addKey..........................................
		/**
		 * 
		 */
		public function addKey(chain:Array, key:String):void
		{
			this.chain = (chain) ? chain : new Array();
			this.chain.push(key);
		}
		
		//.........................................addCachedInstance..........................................
		/**
		 * Stores an instance in the cache. The cache can be local, global or inherit. 
		 * The key that we use to store the instance is the class of the object that we want to store.
		 */
		public static function addCachedInstance(key:*, instance:Object, type:String, scope:IScope):void
		{
			if(type == NONE) return;
			if(type == INHERIT)
			{
				type = scope.eventMap.cache;
			}
			
			var cacheCollection:Dictionary;
			if(type == LOCAL)
			{
				cacheCollection = scope.eventMap.getCacheCollection()
			}
			else
			{
				cacheCollection =  scope.getManager().getCacheCollection();
			}
			cacheCollection[key] = instance;
		}
		
		//.........................................getCachedInstance..........................................
		/**
		 * Get an instance from the cache. The cache can be local, global or inherit. 
		 * The key used is the class of the object that we want to access.
		 */
		public static function getCachedInstance(key:*, type:String, scope:IScope):Object
		{
			if(type == INHERIT)
			{
				type = scope.eventMap.cache;
			}
			var cacheCollection:Dictionary;
			if(type == LOCAL)
			{
				cacheCollection = scope.eventMap.getCacheCollection()
			}
			else
			{
				cacheCollection =  scope.getManager().getCacheCollection();
			}
			return cacheCollection[key];
		}
		
		//.........................................clearCachedInstance..........................................
		/**
		 * Removes an instance from the cache. The cache can be local, global or inherit. 
		 * The key used is the class of the object that we want to removed.
		 */
		public static function clearCachedInstance(key:*, type:String, scope:IScope):*
		{
			var instance:*;
			if(type == INHERIT)
			{
				type = scope.eventMap.cache;
			}
			var cacheCollection:Dictionary;
			if(type == LOCAL)
			{
				cacheCollection = scope.eventMap.getCacheCollection()
			}
			else
			{
				cacheCollection =  scope.getManager().getCacheCollection();
			}
			instance = cacheCollection[key];
			delete cacheCollection[key];
			
			return instance;
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                         flash_proxy Methods
		//-----------------------------------------------------------------------------------------------------------
		//.........................................getProperty..........................................
		/**
		 * Overrides any request for a property's value. If the property can't be found, 
		 * the method returns undefined. For more information on this behavior, 
		 * see the ECMA-262 Language Specification, 3rd Edition, section 8.6.2.1.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var localName:String = (name is QName) ? QName(name).localName : name;
			var newCache:Cache = new Cache(generatorKey, cacheType, autoCreate, registerTarget, constructorArguments);
			newCache.addKey(chain, localName);
			return newCache;
		}
		//-----------------------------------------------------------------------------------------------------------
		//                               Implementation of the ISmartObject interface
		//-----------------------------------------------------------------------------------------------------------
		//........................................getValue..........................................
		/**
		 * @inheritDoc
		 */
		public function getValue(scope:IScope, debugCall:Boolean=false):Object
		{
			var value:Object;
			var instance:Object = getCachedInstance(generatorKey, cacheType, scope);
			if(!instance && autoCreate)
			{
				var creator:Creator = new Creator( generatorKey, scope.dispatcher );
				instance = creator.create( scope, registerTarget, constructorArguments, cacheType);
			}
			value = instance;
			if(instance && chain)
			{
				try
				{
					var currentInstance:Object = instance;
					for each(var property:String in chain)
					{
						currentInstance = currentInstance[property];
					}
					value = currentInstance;
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
						var logInfo:LogInfo = new LogInfo(scope, instance, error, null, null, stringChain)
						scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo);
					}
				}
			}
			return value;
		}
		//-----------------------------------------------------------------------------------------------------------
		//                             Implementation of IEventDispatcher interface 
		//-----------------------------------------------------------------------------------------------------------
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
