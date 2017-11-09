package com.sigma.socialgame.events.sound
{
	import flash.events.Event;
	
	public class SoundFactoryEvent extends Event
	{
		public static const SoundLoaded : String = "sfSoundsLoaded";
		
		public function SoundFactoryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}