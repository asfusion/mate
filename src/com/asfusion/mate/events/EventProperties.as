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
package com.asfusion.mate.events
{
	/**
	 * You can add properties to your event by using the EventProperties tag
	 * inside the eventProperties attibute in the <code>Dispatcher</code>.
	 * The properties to set in your event must be public.
	 * As attributes of the EventProperties tag, you can specify the names of your 
	 * properties and set the values of those properties by setting the value of those attributes.
	 * 
	 * @example
     * <listing version="3.0">
	 * &lt;mate:Dispatcher generator="{MyEvent}" type="{MyEvent.MY_EVENT_TYPE}"&gt;
	 *        &lt;mate:eventProperties&gt;
	 *              &lt;mate:EventProperties
	 *                    myProperty="myValue"
	 *                    myProperty2="100" /&gt;
	 *        &lt;/mate:eventProperties&gt;
	 * &lt;/mate:Dispatcher&gt;
	 * </listing>
	 */
	public dynamic class EventProperties
	{

	}
}