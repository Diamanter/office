package com.sigma.socialgame.model.objects.config.graphic
{
	public class ImageData
	{
		private var _name : String;
		private var _skin : SkinData;
		
		public function ImageData()
		{
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(name_:String):void
		{
			_name = name_;
		}
		
		public function get skin():SkinData
		{
			return _skin;
		}
		
		public function set skin(skin_:SkinData):void
		{
			_skin = skin_;
		}
		
		public function toString() : String
		{
			return "Name: " + _name + "\nSkin: " + (_skin == null ? _skin : _skin.toString());
		}
	}
}