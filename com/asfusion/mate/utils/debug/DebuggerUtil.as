package com.asfusion.mate.utils.debug
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * DebuggerUtil is a helper class used to build strings describing errors for debugging purposes
	 */
	public class DebuggerUtil
	{
		/**
		 * Returns a string with only the class name and without the full path.
		 */
		public static function getClassName(object:Object):String
	    {
	    	var name:String = getQualifiedClassName(object);
	        
	        // If there is a package name, strip it off.
	        var index:int = name.indexOf("::");
	        if (index != -1)
	            name = name.substr(index + 2);
	                
	        return name;
	    }
	}
}