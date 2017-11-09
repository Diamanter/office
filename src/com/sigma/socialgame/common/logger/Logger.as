package com.sigma.socialgame.common.logger
{
	import com.sigma.socialgame.events.LogEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Logger
	{
		private static var _eventDisp : EventDispatcher;
		
		private static var _messages : Vector.<LogMessage>;
		
		private static var _logging : Boolean = true;
		private static var _doTrace : Boolean = true;
		private static var _priority : int = LogLevel.Debug;
		
		protected static const _levels : Array = ["Debug", "Info", "Warning", "Error", "Fatal"];
	
		public static function message(message_ : String, sender_ : String, level_ : int, module_ : int = 3) : void
		{
			if (!_logging)
				return;
			
			if (level_ >= _priority)
			{
				var newMess : LogMessage = new LogMessage();
				
				newMess.message = message_;
				newMess.level = level_;
				newMess.sender = sender_;
				newMess.module = module_;
				
				messages.push(newMess);
			
				if (doTrace)
					traceMessage(newMess);
			
				dispatchEvent(newMess);
			}
		}

		protected static function traceMessage(message_ : LogMessage) : void
		{
			trace(_levels[message_.level] + ": " + message_.sender + ": " + message_.message);
		}
		
		protected static function dispatchEvent(message_ : LogMessage) : void
		{
			var lEvent : LogEvent = new LogEvent(LogEvent.Message);
			lEvent.message = message_;
			eventDisp.dispatchEvent(lEvent);
		}
		
		public static function get doTrace():Boolean
		{
			return _doTrace;
		}

		public static function set doTrace(value:Boolean):void
		{
			_doTrace = value;
		}

		public static function get logging() : Boolean
		{
			return _logging;
		}
		
		public static function set logging(logg_ : Boolean) : void
		{
			_logging = logg_;
		}
		
		public static function get priority():int
		{
			return _priority;
		}

		public static function set priority(value:int):void
		{
			_priority = value;
		}

		public static function addEventListener(type : String, listener : Function) : void
		{
			eventDisp.addEventListener(type, listener);
		}

		protected static function get eventDisp():EventDispatcher
		{
			if (_eventDisp == null)
				_eventDisp = new EventDispatcher();
			
			return _eventDisp;
		}

		protected static function get messages():Vector.<LogMessage>
		{
			if (_messages == null)
				_messages = new Vector.<LogMessage>();
			
			return _messages;
		}
	}
}