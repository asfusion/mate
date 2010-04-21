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
		// ****************************************************************************
		// Constructor
		// ****************************************************************************
		

		public function Binder( soft:Boolean = false, scope:Object = null )
		{
			this.soft 	= soft;
			this._scope = scope;	// logging purposes
		}
		
		// ****************************************************************************
		// Public Methods
		// ****************************************************************************
		
		/**
		 * The function that implements the binding between two objects.
		 */
		public function bind(scope:Object, target:Object, targetKey:String, source:Object, sourceKey:String):Boolean
		{
			var isWatching:Boolean = false;
			
			if (scope != null) _scope = scope;
			
			if(target && targetKey && source && sourceKey)
			{
				var multipleLevels : int    = sourceKey.indexOf(".");
				var chainSourceKey : Object = (multipleLevels > 0) ? sourceKey.split(".") : sourceKey;
				var data           : Object = null;
				
				try
				{
					if( soft )
					{
						var softWacher:SoftChangeWatcher = bindProperty(target, targetKey, source, chainSourceKey);
						if(softWacher.isWatching()) isWatching = true;
					}
					else
					{
						var wacher : ChangeWatcher = BindingUtils.bindProperty(target, targetKey, source, chainSourceKey);
						if(wacher.isWatching()) isWatching = true;
					}
				}
				catch(error:ReferenceError)
				{
					data = {target:target, targetKey:targetKey};
					logError(LogTypes.CANNOT_BIND, error, source, sourceKey, data);
				}
				catch(error:TypeError)
				{
					data = {target:target, targetKey:targetKey, source:source, sourceKey:sourceKey};
					logError(LogTypes.PROPERTY_TYPE_ERROR, error, source, sourceKey, data);
				}
			}
			else if(target && targetKey && source)
			{
				try
				{
					target[targetKey] = source;
					isWatching        = true;
				}
				catch(error:ReferenceError)
				{
					logError(LogTypes.PROPERTY_NOT_FOUND, error, target, targetKey);
				}
				catch(error:TypeError)
				{
					data = {target:target, targetKey:targetKey, source:source};
					logError(LogTypes.PROPERTY_TYPE_ERROR, error, source,null,data);
				}
			}
			else
			{
				if(!targetKey)			logError(LogTypes.TARGET_KEY_UNDEFINED);
				else if(!target)		logError(LogTypes.TARGET_UNDEFINED);
				else if(!source)		logError(LogTypes.SOURCE_UNDEFINED);
			}
			
			if(!isWatching)				logError(LogTypes.NOT_BINDING,null,null,null,{targetKey:targetKey});
			
			return isWatching;
		}
		
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
	            
	            _keepFunctionLive.push( assign );
	        }
	        
	        return w;
	    }
		
		// ****************************************************************************
		// Private Error logging
		// ****************************************************************************
		
	    private function logError(	errorCode	:String, 
	    							error		:Error	=null,
	    							source		:*		=null, 
	    							sourceKey	:String	=null,
	    							data		:Object	=null) : void {
	    	
	    	if (_scope != null) 
			{
				_scope.getLogger().error(errorCode, new LogInfo( _scope, source, error, null, null, sourceKey,data ));
			}
	    }

				protected 	var soft				: Boolean 	= false;
				private     var _scope          	: Object    = null;
		static 	private 	var _keepFunctionLive	: Array 	= new Array();
	}
}