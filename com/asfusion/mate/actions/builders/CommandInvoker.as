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
	import com.asfusion.mate.actions.IAction;
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.actionLists.IScope;
	
	import flash.events.Event;
	use namespace mate;
	
	/**
	* The <code>CommandInvoker</code> tag is very similar to the <code>MethodInvokerr</code> tag, but limited. 
	* It only allows specifying the <code>generator</code> class to instantiate. 
	* It will always call the method <code>execute</code> and pass the current event as its only argument. 
	* This tag is very useful when reusing Cairngorm commands.
	* Unless you specify cache="none", this <code>CommandInvoker</code> instance will be "cached" and not instantiated again.
	* 
    * 
	* @mxml
 	* <p>The <code>&lt;mx:CommandInvoker&gt;</code> tag has the following tag attributes:</p>
 	* <pre>
	* &lt;CommandInvoker
 	* <b>Properties</b>
	* generator="Class"
	* constructorArguments="Object|Array"
	* cache="local|global|inherit|none"
 	* /&gt;
	* </pre>
	* 
	* @see com.asfusion.mate.actions.builders.MethodInvokerr
	* @see com.asfusion.mate.actionLists.EventHandlers
	*/
	public class CommandInvoker extends ObjectBuilder
	{
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override protected methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			var methodCaller:MethodCaller = new MethodCaller();
			var event:Event = scope.event;
			scope.lastReturn = methodCaller.call(scope ,currentInstance, 'execute', [event], false);
		}
	}
}