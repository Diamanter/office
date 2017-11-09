package com.sigma.socialgame.events.view.gui
{
	import flash.events.Event;
	
	public class StringManagerEvent extends Event
	{
		public static const Loaded : String = "stringmLoaded";
		
		public function StringManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}