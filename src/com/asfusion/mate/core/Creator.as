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
	import com.asfusion.mate.utils.debug.*;
	use namespace mate;
	
	/**
	 * Creator is a factory class that uses a template and an array of arguments to create objects.
	 */
	public class Creator
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Fields
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Instance of <code>IMateManager</code> used to get and set the cached objects created.
		 */
		protected var manager:IMateManager;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                           Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Creator()
		{
			manager = MateManager.instance;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                           Public functions
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * A method that calls createInstance to create the object 
		 * and logs any problem that may encounter.
		 */
		/*-.........................................create..........................................*/
		public function create(template:Class, loggerProvider:ILoggerProvider,cache:Boolean, parameters:Array = null):Object
		{
			var logger:IMateLogger = ( loggerProvider ) ? loggerProvider.getLogger(): manager.getLogger(true);
			var instance:Object;
			var cachedInstance:Object;
			var logInfo:LogInfo;
			var reTry:Boolean;
			
			if(!template)
			{
				logger.error(LogTypes.GENERATOR_NOT_FOUND, new LogInfo(loggerProvider,null));
				return null;
			}
			if(cache)
			{
				cachedInstance = manager.getCachedInstance(template);
				if(cachedInstance)
				{
					return cachedInstance;
				}
			}
			if(parameters && parameters.length > 15)
			{
				logger.error(LogTypes.TOO_MANY_ARGUMENTS, new LogInfo(loggerProvider,null));
			}
			else
			{
				try
				{
					instance = createInstance(template, parameters);
				}
				catch(error:ArgumentError)
				{
					logInfo =  new LogInfo(loggerProvider,template,error,"constructor", parameters);
					logger.error(LogTypes.ARGUMENT_ERROR,logInfo);
					reTry = !logInfo.foundProblem;
				}
				catch(error:TypeError)
				{
					logInfo = new LogInfo(loggerProvider,template,error,"constructor", parameters)
					logger.error(LogTypes.TYPE_ERROR, logInfo);
					reTry = !logInfo.foundProblem;
				}
				if(reTry)
				{
					instance = createInstance(template, parameters);
				}
			}
			if(cache)
			{
				manager.addCachedInstance(template, instance);
			}
			return instance;
		}
		
		/*-.........................................createInstance..........................................*/
		/**
		 * It is the actual creation method. It can throw errors if parameters are wrong.
		 */
		public function createInstance(template:Class, p:Array):Object
		{
			var newInstantce:Object;
			if(!p || p.length == 0)
			{
				newInstantce = new template();
				
			}
			else
			{
				// ugly way to call a constructor. 
				// if someone knows a better way please let me know (nahuel at asfusion dot com).
				switch(p.length)
				{
					case 1:	newInstantce = new template(p[0]); break;
					case 2:	newInstantce = new template(p[0], p[1]); break;
					case 3:	newInstantce = new template(p[0], p[1], p[2]); break;
					case 4:	newInstantce = new template(p[0], p[1], p[2], p[3]); break;
					case 5:	newInstantce = new template(p[0], p[1], p[2], p[3], p[4]); break;
					case 6:	newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5]); break;
					case 7:	newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6]); break;
					case 8:	newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]); break;
					case 9:	newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]); break;
					case 10:newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]); break;
					case 11:newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10]); break;
					case 12:newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]); break;
					case 13:newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12]); break;
					case 14:newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]); break;
					case 15:newInstantce = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14]); break;
				}
			}
			return newInstantce;
		}
	}
}