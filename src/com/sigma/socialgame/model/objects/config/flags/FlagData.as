package com.sigma.socialgame.model.objects.config.flags
{
	public class FlagData
	{
		private var _type : String;
		
		public function FlagData()
		{
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}
