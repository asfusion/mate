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
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.actionLists.IScope;

	/**
	 * The DataSaver tag allows you to save values into some object. A possible storage is the "data" object available while the <code>IActionList</code> is running.
	 * <p>The DataSaver tags is a handy tag to quickly save values into some storage. 
	 * You can use the <code>IActionList</code> "data" as a temporary storage from where action that follow in the <code>IActionList</code> can read values. 
	 * You can also use some other external variable as the storage.</p>
	 */
	public class DataCopier extends AbstractAction implements IAction
	{
		/*-.........................................destinationKey..........................................*/
		private var _destinationKey:String;
		/**
		*  If you want to set the value of a property of the destination object, instead of the destination itself, you need to specify this attribute.
		*/
		public function get destinationKey():String
		{
			return _destinationKey;
		}
		public function set destinationKey(value:String):void
		{
			_destinationKey = value;
		}
		
		
		/*-.........................................sourceKey..........................................*/
		private var _sourceKey:String;
		/**
		*  If you need a property from the source instead of the source itself, you need to specify this attribute.
		*/
		public function get sourceKey():String
		{
			return _sourceKey;
		}
		public function set sourceKey(value:String):void
		{
			_sourceKey = value;
		}
		
		
		/*-.........................................destination..........................................*/
		private var _destination:Object;
		/**
		*  The destination attribute specifies where to store the data coming from the source. It can be one of this options:
		 * event, data, result, or another object.
		*/
		public function get destination():Object
		{
			return _destination;
		}
		
		[Inspectable(enumeration="event,data,result")]
		public function set destination(value:Object):void
		{
			_destination = value;
		}
		
		
		/*-.........................................source..........................................*/
		private var _source:Object;
		/**
		*  The source attribute specifies where to get the data to copy from. It can be one of this options:
		 * event, data, result, fault, lastReturn, message, scope, or another object.
		*/
		public function get source():Object
		{
			return _source;
		}
		
		[Inspectable(enumeration="event,data,result,fault,lastReturn,message,scope")]
		public function set source(value:Object):void
		{
			_source = value;
		}
		
		
		/*-.........................................run..........................................*/
		/**
		 * @inheritDoc
		 */ 
		override protected function run(scope:IScope):void
		{
			var realSource:* 		= getRealObject(source, scope);
			var realDestination:* 	= getRealObject(destination, scope);
			
			if(realSource)
			{
				try
				{
					if(destinationKey)
					{
						realDestination[destinationKey] = (sourceKey) ? realSource[sourceKey] : realSource;
					}
					else
					{
						realDestination = (sourceKey) ? realSource[sourceKey] : realSource;
					}
				}
				catch(error:Error)
				{
					trace('getProperty error @todo' + error);
				}
			}
		
			scope.lastReturn = null;
		}
		
		/*-.........................................getRealObject..........................................*/
		/**
		*  Helper function to get the source or destination objects
		 * from either a String value, a SmartObject or other.
		*/
		protected function getRealObject(obj:*, scope:IScope):*
		{
			var realObject:* = obj;
			if(obj is Function ) obj = obj();
			
			if(obj is ISmartObject)
			{
				realObject = ISmartObject(obj).getValue(scope);
			}
			else if(obj is String)
			{
				realObject = scope[obj];
			}

			return realObject;
		}
	}
}