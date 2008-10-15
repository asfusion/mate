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
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actionLists.Scope;
	import com.asfusion.mate.actions.builders.IBuilder;
	import com.asfusion.mate.core.ISmartObject;
	import com.asfusion.mate.events.MateLogEvent;
	
	import flash.events.Event;
	import flash.utils.*;
	
	import mx.logging.LogEvent;
	import mx.utils.*;
	
	[ExcludeClass]
	public class DebuggerHelper implements IDebuggerHelper
	{
		protected var helperFunctions:Dictionary;
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructors
		-------------------------------------------------------------------------------------------------------------*/
		public function DebuggerHelper()
		{
			createHelperFunctions();
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Public methods
		-------------------------------------------------------------------------------------------------------------*/
		public function getMessage(event:LogEvent):String
		{
			var message:String;
			if(event is  MateLogEvent)
			{
				try
				{
					message = helperFunctions[event.message](event as MateLogEvent);
				}
				catch(e:Error)
				{
					message = "Cannot debug";
				}
			}
			else
			{
				message = event.message;
			}
			return message;
		}
		
		public function getClassName(object:Object, name:String = null):String
	    {
	    	if(!name)
	    	{
	    		name = getQualifiedClassName(object);
	    	}
	        
	        // If there is a package name, strip it off.
	        var index:int = name.indexOf("::");
	        if (index != -1)
	            name = name.substr(index + 2);
	                
	        return name;
	    }
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected methods
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................getDynamicProperties..........................................*/
		protected function getDynamicProperties(obj:Object, scope:Scope):String
		{
			var message:String = '';
			for(var prop:String in obj)
			{
				try
				{
					message += "   " + prop +'="'+ formatValue( obj[prop], scope ) +'"';
				}
				catch(e:Error)
				{
					// do nothing for now
				}
			}
			return message;
		}
		
		/*-.........................................formatValue..........................................*/
		protected function formatValue(value:*, loggerProvider:ILoggerProvider):String
		{
			var stringValue:String;
			var smartValue:*;
			
			if(value is ISmartObject && loggerProvider is IScope)
			{
            	smartValue = ISmartObject(value).getValue( IScope(loggerProvider), true );
            	stringValue =  ( smartValue != null ) ? smartValue.toString() : 'null';
            }
            else if( value is Array )
            {
            	var arr:Array = value as Array;
            	stringValue = "[ ";
            	for each( var item:* in arr )
            	{
            		if( item is ISmartObject && loggerProvider is IScope )
            		{
            			smartValue = ISmartObject(item).getValue( IScope(loggerProvider), true );
            			stringValue += ( smartValue != null ) ? smartValue.toString() : "null";
            		}
            		else
            		{
            			stringValue += ( item != null ) ? item.toString() : "null";
            		}
              				
            		if(item != arr[arr.length-1])
            		{
            				stringValue += ", ";
            		}
            	}
               	stringValue += " ]";
            }
            else
            {
            	stringValue = value.toString();
            }
			return stringValue;
		}
		
		/*-.........................................getAttributes..........................................*/
		protected function getAttributes(target:Object, scope:IScope, omit:Object = null):String
		{
			var attributes:String = "";
			var attribute:String  = "";
			var describe:DescribeTypeCacheRecord = DescribeTypeCache.describeType(target);
	        var description:XML = describe.typeDescription;
	       
	        for each (var prop:XML in description.accessor)
	        {
	        	var tempAttribute:XMLList = prop..@name; 
	        	attribute = tempAttribute[0].toString();	
               if(target[attribute] != null && (!omit || !omit.hasOwnProperty(attribute)) )
               {
               		var formatedValue:String = formatValue(target[attribute] , scope);
               		if(formatedValue != "")
               		{
               			attributes += "   " + attribute + '="'+ formatedValue +'"';
               		}
               }
            }
			return attributes;
		}
		
		/*-.........................................getEventType..........................................*/
	    protected function getEventType(event:Event):String
	    {
	        var eventName:String = '"'+event.type+'"';
	        var eventClass:Class = Class(getDefinitionByName(getQualifiedClassName(event)));
	        var description:XML = flash.utils.describeType(eventClass);
	        for each (var cons:XML in description.constant..@name) 
	        {
                if(eventClass[cons] == event.type) 
                {
                	eventName = '"'+ getClassName(event) + "." + cons+'" (' + event.type+')';
                }
            }
	        return eventName;
	    }
	    
	    /*-.........................................getType..........................................*/
	    protected function getType(target:Object, targetKey:String):String
	    {
	    	if(target == null || targetKey == null)
	    	{
	    		return null;
	    	}
	    	var type:String;
	    	var property:XMLList;
	    	var classType:String;
	    	var describe:DescribeTypeCacheRecord = DescribeTypeCache.describeType(target);
	        var description:XML = describe.typeDescription;
	        
	        property = description.accessor.(@name == targetKey);
	        classType = String(property.@type);
	        if(classType == "")
	        {
	        	property = description.variable.(@name == targetKey);
	        	classType = property.@type;
	        }
	        type = getClassName(null, classType);
	    	return type;
	    }
	    
	    /*-.........................................validateSignature..........................................*/
	    protected function validateSignature(info:LogInfo):void
		{
	    	var describe:DescribeTypeCacheRecord = DescribeTypeCache.describeType(info.instance);
	        var description:XML = describe.typeDescription;
	        var xmlParamters:Array = new Array();
	        var methodName:String;
	        if(info.method != 'constructor')
	        {
		        for each (var prop:XML in description.method)
		        {	
	               if(prop..@name == info.method)
	               {
	               		methodName = "method "+info.method;
	               		for each(var xmlParameter:XML in prop.parameter..@type)
	               		{
	               			xmlParamters.push(xmlParameter);
	               		}
	               }
	            }
        	}
        	else
        	{
        		methodName = info.method ;
        		var constr:XML = description.factory[0].constructor[0];
        		for each(var xmlConstrParameter:XML in constr.parameter..@type)
	            {
	               	xmlParamters.push(xmlConstrParameter);
	             }
        	}
            
            if(info.parameters)
            {
	            for (var i:int = 0; i < info.parameters.length; i++)
	            {
	            	var argumentClass:Class;
	            	var flag:Boolean;

	            	argumentClass = flash.utils.getDefinitionByName(xmlParamters[i]) as Class;
	            	flag = info.parameters[i] is argumentClass;

	            	if(!flag)
	            	{
						var errorString:String = "The argument type in position "+(i+1)+ " provided does not match the signature of the " + methodName;
						errorString += " in class " +   getClassName(info.instance);
						errorString += ". It expects an argument of type " + getClassName(null, xmlParamters[i].toString()) + " but got type " + getClassName(info.parameters[i]);
	            		info.problem = formatError(info,errorString);
	            		info.foundProblem = true;
	            	} 
	            }
            }
		}
		
		/*-.........................................formatError..........................................*/
		protected function formatError(info:LogInfo, errorString:String, method:String = null, parameters:Array = null):String
		{
			method = ( info.method ) ? info.method  : method;
			parameters = ( info.parameters ) ? info.parameters : parameters;
			
			var message:String
            message = "\n---------------------------------------------------------\n";
			message += "- ERROR: "+errorString+" \n"
			
			if(info.loggerProvider is IScope)
			{
				var scope:IScope = IScope(info.loggerProvider);
				if(Object(scope.owner).hasOwnProperty("type"))
				{
					message += "- EVENT TYPE: " + getEventType(scope.event) + " \n";
				}
				if(Object(scope.owner).hasOwnProperty("target"))
				{
					message += "- TARGET: " + getClassName(scope.owner["target"]) + " \n";
				}
				if(info.data && info.data.targetKey)
				{
					message += "- TARGET KEY: " + info.data.targetKey + " \n";
				}
			}
			
			if(info.target)
			{
				message += "- TAG: " + getClassName(info.target) + " \n";
			}
			
			if(info.target is IBuilder && info.instance)
			{
				message += "- GENERATOR: " + getClassName(info.instance) + " \n";
			}
			
			if( info.property)
			{
				message += "- PROPERTY: " + info.property + "\n";
			}
			
			if( method)
			{
				message += "- METHOD: " + method + "\n";
			}
			
			message += "- FILE: " + getClassName(info.loggerProvider.getDocument()) + "\n";
			
					
			if(parameters)
			{
				if(parameters.length == 1)
				{
					message += "- 1 ARGUMENT SUPPLIED: ";
					message +=  formatValue(parameters[0], info.loggerProvider) +"\n";
				}
				else
				{
					message += "- "+ parameters.length +" ARGUMENTS SUPPLIED: ";
					message += formatValue(parameters, info.loggerProvider) +"\n";
				}
				
			}
			else if(method)
			{
				message += "- NO ARGUMENTS SUPPLIED \n";
			}
			if(info.error)
			{
				message += "- STACK TRACE: " + info.error.getStackTrace() + "\n";
			}
			message += "---------------------------------------------------------\n";
			return message;
		}
	    
	    
	    
	    /*-----------------------------------------------------------------------------------------------------------
		*                                          Helper functions
		-------------------------------------------------------------------------------------------------------------*/
	    /*-.........................................createHelperFunctions..........................................*/
		protected function createHelperFunctions():void
		{
			helperFunctions = new Dictionary();
			
			helperFunctions[LogTypes.SEQUENCE_END]		= actionListEnd;
			helperFunctions[LogTypes.SEQUENCE_START]	= actionListStart;
			helperFunctions[LogTypes.SEQUENCE_TRIGGER]	= actionListTrigger;
			
			helperFunctions[LogTypes.ARGUMENT_ERROR] 		= argumentError;
			helperFunctions[LogTypes.TYPE_ERROR] 			= typeError;
			helperFunctions[LogTypes.PROPERTY_TYPE_ERROR]	= propertyTypeError;
			helperFunctions[LogTypes.METHOD_NOT_FOUND] 		= methodNotFound;
			helperFunctions[LogTypes.METHOD_UNDEFINED]		= methodUndefined;
			helperFunctions[LogTypes.NOT_A_FUNCTION] 		= notAFunction;
			helperFunctions[LogTypes.GENERATOR_NOT_FOUND]	= generatorNotFound;
			helperFunctions[LogTypes.INSTANCE_UNDEFINED]	= instanceUndefined;
			helperFunctions[LogTypes.PROPERTY_NOT_FOUND]	= propertyNotFound;
			helperFunctions[LogTypes.TOO_MANY_ARGUMENTS]	= tooManyArguments;
			helperFunctions[LogTypes.IS_NOT_AN_EVENT]		= isNotAndEvent;
			helperFunctions[LogTypes.TYPE_NOT_FOUND]		= typeNotFound;
			helperFunctions[LogTypes.SOURCE_UNDEFINED]		= propertyUndefined;
			helperFunctions[LogTypes.TARGET_KEY_UNDEFINED]	= propertyUndefined;
			helperFunctions[LogTypes.TARGET_UNDEFINED]		= propertyUndefined;
			helperFunctions[LogTypes.SOURCE_NULL]			= sourceNull;
			helperFunctions[LogTypes.CANNOT_BIND]			= cannotBind;
			helperFunctions[LogTypes.NOT_BINDING]			= notBinding;
		}
	    
		/*-.........................................actionListStart..........................................*/
		protected function actionListStart(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];	
			var message:String = event.message;
			if(info.loggerProvider is Scope)
			{
				var scope:Scope = Scope(info.loggerProvider);
				
				message = '';
				message += "<"+getClassName(scope.owner)+" (started) ";
				if(Object(scope.owner).hasOwnProperty('type'))
				{
					message += "   type=" + getEventType(scope.currentEvent);
				}
				message += getAttributes(scope.owner, scope, {actions:true, faultHandlers:true, type:true, MXMLrequest:true, debug:true});
				message += ">";
			}
			return message;
		}
		
		/*-.........................................actionListTrigger..........................................*/
		protected function actionListTrigger(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var message:String = event.message;
			
			if(info.loggerProvider is Scope)
			{
				var scope:Scope = Scope(info.loggerProvider);
				message = '';
				message += "    <"+getClassName(info.target);
				message += getAttributes(info.target, scope, {resultHandlers:true, faultHandlers:true, MXMLrequest:true, properties:true});
				
				if(info.target.hasOwnProperty('properties') && info.target['properties'])
				{
					message += ">\n"
					message += "        <Properties" + getDynamicProperties(info.target['properties'], scope) + "/>\n";
					message += "    </"+getClassName(info.target) + ">";
				}
				else
				{
					message += "/>"
				}
			}
			return message;
		}
		
		/*-.........................................actionListEnd..........................................*/
		protected function actionListEnd(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var message:String = event.message;
			if(info.loggerProvider is Scope)
			{
				var scope:Scope = Scope(info.loggerProvider);
				message = '';
				message += "</"+getClassName(scope.owner)+" (end) ";
				if(Object(scope.owner).hasOwnProperty('type')) message += "   type=" + getEventType(scope.currentEvent);
				if(Object(scope.owner).hasOwnProperty('target')) message += "   target=" + scope.owner["target"];
				message += ">";
			}
			
			return message;
		}
		
		/*-.........................................argumentError..........................................*/
		protected function argumentError(event:MateLogEvent):String
		{
			var message:String = '';
			var info:LogInfo = event.parameters[0];
			if(info.error)
			{
				var index:int;
				
				if(info.method == "constructor")
				{
					index = info.error.message.indexOf(getClassName(info.instance) + '()' ,0);
					message = "Wrong number of arguments supplied when calling the constructor";
				}
				else if(info.method)
				{
					message = 'Wrong number of arguments supplied when calling method '+ info.method;
					index = info.error.message.indexOf(info.method + '()' ,0);
				}
				else
				{
					message = 'Wrong number of arguments supplied when calling method';
				}

				if(index != -1)
				{
					message = formatError(info, message);
					info.foundProblem = true;
				}
			}
			return message;
			
		}
		
		/*-.........................................typeError..........................................*/
		protected function typeError(event:MateLogEvent):String
		{
			var message:String = '';
			var info:LogInfo = event.parameters[0];
			if(info.error && info.instance)
			{
				validateSignature(info);
				if(info.foundProblem)
				{
					message = info.problem;
				}
			}
			else
			{
				var errorString:String = "Argument type mismatch when calling method.";
				message = formatError(info,errorString);
			}
			return message;
		}
		
		/*-.........................................propertyTypeError..........................................*/
		protected function propertyTypeError(event:MateLogEvent):String
		{
			var message:String = event.message;
			var info:LogInfo = event.parameters[0];
			if(info.data)
			{
				var target:Object = info.data.target;
				var targetKey:String = info.data.targetKey;
				var source:Object = info.data.source;
				var sourceKey:String = info.data.sourceKey;
				var type:String = getType(target, targetKey);
				var value:Object;
				if(!sourceKey)
				{
					value = source;
				}
				else
				{
					var multipleLevels:int = sourceKey.indexOf(".");
					if(multipleLevels == -1)
					{
						value = source[sourceKey];
					}
					else
					{
						value = source;
						var properties:Array = sourceKey.split(".");
						for each(var property:String in properties)
						{
							value = value[property];
						}
					}
				}
				if(!target)
				{
					
				}
				var errorString:String = "Unable to set property "+ targetKey + " on ";
				if(target)
				{
					errorString +=  getClassName(target) + " because is not type "+type+
									". Provided value was of type "+getClassName(value);
				}
				else
				{
					errorString += (target) ? getClassName(target) : "a null Object."
				}
							 
				message = formatError(info,errorString);
			}
			return message;
		}
		
		
		/*-.........................................methodNotFound..........................................*/
		protected function methodNotFound(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "Method " + info.method + " not found in class " + getClassName(info.instance);
			var message:String = formatError(info,errorString);
			return message;
		}
		
		/*-.........................................methodUndefined..........................................*/
		protected function methodUndefined(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "Unable to call the service or function because the method is undefined"// + getClassName(info.instance);
			var message:String = formatError(info,errorString);
			
			return message;
		}
		
		/*-.........................................notAFunction..........................................*/
		protected function notAFunction(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "Member " + info.method + " in class " + getClassName(info.instance) + " is not a function";
			var message:String = formatError(info,errorString);
			return message;
		}
		
		/*-.........................................generatorNotFound..........................................*/
		protected function generatorNotFound(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "Generator not found in class " + getClassName(info.target);
			var method:String;
			var parameters:*;
			if(info.target.hasOwnProperty("method") && info.target['method'])
			{
				method = info.target['method'];
			}
			if(info.target.hasOwnProperty("arguments") && info.target['arguments'])
			{
				parameters = info.target['arguments'];
				if(!parameters is Array)
				{
					parameters = [parameters];
				}
			}
			var message:String = formatError(info,errorString, method, parameters);
			return message;
		}
		
		/*-.........................................instanceUndefined..........................................*/
		protected function instanceUndefined(event:MateLogEvent):String
		{
			var message:String = event.message;
			
			return message;
		}
		
		/*-.........................................propertyNotFound..........................................*/
		protected function propertyNotFound(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "Property " + info.property + " not found in class " + getClassName(info.instance);
			var message:String = formatError(info,errorString);
			return message;
		}
		
		/*-.........................................tooManyArguments..........................................*/
		protected function tooManyArguments(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "No way, you are trying to call a constructor with more than 15 parameters. Please do some refactoring :)";
			var message:String = formatError(info,errorString);
			
			return message;
		}
		
		/*-.........................................isNotAndEvent..........................................*/
		protected function isNotAndEvent(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = "Unable to dispatch " + getClassName(info.instance) + " because it is not an Event";
			var message:String = formatError(info,errorString);
			
			return message;
		}
		
		/*-.........................................typeNotFound..........................................*/
		protected function typeNotFound(event:MateLogEvent):String
		{
			var info:LogInfo = event.parameters[0];
			var errorString:String = 'Event type is undefined. Failed when trying to call the default event constructor "Event(type:String, bubbles:Boolean = false, cancelable:Boolean = false)"';
			var message:String = formatError(info,errorString);
			return message;
		}
		
		/*-.........................................sourceUndefined..........................................*/
		protected function propertyUndefined(event:MateLogEvent):String
		{
			var message:String;
			var propertyName:String;
			switch(event.message)
			{
				case LogTypes.SOURCE_UNDEFINED: 	propertyName = "source"; break;
				case LogTypes.TARGET_KEY_UNDEFINED: propertyName = "targetKey"; break;
				case LogTypes.TARGET_UNDEFINED: 	propertyName = "target"; break;
			}
			var info:LogInfo = event.parameters[0];
			var errorString:String = propertyName+" is undefined in tag " +getClassName(info.target);
			message = formatError(info,errorString);
			return message;
		}
		
		/*-.........................................sourceNull..........................................*/
		protected function sourceNull(event:MateLogEvent):String
		{
			var message:String;
			var info:LogInfo = event.parameters[0];
			message = "   Warning: " + info.instance["source"] + " has null value";
			
			return message;
		}
		
		protected function notBinding(event:MateLogEvent):String
		{
			var message:String;
			var info:LogInfo = event.parameters[0];
			var targetKey:String;
			if(info.data)
				targetKey = info.data.targetKey;
				
			message= "- INFO: Data binding will not be able to detect assignments to " + targetKey;
			return message;
		}
		
		/*-.........................................cannotBind..........................................*/
		protected function cannotBind(event:MateLogEvent):String
		{
			var message:String;
			var info:LogInfo = event.parameters[0];
			var errorString:String
			
			var chainSoruceKey:Object = info.property;
			var multipleLevels:int = chainSoruceKey.indexOf(".");
			var target:Object = info.data.target;
			var targetKey:String = info.data.targetKey;
			
			if(multipleLevels > 0)
			{
				chainSoruceKey = chainSoruceKey.split(".");
			}
			
			if(!target.hasOwnProperty(targetKey))
			{
				errorString = "Unable to bind because the property " + targetKey + 
							" was not found in class " + getClassName(target);
			}
			
			else if(chainSoruceKey is String)
			{
				if(!info.target.hasOwnProperty(chainSoruceKey))
				{
					errorString = "Unable to bind because the property " + info.property + 
									" was not found in class " + getClassName(info.instance);
				}
			}
			else
			{
				errorString = 'Unable to bind because one of the properties in the chain "' + 
								info.property + '" was not found in class '+ getClassName(info.instance);
			}
			message = formatError(info,errorString);
			
			return message;
		}
	}
}