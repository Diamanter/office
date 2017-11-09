package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class ShopClientEvent extends Event
	{
		public static const Unlocked : String = "scUnlocked";
		public static const CanUnlock : String = "scCanUnlock";
		public static const CannotUnlock : String = "scCannotUnlock";
		
		public static const AmountChanged : String = "scAmountChanged";
		
		public function ShopClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}