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
	 * The <code>IProperty</code> interface allows to set properties in an Object. 
	 * The <code>BaseAction</code> class uses this interface as a type of the 
	 * <code>properties</code> attribute. That allows any action to have properties 
	 * defined in mxml.
	 */
	public interface IProperty
	{
		function setProperties(target:Object, scope:IScope):Object
	}
}