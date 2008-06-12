package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.SmartArguments;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	/**
	 * Allows calling an inline function (a function defined in the event map)
	 * or calling a static function in any class.
	 * You can pass arguments to this function that come from a variety of sources, such as the event itself, 
	`* a server result object, or any other value. 
	 */
	public class InlineInvoker extends AbstractAction implements IAction
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Public Getters and Setters
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................arguments..........................................*/
		private var _arguments:* = undefined;
		
		/**
		*  The property <code>arguments</code> allows you to pass an Object or an Array of objects when calling 
		 * the function defined in the property <code>method</code> .
		*  <p>You can use an array to pass multiple arguments or use a simple Object if the signature of the 
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
		
		
		/*-.........................................method..........................................*/
		private var _method:Function;
		/**
		 * The function to call on the created object.
		 *
		 *  @default null
		 */
		public function get method():Function
		{
			return _method;
		}
		
		public function set method(value:Function):void
		{
			_method = value;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override protected methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(method != null)
			{
				var logInfo:LogInfo;
				var argumentList:Array = (new SmartArguments()).getRealArguments(scope, this.arguments);
				try
				{
					scope.lastReturn = method.apply(null, argumentList);
				}
				catch(error:ArgumentError)
				{
					logInfo =  new LogInfo( scope, null,  error, null, argumentList);
					scope.getLogger().error(LogTypes.ARGUMENT_ERROR,logInfo);
				}
				catch(error:TypeError)
				{
					logInfo =  new LogInfo( scope, null, error, null , argumentList);
					scope.getLogger().error(LogTypes.TYPE_ERROR, logInfo);
				}
			}
			else
			{
				logInfo = new LogInfo( scope, null, null, null, argumentList);
				scope.getLogger().error(LogTypes.METHOD_UNDEFINED, logInfo);
			}
		}
	}
}