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
		
		public function MockMethod()
		{
		}

	}
}