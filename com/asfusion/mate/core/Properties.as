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
	
	use namespace mate;
	
	/**
	 * <code>Properties</code> tag allows you to add properties to an object.
	 * <p>These properties can be a mix of SmartObject and normal Objects.
	 * All the <code>SmartObject</code>s will be parsed before the properties are set.
	 * These properties must be public.</p>
	 */
	public dynamic class Properties
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		*  If you need to specify a property that is called "id", you need
		* to use <code>_id</code> instead because Flex will normally use the <code>id</code>
		* property as the identifier for this tag.
		*/
		public var _id:*;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public static methods
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * This method will parse all the SmartObjects and set the real values in the
		 * <code>target</code> Object
		 */
		public static function smartCopy(source:Object, target:Object, scope:IScope):Object
		{
			for( var propertyName:String in source)
			{
				var realValue:* = source[propertyName];
				if(realValue is ISmartObject)
				{
					realValue = ISmartObject(realValue).getValue(scope, scope.getCurrentTarget()); 
				}
				try
				{
					target[propertyName] = realValue;
				}
				catch(error:ReferenceError)
				{
					var logInfo:LogInfo = new LogInfo(scope, target, error, null, null, propertyName)
					scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo); 
				}
				
			}
			if(source._id) target['id'] = source._id;
			return target;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Similar to <code>smartCopy</code> this method will copy the properties
		 * to the target object. 
		 * The difference is that it will copy its own properties to the target.
		 */
		public function injectProperties(target:Object, scope:IScope):Object
		{
			return smartCopy(this,target,scope);
		}

	}
}