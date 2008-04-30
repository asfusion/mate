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
	import com.asfusion.mate.utils.debug.*;
	use namespace com.asfusion.mate.core.mate;
	
	/**
	 * MethodCaller has the ability to call a method on any object. 
	 * If an error ocurrs, it will send it to the logger.
	 */
	public class MethodCaller
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Public Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * An <code>IMateLogger</code> used to log errors.
		 * Similar to Flex <code>ILogger</code>
		 */
		public var logger:IMateLogger;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................call..........................................*/
		/**
		 * The function used to call methods on objects.
		 * It can also call methods that have arguments if they are provided.
		 */
		public function call(scope:IScope,instance:*, method:String,  args:*, parseArguments:Boolean = true):*
		{
			var returnValue:*;
			var reTry:Boolean;
			var logInfo:LogInfo;
			var parameters:Array;
			
			logger = scope.getLogger();
			parameters = (parseArguments)?getArguments(scope, args): args as Array;
		
			
			if(!instance)
			{
				logger.error(LogTypes.INSTANCE_UNDEFINED, new LogInfo(scope, null));
			}
			else if(!method)
			{
				logInfo = new LogInfo( scope, instance, null, method, parameters);
				logger.error(LogTypes.METHOD_UNDEFINED, logInfo);
			}
			else if(!instance.hasOwnProperty(method))
			{
				logInfo = new LogInfo( scope, instance, null, method, parameters);
				logger.error(LogTypes.METHOD_NOT_FOUND, logInfo);
			}
			else if(!(instance[method]  is Function))
			{
				logInfo = new LogInfo( scope, instance,  null, method, parameters);
				logger.error(LogTypes.NOT_A_FUNCTION, logInfo);
			}
			else
			{
				try
				{
					if(!parameters)
					{
					
						returnValue = instance[method]();
					}
					else
					{
						returnValue = (instance[method] as Function).apply(instance, parameters);
					}
				}
				catch(error:ArgumentError)
				{
					logInfo =  new LogInfo( scope, instance,  error, method, parameters);
					logger.error(LogTypes.ARGUMENT_ERROR,logInfo);
					reTry = !logInfo.foundProblem;
				}
				catch(error:TypeError)
				{
					logInfo =  new LogInfo( scope, instance, error, method, parameters);
					logger.error(LogTypes.TYPE_ERROR, logInfo);
					reTry = !logInfo.foundProblem;
				}
				if(reTry)
				{
					returnValue = (!parameters)?instance[method]():(instance[method] as Function).apply(instance, parameters);
				}
			}
			return returnValue;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                     Private Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................getArguments..........................................*/
		private function getArguments(scope:IScope, parameters:*):Array
		{
			return (new SmartArguments()).getRealArguments(scope, parameters);
		}

	}
}