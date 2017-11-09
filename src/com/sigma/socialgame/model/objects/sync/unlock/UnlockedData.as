package com.sigma.socialgame.model.objects.sync.unlock
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;

	public class UnlockedData
	{
		private var _type : String;
		
		public function UnlockedData(type_ : String)
		{
			_type = type_;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function toString() : String
		{
			return "Type: " + _type;
		}
	}
}