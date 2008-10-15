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
package com.asfusion.mate.actions.builders.serviceClasses
{
	/**
	 * <code>Request</code> allows you to add variables to an <code>HTTPServiceInvoker</code> 
	 * that will be set in an object as the <code>request</code> property of the HTTPService call.
	 * Onfe of the advantages of using <code>SmartRequest</code> is that it can read smartObjects 
	 * from the <code>EventMap</code> such as:
	 * event, lastResult, currentEvent, resultObject, fault, message, data, etc.
	 * <p>When using GET method, these variables will be sent as query string parameters. 
	 * Otherwise, they will be added to the POST request.</p>
	 * 
	 * @see com.asfusion.mate.actions.builders.HTTPServiceInvoker
	 */
	public dynamic class Request
	{
		/**
		*  If you need to specify a request property that is called "id", you need
		 * to use <code>_id</code> instead because Flex will normally use the <code>id</code>
		 * property as the identifier for this tag.
		*/
		public var _id:*;
	}
}