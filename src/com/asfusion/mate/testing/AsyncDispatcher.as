////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.asfusion.mate.testing
{

import flash.events.TimerEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;


/**
 *  This class provides a mechanism for dispatching a method asynchronously.
 */
public class AsyncDispatcher
{
	//--------------------------------------------------------------------------
    // Variables
    //--------------------------------------------------------------------------

    private var method:Function;
    private var args:Array;
    private var timer:Timer;
    
    //--------------------------------------------------------------------------
    // Contructor
    //--------------------------------------------------------------------------
    public function AsyncDispatcher(method:Function, args:Array, delay:Number)
    {
        super();
        this.method = method;
        this.args = args;
        timer = new Timer(delay);
        timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
        timer.start();
    }

    //--------------------------------------------------------------------------
    // Private Methods
    //--------------------------------------------------------------------------

    private function timerEventHandler(event:TimerEvent):void
    {
        timer.stop();
        timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
        // This call may throw so do not put code after it
        method.apply(null, args);
    }


}

}
