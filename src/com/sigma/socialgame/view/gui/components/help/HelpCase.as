package com.sigma.socialgame.view.gui.components.help
{
	public class HelpCase
	{
		private var _title : String;
		private var _message : String;
		private var _image : String;
		
		public function HelpCase(title_ : String, message_ : String, image_ : String)
		{
			_title = title_;
			_message = message_;
			_image = image_;
		}

		public function get title():String
		{
			return _title;
		}

		public function get message():String
		{
			return _message;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}

	}
}