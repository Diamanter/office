package com.sigma.socialgame.model.objects.config.object.available
{
	public class AvailableData
	{
		private var _type : String;
		
		public function AvailableData()
		{
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(type_:String):void
		{
			_type = type_;
		}
		
		public function toString() : String
		{
			return "Type: " + _type;
		}
	}
}