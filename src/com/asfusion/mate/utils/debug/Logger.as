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
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actionLists.Scope;
	import com.asfusion.mate.events.MateLogEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	
	/**
	 * This class dispatches events for each message logged, allowing the debugger to listen to
	 * those events.
	 */
	public class Logger extends EventDispatcher implements IMateLogger
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Implementation of IMateLogger
		-------------------------------------------------------------------------------------------------------------*/
		
		 /*-.........................................category..........................................*/
		private var _category:String = 'com.asfusion.mate';
		/**
		 *  The category this logger send messages for.
		 */
		public function get category():String
		{
			return _category;
		}
		 public function set category(value:String):void
		{
			_category = value;
		}
		
		
		/*-.........................................active..........................................*/	
		private var _active:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get active():Boolean
		{
			return _active;
		}
		public function set active(value:Boolean):void
		{
			_active = value;
		}
		
		
		/*-.........................................isActive..........................................*/
		/**
		 * @inheritDoc
		 */
		public function isActive():Boolean
		{
			return active;
		}
			
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Logger(active:Boolean = false)
		{
			_active = active;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Implementation of ILogger (mx)
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................log..........................................*/
		/**
	     *  Logs the specified data at the given level.
	     *  
	     *  <p>The String specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the String before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  is translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *  
	     *  @param level The level this information should be logged at.
	     *  Valid values are:
	     *  <ul>
	     *    <li><code>LogEventLevel.FATAL</code> designates events that are very
	     *    harmful and will eventually lead to application failure</li>
	     *
	     *    <li><code>LogEventLevel.ERROR</code> designates error events
	     *    that might still allow the application to continue running.</li>
	     *
	     *    <li><code>LogEventLevel.WARN</code> designates events that could be
	     *    harmful to the application operation</li>
	     *
	     *    <li><code>LogEventLevel.INFO</code> designates informational messages
	     *    that highlight the progress of the application at
	     *    coarse-grained level.</li>
	     *
	     *    <li><code>LogEventLevel.DEBUG</code> designates informational
	     *    level messages that are fine grained and most helpful when
	     *    debugging an application.</li>
	     *
	     *    <li><code>LogEventLevel.ALL</code> intended to force a target to
	     *    process all messages.</li>
	     *  </ul>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.  
	     *
	     *  @example
	     *  <pre>
	     *  // Get the logger for the mx.messaging.Channel "category"
	     *  // and send some data to it.
	     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
	     *  logger.log(LogEventLevel.DEBUG, "here is some channel info {0} and {1}", LogEventLevel.DEBUG, 15.4, true);
	     *
	     *  // This will log the following String as a DEBUG log message:
	     *  //   "here is some channel info 15.4 and true"
	     *  </pre>
	     *
	     */
		public function log(level:int, msg:String, ... rest):void
		{
			dispatch(msg, level, rest);	
		}
		
		/*-.........................................debug..........................................*/
		 /**
	     *  Logs the specified data using the <code>LogEventLevel.DEBUG</code>
	     *  level.
	     *  <code>LogEventLevel.DEBUG</code> designates informational level
	     *  messages that are fine grained and most helpful when debugging
	     *  an application.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This string can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *  @example
	     *  <pre>
	     *  // Get the logger for the mx.messaging.Channel "category"
	     *  // and send some data to it.
	     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
	     *  logger.debug("here is some channel info {0} and {1}", 15.4, true);
	     *
	     *  // This will log the following String:
	     *  //   "here is some channel info 15.4 and true"
	     *  </pre>
	     */
		public function debug(msg:String, ... rest):void
		{
			dispatch(msg, LogEventLevel.DEBUG, rest);
		}
	
		/*-.........................................error..........................................*/
		/**
	     *  Logs the specified data using the <code>LogEventLevel.ERROR</code>
	     *  level.
	     *  <code>LogEventLevel.ERROR</code> designates error events
	     *  that might still allow the application to continue running.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *  @example
	     *  <pre>
	     *  // Get the logger for the mx.messaging.Channel "category"
	     *  // and send some data to it.
	     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
	     *  logger.error("here is some channel info {0} and {1}", 15.4, true);
	     *
	     *  // This will log the following String:
	     *  //   "here is some channel info 15.4 and true"
	     *  </pre>
	     */
		public function error(msg:String, ... rest):void
		{
			dispatchError(msg, LogEventLevel.ERROR, rest);
			showWarning('MATE Error: ' +msg, rest);
		}
		
		/*-.........................................fatal..........................................*/
		/**
	     *  Logs the specified data using the <code>LogEventLevel.FATAL</code> 
	     *  level.
	     *  <code>LogEventLevel.FATAL</code> designates events that are very 
	     *  harmful and will eventually lead to application failure
	     *
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *  @example
	     *  <pre>
	     *  // Get the logger for the mx.messaging.Channel "category"
	     *  // and send some data to it.
	     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
	     *  logger.fatal("here is some channel info {0} and {1}", 15.4, true);
	     *
	     *  // This will log the following String:
	     *  //   "here is some channel info 15.4 and true"
	     *  </pre>
	     */
		public function fatal(msg:String, ... rest):void
		{
			dispatchError(msg, LogEventLevel.FATAL, rest);
			showWarning('MATE Error: '+ msg, rest);
		}
		
		/*-.........................................info..........................................*/
		/**
	     *  Logs the specified data using the <code>LogEvent.INFO</code> level.
	     *  <code>LogEventLevel.INFO</code> designates informational messages that 
	     *  highlight the progress of the application at coarse-grained level.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *  @example
	     *  <pre>
	     *  // Get the logger for the mx.messaging.Channel "category"
	     *  // and send some data to it.
	     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
	     *  logger.info("here is some channel info {0} and {1}", 15.4, true);
	     *
	     *  // This will log the following String:
	     *  //   "here is some channel info 15.4 and true"
	     *  </pre>
	     */
		public function info(msg:String, ... rest):void
		{
			dispatch(msg, LogEventLevel.INFO, rest);
		}
		
		/*-.........................................warn..........................................*/
		/**
	     *  Logs the specified data using the <code>LogEventLevel.WARN</code> level.
	     *  <code>LogEventLevel.WARN</code> designates events that could be harmful 
	     *  to the application operation.
	     *      
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *  
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param rest Aadditional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *  @example
	     *  <pre>
	     *  // Get the logger for the mx.messaging.Channel "category"
	     *  // and send some data to it.
	     *  var logger:ILogger = Log.getLogger("mx.messaging.Channel");
	     *  logger.warn("here is some channel info {0} and {1}", 15.4, true);
	     *
	     *  // This will log the following String:
	     *  //   "here is some channel info 15.4 and true"
	     *  </pre>
	     */
		public function warn(msg:String, ... rest):void
		{
			dispatch(msg, LogEventLevel.WARN, rest);
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Protected Methods
		-------------------------------------------------------------------------------------------------------------*/	
		/*-.........................................dispatch..........................................*/
		/**
		 * Dispatches a MateLogEvent for each message logged.
		 */
		protected function dispatch(message:String, level:int, parameters:Array):void
		{
			if (hasEventListener(LogEvent.LOG) && active)
			{
				var event:MateLogEvent = new MateLogEvent(message, level,parameters);
				dispatchEvent(event);
			}
		}
		/*-.........................................dispatchError..........................................*/
		/**
		 * Dispatches all errors even when the setting active is false.
		 */
		protected function dispatchError(message:String, level:int, parameters:Array):void
		{
			if (hasEventListener(LogEvent.LOG))
			{
				var event:MateLogEvent = new MateLogEvent(message, level,parameters);
				dispatchEvent(event);
			}
		}
		
		/**
		 * If the log message has an error level or higher than the current logging level
		 * and the debugger is off, this method will trace a warning message.
		 */
		private function showWarning(msg:String, parameters:Array):void
		{
			if(!active)
			{
				trace("---------------------------------------------------------");
				trace( msg + ', turn on the debugger for more information');
				var message:String = '';
				var info:LogInfo;
				var scope:IScope;
				if(parameters[0] is LogInfo)
				{
					info = parameters[0];
					trace(info.loggerProvider.errorString());
				}
				trace("---------------------------------------------------------");
			}
		}
	}
}