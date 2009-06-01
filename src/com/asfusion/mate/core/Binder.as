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
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.utils.binding.SoftChangeWatcher;
	import com.asfusion.mate.utils.debug.LogInfo;
	import com.asfusion.mate.utils.debug.LogTypes;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * Binder is a helper class used to bind properties of two objects
	 *
	 */
	public class Binder
	{
		protected var soft:Boolean;
		public function Binder( soft:Boolean = false )
		{
			this.soft = soft;
		}
		
		
		/**
		 * The function that implements the binding between two objects.
		 */
		public function bind(scope:IScope,target:Object, targetKey:String, source:Object, sourceKey:String):Boolean
		{
			var isWatching:Boolean;
			var logInfo:LogInfo;
			if(target && targetKey && source && sourceKey)
			{
				var chainSourceKey:Object = sourceKey;
				var multipleLevels:int = chainSourceKey.indexOf(".");
				if(multipleLevels > 0)
				{
					chainSourceKey = sourceKey.split(".");
				}
				try
				{
					if( soft )
					{
						var softWacher:SoftChangeWatcher = bindProperty(target, targetKey, source, chainSourceKey);
						if(softWacher.isWatching()) isWatching = true;
					}
					else
					{
						var wacher:ChangeWatcher = BindingUtils.bindProperty(target, targetKey, source, chainSourceKey);
						if(wacher.isWatching()) isWatching = true;
					}
				}
				catch(error:ReferenceError)
				{
					logInfo = new LogInfo( scope, source, error, null, null,sourceKey );
					logInfo.data = {target:target, targetKey:targetKey};
					scope.getLogger().error(LogTypes.CANNOT_BIND, logInfo);
					isWatching = false;
				}
				catch(error:TypeError)
				{
					logInfo = new LogInfo( scope, source, error,null, null,sourceKey );
					logInfo.data = {target:target, targetKey:targetKey, source:source, sourceKey:sourceKey};
					scope.getLogger().error(LogTypes.PROPERTY_TYPE_ERROR, logInfo);
					isWatching = false;
				}
			}
			else if(target && targetKey && source)
			{
				try
				{
					target[targetKey] = source;
				}
				catch(error:ReferenceError)
				{
					logInfo = new LogInfo( scope, target, error, null, null,targetKey );
					scope.getLogger().error(LogTypes.PROPERTY_NOT_FOUND, logInfo);
					isWatching = false;
				}
				catch(error:TypeError)
				{
					logInfo = new LogInfo( scope, source, error);
					logInfo.data = {target:target, targetKey:targetKey, source:source};
					scope.getLogger().error(LogTypes.PROPERTY_TYPE_ERROR, logInfo);
					isWatching = false;
				}
			}
			else
			{
				isWatching = false;
				if(!targetKey)
				{
					logInfo = new LogInfo( scope);
					scope.getLogger().error(LogTypes.TARGET_KEY_UNDEFINED, logInfo);
				}
				else if(!target)
				{
					logInfo = new LogInfo( scope);
					scope.getLogger().error(LogTypes.TARGET_UNDEFINED, logInfo);
				}
				else if(!source)
				{
					logInfo = new LogInfo( scope);
					scope.getLogger().error(LogTypes.SOURCE_UNDEFINED, logInfo);
				}
			}
			if(!isWatching)
			{
				logInfo = new LogInfo( scope);
				logInfo.data = {targetKey:targetKey};
				scope.getLogger().info(LogTypes.NOT_BINDING, logInfo);
			}
			return isWatching;
		}
		
		private static var keepFunctionLive:Array = new Array();
		
		public static function bindProperty( site:Object, prop:String,  host:Object, chain:Object, commitOnly:Boolean = false):SoftChangeWatcher
		{
	        var w:SoftChangeWatcher =  SoftChangeWatcher.watch(host, chain, null, commitOnly);
	        
	        if (w != null)
	        {
	            var assign:Function = function(event:*):void
	            {
	                site[prop] = w.getValue();
	            };
	            w.setHandler(assign);
	            assign(null);
	            
	            keepFunctionLive.push( assign );
	        }
	        
	        return w;
	    }
	}
}