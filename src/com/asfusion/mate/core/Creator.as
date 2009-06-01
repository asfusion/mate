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
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.utils.debug.*;
	
	import flash.events.IEventDispatcher;
	use namespace mate;
	
	/**
	 * Creator is a factory class that uses a template and an array of arguments to create objects.
	 */
	public class Creator
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                          Protected Fields
		//-----------------------------------------------------------------------------------------------------------
		/**
		 * Instance of <code>IMateManager</code> used to get the logger object.
		 */
		protected var manager:IMateManager;
		
		/**
		 * @todo
		 */
		protected var generator:Class;
		
		/**
		 * @todo
		 */
		protected var dispatcher:IEventDispatcher;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                           Constructor
		//-----------------------------------------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function Creator( classGenerator:Class, dispatcher:IEventDispatcher = null )
		{
			manager = MateManager.instance;
			generator = classGenerator;
			this.dispatcher = dispatcher;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		//                                           Public functions
		//------------------------------------------------------------------------------------------------------------
		/**
		 * A method that calls createInstance to create the object 
		 * and logs any problem that may encounter.
		 */
		//.........................................create..........................................
		public function create( loggerProvider:ILoggerProvider, notify:Boolean = false, constructorArguments:* = null, cache:String = "none" ):Object
		{
			var logger:IMateLogger = ( loggerProvider ) ? loggerProvider.getLogger(): manager.getLogger(true);
			var instance:Object;
			var logInfo:LogInfo;
			var reTry:Boolean;
			var realArguments:Array;
			var scope:IScope = ( loggerProvider is IScope ) ? IScope(loggerProvider) : null;
			
			if(!generator)
			{
				logger.error(LogTypes.GENERATOR_NOT_FOUND, new LogInfo(loggerProvider,null));
				return null;
			}
			if( constructorArguments )
			{
				realArguments = (new SmartArguments()).getRealArguments(scope, constructorArguments);
				if( realArguments && realArguments.length > 15 )
				{
					logger.error(LogTypes.TOO_MANY_ARGUMENTS, new LogInfo(loggerProvider,null));
				}
			}
			
			try
			{
				instance = createInstance(generator, realArguments);
				if( cache != Cache.NONE && scope)
				{
					Cache.addCachedInstance( generator, instance, cache, scope );
				}
				if(notify && dispatcher)
				{
					dispatcher.dispatchEvent( new InjectorEvent( null, instance ) );
					dispatcher.dispatchEvent( new InjectorEvent( InjectorEvent.INJECT_DERIVATIVES, instance ) );
				}
			}
			catch(error:ArgumentError)
			{
				logInfo =  new LogInfo(loggerProvider, generator, error, "constructor", realArguments);
				logger.error(LogTypes.ARGUMENT_ERROR,logInfo);
				reTry = !logInfo.foundProblem;
			}
			catch(error:TypeError)
			{
				logInfo = new LogInfo(loggerProvider, generator, error, "constructor", realArguments)
				logger.error(LogTypes.TYPE_ERROR, logInfo);
				reTry = !logInfo.foundProblem;
			}
			if(reTry)
			{
				instance = createInstance(generator, realArguments);
			}
			
			return instance;
		}
		
		//.........................................createInstance..........................................
		/**
		 * It is the actual creation method. It can throw errors if parameters are wrong.
		 */
		public function createInstance(template:Class, p:Array):Object
		{
			var newInstance:Object;
			if(!p || p.length == 0)
			{
				newInstance = new template();
				
			}
			else
			{
				// ugly way to call a constructor. 
				// if someone knows a better way please let me know (nahuel at asfusion dot com).
				switch(p.length)
				{
					case 1:	newInstance = new template(p[0]); break;
					case 2:	newInstance = new template(p[0], p[1]); break;
					case 3:	newInstance = new template(p[0], p[1], p[2]); break;
					case 4:	newInstance = new template(p[0], p[1], p[2], p[3]); break;
					case 5:	newInstance = new template(p[0], p[1], p[2], p[3], p[4]); break;
					case 6:	newInstance = new template(p[0], p[1], p[2], p[3], p[4], p[5]); break;
					case 7:	newInstance = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6]); break;
					case 8:	newInstance = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]); break;
					case 9:	newInstance = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]); break;
					case 10:newInstance = new template(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]); break;
				}
			}
			return newInstance;
		}
	}
}