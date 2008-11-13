package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.actionLists.IScope;
	
	
	[Exclude(name="method", kind="property")]
	[Exclude(name="arguments", kind="property")]
	public class AsyncCommandInvoker extends AsyncMethodInvoker
	{
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Getters and Setters
		//-------------------------------------------------------------------------------------------------------------
		
		
		//........................................method..........................................
		/**
		 * @inheritDoc
		 */
		override public function get method():String
		{
			return "execute";
		}
		
		override public function set method(value:String):void
		{
			throw(new Error("Cannot set a method on the command"));
		}
		
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Override Protected Methods
		//-------------------------------------------------------------------------------------------------------------
		
		//.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			this.arguments = [scope.event];
			super.run(scope);
		}
	}
}