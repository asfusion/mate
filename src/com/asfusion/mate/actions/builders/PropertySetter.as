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
	
	[Exclude(name="properties", kind="property")]
	/**
	 * <code>PropertySetter</code> will create an object of the class specified
	 *  in the <code>generator</code> attribute. After that, it will set a 
	 * property in the <code>key</code> attribute on the newly created object. 
	 * The value to set can be the <code>source</code> object or a property of 
	 * the source object that is specified in the <code>sourceKey</code> attribute.
	 */
	public class PropertySetter extends ObjectBuilder
	{
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Getters and Setters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................key..........................................*/
		private var _targetKey:* = undefined;
		
		/**
		 * The name of the property that will be set in the generated object.
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
		
		/*-.........................................source..........................................*/
		private var _source:*;
		/**
		 * An object that contains the data that will be used to set the target object.
		 * 
		 * @default undefined
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
		
		/*-.........................................sourceKey..........................................*/
		private var _sourceKey:String;
		/**
		 * The name of the property on the source object that will be used to read
		 * the value to be set the generated object.
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
		
		[Inspectable(enumeration="local,global,inherit,none")]
		public function set sourceCache( value:String ):void
		{
			_sourceCache = value;
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
			
			if(currentInstance.hasOwnProperty(targetKey))
			{
				try
				{
					var value:*;
					if(sourceKey)
					{
						value = realSource[sourceKey];
					}
					else
					{
						value = realSource;
					}
					currentInstance[targetKey] = value;
					scope.lastReturn = value;
				}
				catch(error:ReferenceError)
				{
					logInfo = new LogInfo(scope, currentInstance, error, null, null, targetKey)
					scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo);
				}
				catch(error:TypeError)
				{
					logInfo = new LogInfo(scope, currentInstance, error, null, null, targetKey)
					logInfo.data = {target:currentInstance, targetKey:targetKey, source:realSource, sourceKey:sourceKey};
					scope.getLogger().error(LogTypes.PROPERTY_TYPE_ERROR, logInfo);
				}
			}
		}
		
		/*-.........................................getRealObject..........................................*/
		/**
		* Helper function to get the source or destination objects
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