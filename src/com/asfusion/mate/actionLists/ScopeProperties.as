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
package com.asfusion.mate.actionLists
{
	/**
	 * This class is a list of available types for <code>ISmartObject</code>s
	 */
	public final class ScopeProperties
	{
		/**
		 * Original Event that triggered the <code>IActionList</code>
		 */
		public static const EVENT:String = "event";
		
		/**
		 * Current Event, different from the original event when 
		 * a sub-action-list is running.
		 */
		public static const CURENT_EVENT:String = "currentEvent";
		
		/**
		 * Result Object from a service
		 */
		public static const RESULT:String = "result";
		
		/**
		 * Fault Object from a service
		 */
		public static const FAULT:String = "fault";
		
		/**
		 * return from the last <code>IAction</code> run
		 */
		public static const LAST_RETURN:String = "lastReturn";
		
		/**
		 * Scope of the <code>IActionList</code>
		 */
		public static const SCOPE:String = "scope";
		
		/**
		 * Message from DataServices
		 */
		public static const MESSAGE:String = "message";
		
		/**
		 * Data Object (holder for custom data)
		 */
		public static const DATA:String = "data";
		
		/**
		 * Cache of <code>IAction<code> instances
		 */
		public static const CACHE:String = "cache";
	}
}