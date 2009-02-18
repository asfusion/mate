package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.Cache;
	
	public class ClearCache extends AbstractAction implements IAction
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Getters and Setters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................cacheKey..........................................
		private var _cacheKey:Object;
		/**
		 * The key to use for the cache
		 */
		public function get cacheKey():Object
		{
			return _cacheKey;
		}
		public function set cacheKey(value:Object):void
		{
			_cacheKey = value;
		}
		
		//.........................................cache..........................................
		private var _cache:String = "inherit";
		/**
		 * The cache atribute is only useful when the destination is a class.
		 * This attribute defines which cache we will look up for a created object.
		*/
		public function get cache():String
		{
			return _cache;
		}
		
		[Inspectable(enumeration="local,global,inherit")]
		public function set cache(value:String):void
		{
			_cache = value;
		}
		
		//------------------------------------------------------------------------------------------------------------
		//                                          Override protected methods
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................run..........................................
		/**
		 * @inheritDoc
		 */ 
		override protected function run(scope:IScope):void
		{
			scope.lastReturn = Cache.clearCachedInstance( cacheKey, cache, scope );
		}
	}
}