package com.sigma.socialgame.model.objects.config.graphic
{
	public class SkinData
	{
		private var _id : String;
		private var _url : String;
		
		public function SkinData()
		{
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(id_:String):void
		{
			_id = id_;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(url_:String):void
		{
			_url = url_;
		}
		
		public function toString() : String
		{
			return "Id: " + _id + "\nUrl: " + _url;
		}
	}
}