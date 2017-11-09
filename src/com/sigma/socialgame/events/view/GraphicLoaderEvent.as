package com.sigma.socialgame.events.view
{
	import starling.events.Event;
	
	public class GraphicLoaderEvent extends Event
	{
		public static const Loaded : String = "glLoaded";
		
		public function GraphicLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}