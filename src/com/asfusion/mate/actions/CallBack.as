package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.MethodCaller;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
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
		 * The function to call on the created object.
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
		 * @TODO
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