package com.asfusion.mate.ioc
{
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.core.IMateManager;
	import com.asfusion.mate.core.MateManager;
	/**
	 * InjectorRegistry registers a target instance to be used by the
	 * <code>InjectorHandlers</code> to inject any properties on it.
	 */
	public class InjectorRegistry
	{
		/**
		 * Register the target instance by dispatching an <code>InjectorEvent</code>.
		 * <code>InjectorHandlers</code> receive this event and can inject any properties
		 * to the registered instance.
		 * A unique identifier can be used if you want to distinguish this
		 * target instance from other from the same class.
		 */
		public static function register(target:Object, uid:* = undefined):Boolean
		{
			var manager:IMateManager = MateManager.instance;
			var event:InjectorEvent = new InjectorEvent( null, target);
			event.uid = uid;
			return manager.dispatcher.dispatchEvent(event);
		}
	}
}