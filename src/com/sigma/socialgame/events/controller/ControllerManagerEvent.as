package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class ControllerManagerEvent extends Event
	{
		public static const ControllersInited : String = "cmControllersInited";
		public static const ControllersStarted : String = "cmControllersStarted";
		public static const ControllersSynced : String = "cmConstrollersSynced";
		public static const ControllersReloaded : String = "cmConstrollersReloaded";
		
		public function ControllerManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}