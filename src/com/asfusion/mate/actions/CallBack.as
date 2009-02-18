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
	import com.asfusion.mate.core.MethodCaller;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	/**
	 *  When placed inside a <code>IActionList</code> tag and the list is executed, 
	 * <code>CallBack</code>  will call the function specified in the <code>method</code> attribute on the target of the event. 
	 * You can pass arguments to this function that come from a variety of sources, such as the event itself, 
	 * a server result object, or any other value.
	 */
	public class CallBack extends BaseAction implements IAction
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Getters and Setters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................arguments..........................................
		private var _arguments:* = undefined;
		
		/**
		* The property <code>arguments</code> allows you to pass an Object or an Array of objects when calling 
		* the function defined in the property <code>method</code> .
		* <p>You can use an array to pass multiple arguments or use a simple Object if the signature of the 
		* <code>method</code> has only one parameter.</p>
		* 
		*  @default undefined
		*/ 
		public function get arguments():*
		{
			return _arguments;
		}
		
		public function set arguments(value:*):void
		{
			_arguments = value;
		}
		
		
		//.........................................method..........................................
		private var _method:String;
		/**
		 * The function to call on the target object. Target is the <code>event.target</code> object.
		 *
		 *  @default null
		 */
		public function get method():String
		{
			return _method;
		}
		
		public function set method(value:String):void
		{
			_method = value;
		}
		
		//.........................................targetId..........................................
		private var _targetId:String;
		/**
		 * This tag will run if any of the following statements is true:
		 * If the id of the target is null.
		 * If the target does not have a property id.
		 * If the targetId is null.
		 * If the id of the target (<code>event.target.id</code>) matches the targetId.
		 * 
		 * Note:Target is the <code>event.target</code> object.
		 * 
		 * @default null
		 * */
		public function get targetId():String
		{
			return _targetId;
		}
		public function set targetId(value:String):void
		{
			_targetId = value;
		}
		
		//------------------------------------------------------------------------------------------------------------
		//                                          Override protected methods
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................prepare..........................................
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			currentInstance = scope.event.target;
		}
		
		//.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(targetId == null || !currentInstance["id"] || targetId == currentInstance.id)
			{
				if(method)
				{
					var methodCaller:MethodCaller = new MethodCaller();
					scope.lastReturn = methodCaller.call(scope, currentInstance, method, this.arguments);
				}
				else
				{
					var logInfo:LogInfo = new LogInfo( scope, currentInstance, null, null, this.arguments);
					scope.getLogger().error(LogTypes.METHOD_UNDEFINED, logInfo);
				}
			}
		}
	}
}
