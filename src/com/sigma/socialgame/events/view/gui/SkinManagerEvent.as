package com.sigma.socialgame.events.view.gui
{
	import flash.events.Event;
	
	public class SkinManagerEvent extends Event
	{
		public static const SkinsLoaded : String = "smSkinsLoaded";
		
		public function SkinManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}