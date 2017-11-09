package com.sigma.socialgame.common.logger
{
	public class LogMessage
	{
		private var _message : String;
		private var _level : int;
		private var _sender : String;
		private var _module : int;
		
		public function LogMessage()
		{
		}

		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get sender():String
		{
			return _sender;
		}

		public function set sender(value:String):void
		{
			_sender = value;
		}

		public function get module():int
		{
			return _module;
		}

		public function set module(value:int):void
		{
			_module = value;
		}


	}
}