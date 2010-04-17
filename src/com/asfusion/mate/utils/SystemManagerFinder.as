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
package com.asfusion.mate.utils
{
	import mx.managers.ISystemManager;
	
	[Mixin]
	/**
	 * It is a helper class that use the <code>[Mixin]</code> to obtain
	 * a reference of the <code>ISystemManager</code>
	 */
	public class SystemManagerFinder
	{
		private static var _systemManager:ISystemManager;
		
		/**
		 * This function will be called automatically by the Flex Framework
		 * at a very early stage.
		 */
		public static function init(systemManager:ISystemManager) : void
        {
             _systemManager = systemManager
        }
        
        /**
        * Returns an instance of the <code>ISystemManager</code>
        */
		public static function find():ISystemManager
		{
			return _systemManager;
		}

	}
}