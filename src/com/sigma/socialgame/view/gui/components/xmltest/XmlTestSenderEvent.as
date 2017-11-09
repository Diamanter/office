package com.sigma.socialgame.view.gui.components.xmltest
{
	import flash.events.Event;
	
	public class XmlTestSenderEvent extends Event
	{
		public static const Packet : String = "Packet";
		
		private var _text : String;
		
		public function XmlTestSenderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

	}
}