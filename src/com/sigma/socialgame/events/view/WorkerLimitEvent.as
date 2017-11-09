package com.sigma.socialgame.events.view
{
	import flash.events.Event;
	
	public class WorkerLimitEvent extends Event
	{
		public static const Inited : String = "Inited";
		
		public function WorkerLimitEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}