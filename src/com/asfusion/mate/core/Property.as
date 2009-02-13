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
	
	/**
	 * <code>Property</code> tag allows you to set a property to an object.
	 * <p>These property can be a mix of SmartObject, normal Objects or object from the cache.
	 * All the <code>SmartObject</code>s will be parsed before the properties are set.
	 * These property must be public.</p>
	 */
	public class Property implements IProperty
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Setters and Getters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................targetKey..........................................
		private var _targetKey:String;
		/**
		 * The name of the property that the Property tag will set in the target object
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
		
		//.........................................sourceKey..........................................
		private var _sourceKey:String;
		/**
		 * The name of the property on the source object that the Property tag will use to 
		 * read and set on the target object
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
		
		//........................................source..........................................
		private var _source:*;
		/**
		 * An object that contains the data that the Property tag will use to set the target object.
		 * 
		 * @default null
		 * */
		public function get source():*
		{
			return _source;
		}
		
		[Inspectable(enumeration="event,data,result,fault,lastReturn,message,scope")]
		public function set source(value:*):void
		{
			_source = value
		}
		
		//.........................................sourceCache..........................................
		private var _sourceCache:String = "inherit";
		/**
		 * The sourceCache is only useful when the source is a class. 
		 * This attribute defines which cache we will look up for a created object.
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
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Public Methods
		//-----------------------------------------------------------------------------------------------------------
		/**
		 * Will set the targetKey property in the target with the value specified in the source.sourceKey. 
		 * If source is a class, we will try to find the instance in the cache.
		 */
		public function setProperties(target:Object, scope:IScope):Object
		{
			if(target && targetKey && source)
			{
				var realSource:Object = getRealObject(source, scope, sourceCache);
				var currentSourceKey:String;
				var logInfo:LogInfo;
				
				try
				{
					if(sourceKey)
					{
						var multipleLevels:int = sourceKey.indexOf(".");
						if(multipleLevels > 0)
						{
							var chainSourceKey:Array = sourceKey.split(".");
							for each(currentSourceKey in chainSourceKey)
							{
								realSource = realSource[currentSourceKey];
							}
							target[targetKey] = realSource;
						}
						else
						{
							currentSourceKey = sourceKey;
							target[targetKey]= realSource[currentSourceKey];
						}
					}
					else
					{
						target[targetKey] = realSource;
					}
				}
				catch(error:ReferenceError)
				{
					logInfo = new LogInfo(scope, target, error, null, null, targetKey)
					scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo);
				}
				catch(error:TypeError)
				{
					logInfo = new LogInfo(scope, target, error, null, null, targetKey)
					logInfo.data = {target:target, targetKey:targetKey, source:realSource, sourceKey:currentSourceKey};
					scope.getLogger().error(LogTypes.PROPERTY_TYPE_ERROR, logInfo);
				}
				
			}
			return target;
		}
		
		//-.........................................getRealObject..........................................
		/**
		* Helper function to get the source object
		* from either a Cache or a SmartObject.
		*/
		protected function getRealObject(obj:*, scope:IScope, cache:String):*
		{
			var realObject:* = obj;
			
			if(obj is Class)
			{
				var value:Object = Cache.getCachedInstance(obj, cache, scope);
				if( value != null ) realObject = value;
			}
			
			if(obj is ISmartObject)
			{
				realObject = ISmartObject(obj).getValue(scope);
			}
			else if(obj is String)
			{
				switch(obj)
				{
					case 'event':
					case 'data':
					case 'result':
					case 'fault':
					case 'lastReturn':
					case 'message':
					case 'scope': realObject = scope[obj]; break;
				}
			}

			return realObject;
		}
	}
}