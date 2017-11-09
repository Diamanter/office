package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class EntityClientEvent extends Event
	{
		public static const Updated : String = "ecUpdated";
		public static const Removed : String = "ecRemoved";
		
		public function EntityClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}