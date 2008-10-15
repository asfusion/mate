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
package com.asfusion.mate.core
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * Interface that provides an event dispatcher.
	 * This interface is implemented by the EventMap and is used 
	 * by all the IActionList (EventHandlers, Injectors, MessageHandlers, etc) 
	 * to get a local dispatcher.
	 * This allows us to have a different dispatcher per EventMap
	 */
	public interface IEventMap extends IEventDispatcher
	{
		/**
		 * String that indicates whether the event maps will use a global or a local cache. 
		 * Each individual tag (ex: ObjectBuilder) is using this setting by default. 
		 * Their default is inherit, which means that it will use the value that is 
		 * defined in the event map. But each tag can override that to local, global or none.
		 */
		function get cache():String
		function set cache(value:String):void
		
		/**
		 * Method that returns of the local cache dictionary that will be used to store objects
		 * created by the mate framework.
		 */
		function getCacheCollection():Dictionary;

		
		/**
		 * Returns an event dispatcher.
		 */		
		function getDispatcher():IEventDispatcher;
	}
}