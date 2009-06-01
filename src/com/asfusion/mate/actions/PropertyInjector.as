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
package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.Binder;
	import com.asfusion.mate.core.Cache;
	import com.asfusion.mate.core.Creator;
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.events.InjectorEvent;

	/**
	 * PropertyInjector sets a value from an object (source) to a destination (target). 
	 * If the source key is bindable, the PropertyInjector will bind  
	 * the source to the targetKey. Otherwise, it will only set the property once.
	 */
	public class PropertyInjector extends AbstractAction implements IAction
	{
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Setters and Getters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................targetKey..........................................
		private var _targetKey:String;
		/**
		 * The name of the property that the injector will set in the target object
		 * 
		 * @default null
		 * */
		public function get targetKey():String
		{
			return _targetKey;
		}
		public function set targetKey(value:String):void
		{
			_targetKey = value;
		}
		
		//.........................................targetId..........................................
		private var _targetId:String;
		/**
		 * This tag will run if any of the following statements is true:
		 * If the targetId is null.
		 * If the id of the target matches the targetId.
		 * 
		 * Note:Target is the instance of the target class.
		 * 
		 * @default null
		 * */
		public function get targetId():String
		{
			return _targetId;
		}
		public function set targetId(value:String):void
		{
			_targetId = value;
		}
		
		//........................................source..........................................
		private var _source:*;
		/**
		 * An object that contains the data that the injector will use to set the target object
		 * 
		 * @default null
		 * */
		public function get source():*
		{
			return _source;
		}
		public function set source(value:*):void
		{
			_source = value
		}
		
		//.........................................sourceKey..........................................
		private var _sourceKey:String;
		/**
		 * The name of the property on the source object that the injector will use to read and set on the target object
		 * 
		 * @default null
		 * */
		public function get sourceKey():String
		{
			return _sourceKey;
		}
		public function set sourceKey(value:String):void
		{
			_sourceKey = value
		}
		
		//.........................................sourceCache..........................................
		private var _sourceCache:String = "inherit";
		/**
		 * If the source is a class we will try to get an instance of that class from the cache. 
		 * This property defines whether the cache is local, global, or inherit.
		 * 
		 * @default inherit
		 */
		public function get sourceCache():String
		{
			return _sourceCache;
		}
		[Inspectable(enumeration="local,global,inherit")]
		public function set sourceCache(value:String):void
		{
			_sourceCache = value;
		}
		
		//........................................softBinding..........................................
		private var _softBinding:Boolean = false;
		/**
		 * Flag that will be used to define the type of binding used by the PropertyInjector tag. 
		 * If softBinding is true, it will use weak references in the binding. Default value is false
		 * 
		 * @default false
		 * */
		public function get softBinding():Boolean
		{
			return _softBinding;
		}
		public function set softBinding( value:Boolean ):void
		{
			_softBinding = value
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                          Protected methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................createInstance..........................................
		/**
		* Creates an instance of the <code>source</code> class.
		* 
		*/
		protected function createInstance(scope:IScope):Object
		{
			var sourceObject:Object = Cache.getCachedInstance(source, sourceCache, scope);
			if(!sourceObject)
			{
				var creator:Creator = new Creator( source, scope.dispatcher );
				sourceObject = creator.create( scope, true, null, sourceCache );
			}
			return sourceObject;
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                         Override protected methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................prepare..........................................
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			if(!scope.event is InjectorEvent) return;
			
			var event:InjectorEvent = InjectorEvent(scope.event);
			if(targetId == null || targetId == event.uid)
			{
				if(source is Class)
				{
					currentInstance = createInstance(scope);
				}
				else if (source is ISmartObject)
				{
					currentInstance = ISmartObject(source).getValue(scope);
				}
				else
				{
					currentInstance = source;
				}
			}
		}
		
		//........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(!scope.event is InjectorEvent) return;
			
			var event:InjectorEvent = InjectorEvent(scope.event);
			if(targetId == null || targetId == event.uid)
			{
				var binder:Binder = new Binder( softBinding );
				
				binder.bind(scope, event.injectorTarget, targetKey, currentInstance, sourceKey);
			}
		}
	}
}
