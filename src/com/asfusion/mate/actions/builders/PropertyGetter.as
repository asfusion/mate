/*
Copyright 2010 Nick Matelli

Licensed under the Apache License, Version 2.0 (the "License"); 
you may not use this file except in compliance with the License. Y
ou may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, s
oftware distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and limitations under the License

Author: Nick Matelli
        nick14 at gmail dot com
                
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
	 * <code>PropertyGetter</code> will create an object of the class specified
	 * in the <code>generator</code> attribute. After that, it will get a 
	 * property in the <code>key</code> attribute on the newly created object. 
	 * The value can then be retrieved from the scope's lastReturn
	 */
	public class PropertyGetter extends ObjectBuilder
	{
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Getters and Setters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................key..........................................*/
		public var targetKey:* = undefined;
		

		///.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			var logInfo:LogInfo;
			
			if(currentInstance.hasOwnProperty(targetKey))
			{
				scope.lastReturn = currentInstance[targetKey];
			}
		}
	}
}