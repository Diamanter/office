package com.sigma.socialgame.events.view
{
	import starling.events.Event;
	
	public class FieldEvent extends Event
	{
		public static const MouseModeChanged : String = "fMouseModeChanged";
		
		public function FieldEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}