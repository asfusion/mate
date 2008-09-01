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
package com.asfusion.mate.actionLists
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	
	/**
	 * This interface defines a basic list of actions.
	 * It contains an array of Actions of type <code>IAction</code> 
	 * that will get called  when the IActionList run.
	 */
	public interface IActionList extends IEventDispatcher, IMXMLObject
	{
		/**
		 * 	An array of  Actions (IAction) contained in this IActionList.
		 * 	The Actions are processed in the order in which they were added.
		 * 
		 *  @default null
		 * */
		function get actions():Array
		function set actions(value:Array):void
		
		/**
		 * Whether to show debugging information for this IActionList. 
		 * If true, Console output will show debugging information as this IActionList runs.
		 * 
		 *  @default false
		 * */
		function get debug():Boolean
		function set debug(value:Boolean):void
		
		/**
		 * Returns the current scope for this IActionList
		 * 
		 *  @default null
		 * */
		function get scope():IScope
		
		/**
		 * A reference to the document object associated with this IActionList.
		 * A document object is an Object at the top of the hierarchy of a Flex 
		 * application, MXML component, or AS component.
		 */
		function getDocument():Object
		
		/**
		 * A method that allows setting the dispatcher
		 * that this IActionList will use to register to events.
		 */
		function setDispatcher(value:IEventDispatcher, local:Boolean = true):void
		
		/**
		 * Validate and update the properties of this object, if necessary.
		 * Processing properties that require substantial computation are normally not processed
		 * until the script finishes executing. 
		 * Delaying the processing prevents it from being repeated multiple times if the script 
		 * sets the value of the property more than once. 
		 * This method lets you manually override this behavior.
		 */
		function validateNow():void
		
		/**
		*  Marks a component so that its <code>commitProperties</code> method gets called during a later screen update.
		* <p>Invalidation is a useful mechanism for eliminating duplicate work by delaying processing of changes to a 
		* component until a later screen update.</p>
		*/
		function invalidateProperties():void
		
		/**
		 * You can pass the parent scope to this IActionList to copy the inherited values.
		 */
		function setInheritedScope(inheritScope:IScope):void
		
		/**
		 * Retuns an error String to be used by the debugger.
		 */
		function errorString():String;
		
		/**
		 * Method to set the group id.
		 * This property associates a group of handlers under the same id
		*/
		function setGroupId(id:int):void
		
		/**
		 * Method to get the group id.
		*/
		function getGroupId():int;
		
		/**
		 * Unregister as a listener and prepare to be garbage collected
		*/
		function clearReferences():void;
	}
}