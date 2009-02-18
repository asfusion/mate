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

Author: Laura Arguello, Principal Architect
        http://www.asfusion.com/
                
@ignore
*/
package com.asfusion.mate.testing
{
	public class MockMethod
	{	 
		/** service method name **/
		public var name:String;
		
		/**
		 * This is set at the parent Mock Service, but it is more 
		 * convenient to pass it to the operations. It might let us 
		 * specify this at this level too
		 */ 
		public var mockGenerator:Class;
		
		/** Method to call on the mockGenerator. By default,
		 * this method is the same as the service method call **/
		public var mockGeneratorMethod:String;
		
		/** If you want to delay the result of this
		 * service call, use the delay property with a value
		 * greater than 0. Seconds. **/
		public var delay:int = -1;
		
		/** Use async with a true value when your
		 * mockGeneratorMethod will not immediately return a value
		 * and your mockGenerator will dispatch a ResultEvent
		 * or a FaultEvent **/
		public var async:Boolean = false;
		
		/** If you want the mock service to retrieve
		 * data, usually in XML format, from a URL, supply this
		 * property. Your mockGeneratorMethod will receive 
		 * this data as the last argument of the function call **/
		public var dataUrl:String;
		
		/**
		 * @todo
		 */
		public var cache:Boolean =  true;
		
    	//---------------------------------Contructor----------------------------------------
    	/**
    	 * Constructor
    	 */
		public function MockMethod()
		{
		}

	}
}