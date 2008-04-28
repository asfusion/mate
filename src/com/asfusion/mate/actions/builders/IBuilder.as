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
	/**
	 * IBuilder is an interface that it is implemented by all the classes that
	 * create objects via a generator.
	 */
	public interface IBuilder
	{
		/**
		*  The generator attribute specifies what class should be instantiated.
		* 
		*  @default null
		*/
		function get generator():Class;
		function set generator(value:Class):void
	}
}