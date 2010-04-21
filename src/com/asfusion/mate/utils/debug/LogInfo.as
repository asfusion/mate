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
	 * LogInfo is an object sent to the <code>Debugger</code> that encapsulates
	 * all the information necessary to create a log.
	 */
	public class LogInfo
	{
		/**
		 * Current target. Usually, the tag that is executing when
		 * the log occurs, for example, when a <code>MethodInvoker</code>, or a <code>RemoteObjectInvoker</code>
		 * runs.
		 */
		public var target:*;
		
		/**
		 * Current isntance. The object that the target is
		 * working on, for example the instance that a <code>MethodInvoker</code> creates.
		 */
		public var instance:*;
		
		/**
		 * The error thrown by the virtual matchine
		 */
		public var error:Error;
		
		/**
		 * The name of the method or "constructor"
		 */
		public var method:String;
		
		/**
		 * The name of the property
		 */
		public var property:String;
		
		/**
		 * Parameters that were used to call a method or contructor
		 */
		public var parameters:Array;
		
		/**
		 * Any extra data that you need to pass to the logger
		 */
		public var data:Object;
		
		/**
		 * A flag indicating that a problem was found
		 */
		public var foundProblem:Boolean;
		
		/**
		 * The description of the problem
		 */
		public var problem:String;
		
		/**
		 * The current scope at the time that the log occurs.
		 */
		public var loggerProvider:ILoggerProvider;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function LogInfo(loggerProvider:Object, 
								instance:* = null,  
								error:Error = null, 
								method:String = null, 
								parameters:Array = null, 
								property:String = null,
								data:Object = null )
		{
			if( loggerProvider is ILoggerProvider)
			{
				this.loggerProvider = ILoggerProvider(loggerProvider);
				this.target = this.loggerProvider.getCurrentTarget();
				this.instance  = instance;
				this.error = error;
				this.method = method;
				this.parameters = parameters;
				this.property = property;
			}
		}

	}
}