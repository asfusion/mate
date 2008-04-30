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
package com.asfusion.mate.utils.debug
{
	/**
	 * This interface provides an <code>IMateLogger</code> and a reference to a the current target
	 * for debugging purposes.
	 */
	public interface ILoggerProvider
	{
		/**
		 * Returns the current target that is using this scope.
		 * This target is usually set by the <code>IActionList</code> before
		 * calling <code>trigger</code> on its <code>actions</code>.
		 */
		function getCurrentTarget():Object;
		
		/**
		 * Returns an <code>IMateLogger</code> used to log errors.
		 * Similar to Flex <code>ILogger</code>
		 */
		function getLogger():IMateLogger;
		
		/**
		 * A reference to the document object associated with this <code>ILoggerProvider</code>.
		 * A document object is an Object at the top of the hierarchy of a Flex 
		 * application, MXML component, or AS component.
		 */
		function getDocument():Object
		
		/**
		 * Retuns the default error string to be used by the debugger.
		 */
		function errorString():String
		
	}
}