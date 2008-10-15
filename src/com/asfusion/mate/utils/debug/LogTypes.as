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
package com.asfusion.mate.utils.debug
{
	/**
	 * These are the different types of logs that Mate Framework may show.
	 * Each type has a default message that is displayed if the
	 * <code>Debugger</code> is off.
	 */
	public class LogTypes
	{
		/*-----------------------------------------------------------------------------------------------------------
		*                                      ERROR Types
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Invalid number of arguments
		 */
		public static const ARGUMENT_ERROR:String 		= "Invalid number of arguments";
		
		/**
		 * Argument type mismatch
		 */
		public static const TYPE_ERROR:String 			= "Argument type mismatch";
		
		/**
		 * Property type mismatch
		 */
		public static const PROPERTY_TYPE_ERROR:String 	= "Property type mismatch";
		
		/**
		 * Method not found
		 */
		public static const METHOD_NOT_FOUND:String 	= "Method not found";
		
		/**
		 * Method undefined
		 */
		public static const METHOD_UNDEFINED:String 	= "Method undefined";
		
		/**
		 * Method is not a function
		 */
		public static const NOT_A_FUNCTION:String 		= "Method is not a function";
		
		/**
		 * Generator not found
		 */
		public static const GENERATOR_NOT_FOUND:String 	= "Generator not found";
		
		/**
		 * Event type not found
		 */
		public static const TYPE_NOT_FOUND:String 		= "Event type not found";
		
		/**
		 * Instance is undefined
		 */
		public static const INSTANCE_UNDEFINED:String 	= "Instance undefined";
		
		/**
		 * Property not found
		 */
		public static const PROPERTY_NOT_FOUND:String 	= "Property not found";
		
		/**
		 * Too many arguments in constructor
		 */
		public static const TOO_MANY_ARGUMENTS:String 	= "Too many arguments in constructor";
		
		/**
		 * Not an Event
		 */
		public static const IS_NOT_AN_EVENT:String 		= "Not an Event";
		
		/**
		 * Cannot bind
		 */
		public static const CANNOT_BIND:String 			= "Cannot bind";
		
		/**
		 * TargetKey is undefined
		 */
		public static const TARGET_KEY_UNDEFINED:String = "TargetKey undefined";
		/**
		 * Target is undefined
		 */
		public static const TARGET_UNDEFINED:String 	= "Target undefined";
		/**
		 * Source is undefined
		 */
		public static const SOURCE_UNDEFINED:String 	= "Source undefined";

		/*-----------------------------------------------------------------------------------------------------------
		*                                      INFO Types
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Source as a null value
		 */
		public static const SOURCE_NULL:String 	= "Source null";
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      INFO Types
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Sequence started
		 */
		public static const SEQUENCE_START:String	= "Sequence started";
		
		/**
		 * Sequence ended
		 */
		public static const SEQUENCE_END:String 	= "Sequence ended";
		
		/**
		 * Sequence triggered
		 */
		public static const SEQUENCE_TRIGGER:String = "Sequence triggered";
		
		/**
		 * Not binding
		 */
		public static const NOT_BINDING:String 		= "Not binding";
	}
}