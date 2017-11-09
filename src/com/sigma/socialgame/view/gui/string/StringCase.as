package com.sigma.socialgame.view.gui.string
{
	public class StringCase
	{
		private var _title : String;
		private var _message : String;
		private var _imageMessage : String;
		
		public function StringCase(title_ : String, message_ : String, imageMessage_ : String = "")
		{
			_title = title_;
			_message = message_;
			_imageMessage = imageMessage_;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}

		public function get imageMessage():String
		{
			return _imageMessage;
		}

		public function set imageMessage(value:String):void
		{
			_imageMessage = value;
		}


	}
}