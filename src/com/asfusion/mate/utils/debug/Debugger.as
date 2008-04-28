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
	import com.asfusion.mate.core.*;
	
	import mx.logging.*;
	import mx.logging.targets.*;
	
	/**
	 * The <code>Debugger</code> tag allows debugging your Mate code 
	 * (<code>EventHandlers</code> and inner-acction-lists, <code>IAction</code>, etc). 
	 * When using this tag, you specify a level of debugging, which will filter the type of messages you see.
	 * 
	 * <p>It is recommended that you remove this tag from your code when you are ready to deploy. 
	 * Its use during production will impact performance if you enabled the debugging in many objects 
	 * (ie: in many <code>EventHandlers</code>) or if you specified a low debugging level such as ALL or DEBUG.</p>
	 * 
	 * @example
	 * 
	 * <listing version="3.0">
	 * &lt;mate:Debugger level="{Debugger.ALL}" /&gt;
	 * </listing>
	 * 
	 */
	public class Debugger implements ILoggingTarget 
	{
		/**
		 * A helper object that will return messages with debug information.
		 */
		protected var helper:IDebuggerHelper;
		
		/**
		 * Tells a target to process all messages.
		 */
		public static const ALL:int = 0;
		
		/**
		 * Designates informational level messages that are fine grained and most helpful when debugging an application.
		 */
		public static const DEBUG:int = 2;
		
		/**
		 * Designates informational messages that highlight the progress of the application at coarse-grained level.
		 */
		public static const INFO:int = 4;
		
		/**
		 * Designates events that could be harmful to the application operation.
		 */
		public static const WARN:int = 6;
		
		/**
		 *  Designates error events that might still allow the application to continue running.
		 */
		public static const ERROR:int = 8;
		
		/**
		 * Designates events that are very harmful and will eventually lead to application failure.
		 */
		public static const FATAL:int = 1000;
		
		/*-.........................................filters..........................................*/
	    private var _filters:Array = [ "*" ];
	
		[Inspectable(category="General", arrayType="String")]
		
	    /**
	     *  In addition to the <code>level</code> setting, filters are used to
	     *  provide a psuedo-hierarchical mapping for processing only those events
	     *  for a given category.
	     *  <p>
	     *  Each logger belongs to a category.
	     *  By convention these categories map to the fully-qualified class name in
	     *  which the logger is used.
	     *  For example, a logger that is logging messages for the
	     *  <code>mx.rpc.soap.WebService</code> class, uses 
	     *  "mx.rpc.soap.WebService" as the parameter to the 
	     *  <code>Log.getLogger()</code> method call.
	     *  When messages are sent under this category only those targets that have
	     *  a filter which matches that category receive notification of those
	     *  events.
	     *  Filter expressions can include a wildcard match, indicated with an
	     *  asterisk.
	     *  The wildcard must be the right-most character in the expression.
	     *  For example: rpc~~, mx.~~, or ~~.
	     *  If an invalid expression is specified, a <code>InvalidFilterError</code>
	     *  is thrown.
	     *  If <code>null</code> or [] is specified, the filters are set to the
	     *  default of ["~~"].
	     *  </p>
	     *  @example
	     *     <pre>
	     *           var traceLogger:ILoggingTarget = new TraceTarget();
	     *           traceLogger.filters = ["mx.rpc.~~", "mx.messaging.~~"];
	     *           Log.addTarget(traceLogger);
	     *     </pre>
	     */
	    public function get filters():Array
	    {
	        return _filters;
	    }
	    public function set filters(value:Array):void
    	{
    		_filters = value;
    	}
	    
	    
	    
	   /*-.........................................level..........................................*/ 
	    private var _level:int = ERROR;
	
	    /**
	     *  Provides access to the level this target is currently set at.
	     *  Value values are:
	     *    <ul>
	     *      <li><code>Debugger.FATAL</code> designates events that are very
	     *      harmful and will eventually lead to application failure</li>
	     *
	     *      <li><code>Debugger.ERROR</code> designates error events that might
	     *      still allow the application to continue running.</li>
	     *
	     *      <li><code>Debugger.WARN</code> designates events that could be
	     *      harmful to the application operation</li>
		 *
	     *      <li><code>Debugger.INFO</code> designates informational messages
	     *      that highlight the progress of the application at
	     *      coarse-grained level.</li>
		 *
	     *      <li><code>Debugger.DEBUG</code> designates informational
	     *      level messages that are fine grained and most helpful when
	     *      debugging an application.</li>
		 *
	     *      <li><code>Debugger.ALL</code> intended to force a target to
	     *      process all messages.</li>
	     *    </ul>
	     */
	    public function get level():int
	    {
	        return _level;
	    }
	    [Inspectable(enumeration="{Debugger.ALL},{Debugger.DEBUG},{Debugger.INFO},{Debugger.WARN},{Debugger.ERROR},{Debugger.FATAL}")]
	    public function set level(value:int):void
	    {
	       _level = value;    
	    }
	    
	    
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Debugger()
		{
			MateManager.instance.debugger = this;
			helper = new DebuggerHelper();
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Public Methods
		-------------------------------------------------------------------------------------------------------------*/
		/**
	     *  Sets up this target with the specified logger.
	     *  This allows this target to receive log events from the specified logger.
		 *
	     *  @param logger The ILogger that this target should listen to.
	     */
	    public function addLogger(logger:ILogger):void
	    {
	        if (logger)
	        {
	            logger.addEventListener(LogEvent.LOG, logHandler,false,0,true);
	        }
	    }
	
	    /**
	     *  Stops this target from receiving events from the specified logger.
		 *
	     *  @param logger The ILogger that this target should ignore.
	     */
	    public function removeLogger(logger:ILogger):void
	    {
	        if (logger)
	        {
	            logger.removeEventListener(LogEvent.LOG, logHandler);
	        }
	    }
	    /*-----------------------------------------------------------------------------------------------------------
		*                                      Protected Methods
		-------------------------------------------------------------------------------------------------------------*/
	    /**
	     *  @protected
	     *  This method will call the <code>logEvent</code> method if the level of the
	     *  event is appropriate for the current level.
	     */
	    protected function logHandler(event:LogEvent):void
	    {
	        if (event.level >= level && applyFilter((event.target as Logger).category))
	            logEvent(event);
	    }
	    
	    /**
	    * This method filters by category
	    */
	    protected function applyFilter(category:String):Boolean
	    {
	    	var pass:Boolean;
	    	for each(var filter:String in filters)
	    	{
	    		if(filter == "*" || filter == category) return true;
	    	}
	    	return pass;
	    }
		/*-.........................................logEvent..........................................*/
		/**
		 * This method handles a <code>LogEvent</code> from an associated logger. 
		 * A target uses this method to translate the event into the appropriate format for transmission,
		 * storage, or display. This method is called only if the event's level is in range of the target's level.
		 */
		protected function logEvent(event:LogEvent):void
		{
			trace(helper.getMessage(event));
		}
		
	}
}