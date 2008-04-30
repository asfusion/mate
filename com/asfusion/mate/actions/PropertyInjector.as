package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.Binder;
	import com.asfusion.mate.core.Creator;
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	import flash.events.IEventDispatcher;
	
	import mx.binding.utils.BindingUtils;

	/**
	 * PropertyInjector sets a value from an object (source) to a destination (target). 
	 * If the source object is an IEventDispatcher, the PropertyInjector will bind  
	 * the source with the target. Otherwise, it will only set the property once.
	 */
	public class PropertyInjector extends AbstractAction implements IAction
	{
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public Setters and Getters
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................targetKey..........................................*/
		private var _targetKey:String;
		/**
		 * The name of the property that the injector will set in the target object
		 * 
		 * @default null
		 * */
		public function get targetKey():String
		{
			return _targetKey;
		}
		public function set targetKey(value:String):void
		{
			_targetKey = value;
		}
		
		/*-.........................................source..........................................*/
		private var _source:*;
		/**
		 * An object that contains the data that the injector will use to set the target object
		 * 
		 * @default nulle
		 * */
		public function get source():*
		{
			return _source;
		}
		public function set source(value:*):void
		{
			_source = value
		}
		
		/*-.........................................sourceKey..........................................*/
		private var _sourceKey:String;
		/**
		 * The name of the property on the source object that the injector will use to read and set on the target object
		 * 
		 * @default null
		 * */
		public function get sourceKey():String
		{
			return _sourceKey;
		}
		public function set sourceKey(value:String):void
		{
			_sourceKey = value
		}
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................createInstance..........................................*/
		/**
		* Creates an instance of the <code>source</code> class.
		* 
		*/
		protected function createInstance(scope:IScope):Object
		{
			var creator:Creator = new Creator();
			var sourceObject:Object = creator.create(source, scope, true);
		
			return sourceObject;
		}
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Override protected methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................prepare..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			currentInstance = (source is Class) ? createInstance(scope) : source;
		}
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(scope.event is InjectorEvent)
			{
				var event:InjectorEvent  = InjectorEvent(scope.event);
				var binder:Binder = new Binder();
				
				binder.bind(scope, event.injectorTarget, targetKey, currentInstance, sourceKey);
			}
		}
	}
}