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
	/**
	 * An Interface used to read SmartObjects.
	 * Allows get the real value of the <code>SmartObject</code>.
	 */
	public interface ISmartObject
	{
		/**
		 * This method returns the real value of the <code>SmartObject</code>
		 */
		function getValue(scope:IScope, debugCall:Boolean = false):Object;
	}
}