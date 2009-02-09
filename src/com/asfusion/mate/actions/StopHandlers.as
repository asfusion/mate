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
package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.ISmartObject;
	
	/**
	 * The <code>StopHandlers</code> tag lets you stop a certain <code>IActionList</code>
	 * before it reaches the end of the listeners list. The <code>IActionList</code> can be stopped based on whether
	 * the "lastReturn" is equal to some value, or based on an external function that tells whether
	 * or not the <code>IActionList</code> must be stopped.
	 * 
     * @example This example demonstrates how you can use a StopHandlers tag with a custom 
     * custom <code>stopFunction</code>.
     * 
     * <listing version="3.0">
     * private function myStopHandlersFunction(scope:Scope):Boolean 
     * {
     *    ... here you do some evaluation to determine
     *        whether to stop the Actionlist or not...
     *     return false; //or return true;
	 * }
     *
     * &lt;StopHandlers
	 *          stopFunction="myStopHandlersFunction"/&gt;
     * </listing>
	 * 
	 * @mxml
 	 * <p>The <code>&lt;StopHandlers&gt;</code> tag has the following tag attributes:</p>
 	 * <pre>
	 * &lt;StopHandlers
 	 * <b>Properties</b>
	 * lastReturnEquals="value"
	 * stopFunction="Function"
	 * eventPropagation="noStop|stopPropagation|stopImmediatePropagation"
 	 * /&gt;
	 * </pre>
	 * 
	 * @see com.asfusion.mate.actionLists.EventHandlers
	 */	
	public class StopHandlers extends AbstractAction implements IAction
	{
		
		/*-.........................................lastReturnEquals..........................................*/
		private var _lastReturnEquals:*;
		/**
		 * If there exists a <code>MethodInvoker</code> right before the StopHandlers, and the execution of the 
		 * function of the <code>MethodInvoker</code> returned a value ("lastReturn"), you can compare it to some other 
		 * value and stop the <code>IActionList</code> if it is equal.
		 */
		public function get lastReturnEquals():*
		{
			return _lastReturnEquals;
		}
		public function set lastReturnEquals(value:*):void
		{
			_lastReturnEquals = value;
		}
		
		
		/*-.........................................stopFunction..........................................*/
		private var _stopFunction:Function;
		/**
		 * A function to call to determine whether or not the <code>IActionList</code> must stop
		 * execution. This is a more flexible approach than using lastReturnEquals. 
		 * The function that you implement needs to return true if the <code>IActionList</code> must stop or false if not.
		 */
		public function get stopFunction():Function
		{
			return _stopFunction;
		}
		public function set stopFunction(value:Function):void
		{
			_stopFunction = value;
		}
		
		
		/*-.........................................eventPropagation..........................................*/
		private var _eventPropagation:String = "stopImmediatePropagation";
		/**
		 * This attribute lets you stop the event that triggered the <code>IActionList</code>. If there are any handlers for
		 * this event other than this <code>IActionList</code>, they will not be notified if the propagation of the event
		 * is stopped. See Flex documentation regarding the difference between stop propagation and stop immediate propagation
		 * 
		 * @default stopImmediatePropagation
		 */
		public function get eventPropagation():String
		{
			return _eventPropagation;
		}
		[Inspectable(enumeration="noStop,stopPropagation,stopImmediatePropagation")]
		public function set eventPropagation(value:String):void
		{
			_eventPropagation = value;
		}
		
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(stopFunction != null)
			{
				if(stopFunction(scope)) scope.stopRunning();
			}
			else if(lastReturnEquals != null)
			{
				var realReturn:* = (lastReturnEquals is ISmartObject) ? ISmartObject(lastReturnEquals).getValue(scope) : lastReturnEquals;
				if(realReturn == scope.lastReturn)
				{
					scope.stopRunning();
				}
			}
			
			if(eventPropagation != "noStop" && scope.event != null)
			{
				if(eventPropagation == "stopImmediatePropagation")
				{
					scope.event.stopImmediatePropagation();
				} 
				else
				{
					scope.event.stopPropagation();
				}
			}
			
			if(stopFunction != null && lastReturnEquals != null)
			{
				//TODO review
				trace("Warning : stopFunction and lastReturnEquals cannot both be used. lastReturnEquals was ignored");
			}
		}
	}
}