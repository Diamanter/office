package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class MapClientEvent extends Event
	{
		public static const Updated : String = "mcUpdated";
		public static const Removed : String = "mcRemoved";
		
		public function MapClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}