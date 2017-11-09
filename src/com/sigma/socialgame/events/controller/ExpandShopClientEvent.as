package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class ExpandShopClientEvent extends Event
	{
		public static const Unlocked : String = "escUnlocked";
		
		public function ExpandShopClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}