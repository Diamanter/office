package com.sigma.socialgame.model.graphic
{
	import flash.display.Loader;

	public class SWFLib
	{
		private var _loader : Loader;
		private var _url : String;
		
		public function SWFLib()
		{
		}

		public function get loader():Loader
		{
			return _loader;
		}

		public function set loader(value:Loader):void
		{
			_loader = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


	}
}