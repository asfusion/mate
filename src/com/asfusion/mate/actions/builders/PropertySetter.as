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
package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.Cache;
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	public class PropertySetter extends ObjectBuilder
	{
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Getters and Setters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................key..........................................*/
		private var _key:* = undefined;
		
		/**
		 * The name of the property that will set in the target object
		 * 
		 * @default null
		 * */
		public function get key():String
		{
			return _key;
		}
		public function set key(value:String):void
		{
			_key = value;
		}
		
		/*-.........................................source..........................................*/
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
		
		/*-.........................................sourceKey..........................................*/
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
		
		/*-.........................................sourceCache..........................................*/
		private var _sourceCache:String = "inherit";
		/**
		 * The sourceCache is only useful when the source is a class. 
		 * This attribute defines which cache we will look up for a created object.  
		*/
		public function get sourceCache():String
		{
			return _sourceCache;
		}
		//-----------------------------------------------------------------------------------------------------------
		//                                          Override protected methods
		//-----------------------------------------------------------------------------------------------------------
		
		///.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			var realSource:* = getRealObject(source, scope, sourceCache);
			var logInfo:LogInfo;
			
			if(currentInstance.hasOwnProperty(key))
			{
				try
				{
					if(sourceKey)
					{
						currentInstance[key] = realSource[sourceKey];
					}
					else
					{
						currentInstance[key] = realSource;
					}
					scope.lastReturn = currentInstance[key];
				}
				catch(error:ReferenceError)
				{
					logInfo = new LogInfo(scope, currentInstance, error, null, null, key)
					scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo);
				}
				catch(error:TypeError)
				{
					logInfo = new LogInfo(scope, currentInstance, error, null, null, key)
					logInfo.data = {target:currentInstance, targetKey:key, source:realSource, sourceKey:sourceKey};
					scope.getLogger().error(LogTypes.PROPERTY_TYPE_ERROR, logInfo);
				}
			}
		}
		
		/*-.........................................getRealObject..........................................*/
		/**
		*  Helper function to get the source or destination objects
		 * from either a String value, a SmartObject or other.
		*/
		protected function getRealObject(obj:*, scope:IScope, cache:String):*
		{
			var realObject:* = obj;
			if(obj is Function ) obj = obj();
			
			if(obj is Class) realObject = Cache.getCachedInstance(obj, cache, scope);
			
			if(obj is ISmartObject)
			{
				realObject = ISmartObject(obj).getValue(scope);
			}
			else if(obj is String)
			{
				realObject = scope[obj];
			}

			return realObject;
		}
	}
}