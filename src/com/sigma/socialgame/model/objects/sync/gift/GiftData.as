package com.sigma.socialgame.model.objects.sync.gift
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;

	public class GiftData
	{
		private var _id : int;
		private var _obejct : ObjectData;
		private var _time : Date;
		
		public function GiftData()
		{
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get obejct():ObjectData
		{
			return _obejct;
		}

		public function set obejct(value:ObjectData):void
		{
			_obejct = value;
		}

		public function get time():Date
		{
			return _time;
		}

		public function set time(value:Date):void
		{
			_time = value;
		}


	}
}