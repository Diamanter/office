package com.sigma.socialgame.events
{
	import com.sigma.socialgame.common.logger.LogMessage;
	
	import flash.events.Event;
	
	public class LogEvent extends Event
	{
		public static const Message : String = "lMessage";
		
		private var _message : LogMessage;
		
		public function LogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get message():LogMessage
		{
			return _message;
		}

		public function set message(value:LogMessage):void
		{
			_message = value;
		}
	}
}