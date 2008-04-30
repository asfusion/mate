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

	/**
	 * Members of the IActionList's <code>actions</code> array must implement this interface.
	 * When an <code>IActionList</code> is executed (ie: when an event is dispatched), 
	 * that <code>IActionList</code> goes over all its actions and calls the method <code>trigger</code> 
	 * on each <code>IAction</code>.
	 * 
	 * @see com.asfusion.mate.actions.IActionList
	 * .
	*/
	public interface IAction
	{
		/**
		 * This method gets called when the EventHandlers (which implements <code>IActionList</code>) or a similar tag is running.
		 * This method is called on each <code>IAction</code> that the <code>IActionList</code> contains in its 
		 * <code>actions</code> array.
		 * <p>It is recomended that you do not override this method unless needed.
		 * Instead, override the four methods that
		 * this method calls (prepare, setProperties, run or complete).</p>
		 * .
		*/
		function trigger(scope:IScope):void
	}
}