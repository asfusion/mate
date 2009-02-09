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

package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.actionLists.IScope;
	
	
	[Exclude(name="method", kind="property")]
	[Exclude(name="arguments", kind="property")]
	
	/**
	 * <code>AsyncCommandInvoker</code> allows calling the execute <code>method</code> 
	 * on the newly created <code>EventDispatcher</code> object or in the instance if 
	 * one is provided. Because the method is asynchronous, we register to the success 
	 * and fault events in this object and run the successHandlers or faultHandlers 
	 * depending of the result. Unless you specify cache="none", this <code>AsyncCommandInvoker</code> 
	 * instance will be "cached" and not instantiated again. If you are using an instance, 
	 * the object is never generated and the same instance is used every time.
	 */
	public class AsyncCommandInvoker extends AsyncMethodInvoker
	{
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Getters and Setters
		//-------------------------------------------------------------------------------------------------------------
		
		
		//........................................method..........................................
		/**
		 * @inheritDoc
		 */
		override public function get method():String
		{
			return "execute";
		}
		
		override public function set method(value:String):void
		{
			throw(new Error("Cannot set a method on the command"));
		}
		
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Override Protected Methods
		//-------------------------------------------------------------------------------------------------------------
		
		//.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			this.arguments = [scope.event];
			super.run(scope);
		}
	}
}