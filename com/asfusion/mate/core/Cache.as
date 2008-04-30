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
	import com.asfusion.mate.core.*;
	
	use namespace mate;
	
	/**
	 * The Cache allows getting cached objects within the event map's <code>IActionList</code>.
	 */
	public class Cache implements ISmartObject
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Instance of <code>IMateManager</code> used to get the cached objects created.
		 */
		protected var manager:IMateManager;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................key..........................................*/
		private var _key:Class;
		/**
		 * Key used as index to get the cached objects. The Class name is the key
		 * used to cach objects.
		 */
		public function get key():Class
		{
			return _key;
		}
		public function set key(value:Class):void
		{
			_key = value;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Contructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Cache(key:Class):void
		{
			this.key = key;
			manager = MateManager.instance;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                               Implementation of the ISmartObject interface
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................getValue..........................................*/
		/**
		 * @inheritDoc
		 */
		public function getValue(scope:IScope, debugCall:Boolean=false):Object
		{
			return manager.getCachedInstance(key);
		}
		
	}
}