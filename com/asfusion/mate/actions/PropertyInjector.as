package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.Binder;
	import com.asfusion.mate.core.Cache;
	import com.asfusion.mate.core.Creator;
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.events.InjectorEvent;

	/**
	 * PropertyInjector sets a value from an object (source) to a destination (target). 
	 * If the source key is bindable, the PropertyInjector will bind  
	 * the source to the targetKey. Otherwise, it will only set the property once.
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
		
		/*-.........................................targetId..........................................*/
		private var _targetId:String;
		/**
		 * The name of the property that the injector will set in the target object
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
		
		/*-.........................................source..........................................*/
		private var _source:*;
		/**
		 * An object that contains the data that the injector will use to set the target object
		 * 
		 * @default null
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
		
		/*-.........................................sourceCache..........................................*/
		private var _sourceCache:String = "inherit";
		/**
		 * If the source is a class we will try to get an instance of that class from the cache. 
		 * This property defines whether the cache is local, global, or inherit.
		 * 
		 * @default inherit
		 */
		public function get sourceCache():String
		{
			return _sourceCache;
		}
		[Inspectable(enumeration="local,global,inherit")]
		public function set sourceCache(value:String):void
		{
			_sourceCache = value;
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
			var sourceObject:Object = Cache.getCachedInstance(source, sourceCache, scope);
			if(!sourceObject)
			{
				var creator:Creator = new Creator();
				sourceObject = creator.create(source, scope);
				Cache.addCachedInstance(source, sourceObject, sourceCache, scope);
			}
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
			if(!scope.event is InjectorEvent) return;
			
			var event:InjectorEvent = InjectorEvent(scope.event);
			if(targetId == null || targetId == event.uid)
			{
				if(source is Class)
				{
					currentInstance = createInstance(scope);
				}
				else if (source is ISmartObject)
				{
					currentInstance = ISmartObject(source).getValue(scope);
				}
				else
				{
					currentInstance = source;
				}
			}
		}
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			if(!scope.event is InjectorEvent) return;
			
			var event:InjectorEvent = InjectorEvent(scope.event);
			if(targetId == null || targetId == event.uid)
			{
				var binder:Binder = new Binder();
				
				binder.bind(scope, event.injectorTarget, targetKey, currentInstance, sourceKey);
			}
		}
	}
}