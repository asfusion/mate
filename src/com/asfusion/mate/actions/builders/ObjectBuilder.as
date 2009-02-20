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
package com.asfusion.mate.actions.builders
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actions.BaseAction;
	import com.asfusion.mate.actions.IAction;
	import com.asfusion.mate.core.*;
	use namespace mate;
	
	/**
	 * ObjectBuilder is the base class for all the classes that use the <code>generator</code> property
	 * to create instances. The <code>generator</code> is the class template to use to instantiate new objects.
	 * 
	 */
	public class ObjectBuilder extends BaseAction implements IAction, IBuilder
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                        Public Setters and Getters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................generator..........................................
		private var _generator:Class;
		/**
		 * @inheritDoc
		 */
		public function get generator():Class
		{
			return _generator;
		}
		public function set generator(value:Class):void
		{
	 		_generator = value;
		}
		
		
		
		//.........................................constructorArguments..........................................
		private var _constructorArguments:* = undefined;
		/**
		*  The constructorArgs allows you to pass an Object or an Array of objects to the contructor 
		*  when the instance is created.
		*  <p>You can use an array to pass multiple arguments or use a simple Object if your 
		 * signature has only one parameter.</p>
		*
		*    @default undefined
		*/
		public function get constructorArguments():*
		{
			return _constructorArguments;
		}
		public function set constructorArguments(value:*):void
		{
	 		_constructorArguments = value;
		}
		
		//.........................................cache..........................................
		private var _cache:String = "inherit";
		/**
		 * The cache attribute lets you specify whether this newly created object should be kept live 
		 * so that the next time an instance of this class is requested, this already created object 
		 * is returned instead.
		 * 
		 *  @default inherit
		 */
		public function get cache():String
		{
			return _cache;
		}
		[Inspectable(enumeration="local,global,inherit,none")]
		public function set cache(value:String):void
		{
			_cache = value;
		}
		
		//.........................................registerTarget..........................................
		private var _registerTarget:Boolean = true;
		/**
		 * Registers the newly created object as an injector target. If true, this allows this object to be injected
		 * with properties using the <code>Injectors</code> tags.
		 */
		 public function get registerTarget():Boolean
		{
			return _registerTarget;
		}
		[Inspectable(enumeration="true,false")]
		public function set registerTarget(value:Boolean):void
		{
			_registerTarget = value;
		}
		
		
		
		//-----------------------------------------------------------------------------------------------------------
		//                                           Protected methods
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................createInstance..........................................
		/**
		* Where the currentInstance is created using the 
		* <code>generator</code> class as the template, passing arguments to the constructor
		* as specified by the <code>constructorArgs</code> (if any).
		* 
		*/
		protected function createInstance(scope:IScope):Object
		{	
			if(cache != Cache.NONE)
			{
				currentInstance = Cache.getCachedInstance(generator, cache, scope);
			}
			
			if(!currentInstance || cache == Cache.NONE)
			{
				var creator:Creator = new Creator( generator, scope.dispatcher );
				currentInstance = creator.create( scope, registerTarget, constructorArguments, cache );
			}
			return currentInstance;
		}
		
		
		//-----------------------------------------------------------------------------------------------------------
		//                                          Override Protected methods
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................prepare..........................................
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			createInstance(scope);
		}
		
		//.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			scope.lastReturn = currentInstance;
		}
	}
}
