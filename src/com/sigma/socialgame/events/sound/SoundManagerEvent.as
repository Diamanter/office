package com.sigma.socialgame.events.sound
{
	import flash.events.Event;
	
	public class SoundManagerEvent extends Event
	{
		public static const SoundManagerInited : String = "smSoundManagerInited";
		
		public function SoundManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}