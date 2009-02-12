package com.asfusion.mate.testing
{
	import flash.utils.Dictionary;
	
	public class MockCache
	{
		/**
		 * @todo
		 */
		public static var cacheCollection:Dictionary = new Dictionary();
		
		/**
		 * @todo
		 */
		public static function getInstance( generator:Class, cache:Boolean ):*
		{
			var instance:* = cacheCollection[generator];
			if( !instance || !cache )
			{
				instance = new generator();
				if(cache) cacheCollection[generator] = instance;
			}
			return instance;
		}
	}
}