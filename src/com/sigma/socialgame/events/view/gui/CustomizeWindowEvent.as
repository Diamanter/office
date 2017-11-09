package com.sigma.socialgame.events.view.gui
{
	import flash.events.Event;
	
	public class CustomizeWindowEvent extends Event
	{
		public static const SetSex : String = "cwSetSex";
		
		private var _sex : String;
		
		public function CustomizeWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get sex():String
		{
			return _sex;
		}

		public function set sex(value:String):void
		{
			_sex = value;
		}

	}
}