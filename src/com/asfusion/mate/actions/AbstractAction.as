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
package com.asfusion.mate.actions
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.actionLists.IScope;
	
	import mx.core.IMXMLObject;
	/**
	 * AbstractAction is a base class for all classes implementing <code>IAction</code>.
	 */
	public class AbstractAction implements IMXMLObject
	{
		
		/**
		 *  The <code>currentInstance</code> is the Object that this class will
		 *  use and modify to do its work. The type of this object depends on the
		 *  child implementations.
		 *  <p>Usually, this <code>currentInstance</code> is set or created
		 *  in the prepare method, but it is not mandatory.</p>
		 * 
		 *  @default null
		*/
	    protected var currentInstance:* = null;

	  
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Implementation of IAction interface
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................trigger..........................................*/
		/**
		 * This method gets called when the IActionList (ex: EventHandlers) is running.
		 * This method is called on each IAction that the IActionList contains in its 
		 * <code>listeners</code> array.
		 * <p>It is recomended that you do not override this method unless needed.
		 * Instead, override the four methods that
		 * this method calls (prepare, setProperties, run or complete).</p>
		 * .
		*/
		public function trigger(scope:IScope):void
		{
			prepare(scope);
			setProperties(scope);
			run(scope);
			complete(scope);
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................prepare..........................................*/
		/**
		 * The first method that <code>trigger</code> calls.
		 * Usually, this is where the <code>currentInstance</code> is created or set if needed. 
		 * In this method you can also perform any code that must be done first.
		 */
		protected function prepare(scope:IScope):void
		{
			// this method is abstract it will be implemented by children
		}
		
		
		/*-.........................................setProperties..........................................*/
		/**
		 * Where all the properties are set into the <code>currentInstance</code>.
		 * At this time, the <code>currentInstance</code> is already intantiated and ready to be set.
		 */
		protected function setProperties(scope:IScope):void
		{
			if(currentInstance is IScopeReceiver)
			{
				IScopeReceiver(currentInstance).scope = scope;
			}
			if(currentInstance is IDataReceiver)
			{
				IDataReceiver(currentInstance).data = scope.data;
			}
			if(currentInstance is IEventReceiver)
			{
				IEventReceiver(currentInstance).event = scope.event;
			}
			
		}
		
		/*-.........................................run..........................................*/
		/**
		 * Where all the action occurs. At this moment, the <code>currentInstance</code>
		 * is already instantiated and all the properties are already set.
		 */
		protected function run(scope:IScope):void
		{
			// this method is abstract it will be implemented by children
		}
		
		/*-.........................................complete..........................................*/
		/**
		 * The last method that <code>trigger</code> calls.
		 * This is your last chance to perform any action before the IActionList calls the next
		 * IAction in the list.
		 */
		protected function complete(scope:IScope):void
		{
			currentInstance = null;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                      Implementation of IMXMLObject interface
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * A reference to the document object associated with the IActionList that contains this action item.
		 * A document object is an Object at the top of the hierarchy of a Flex application, MXML component, or AS component.
		 */
		protected var document:Object;
		/*-.........................................initialized..........................................*/
		/**
		 * Called automatically by the MXML compiler if the AbstractAction is set up by using a tag.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document;
		}
	}
}