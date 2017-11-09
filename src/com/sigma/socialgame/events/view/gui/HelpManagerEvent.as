package com.sigma.socialgame.events.view.gui
{
	import flash.events.Event;
	
	public class HelpManagerEvent extends Event
	{
		public static const Inited : String = "helpMInited";
		
		public function HelpManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}