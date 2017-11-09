package com.sigma.socialgame.model.objects.config.object.skill
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class SkillData
	{
		private var _id : int;
		private var _name : String;
		private var _rank : int;
		
		public function SkillData()
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

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function toString() : String
		{
			return "Id: " + _id + "\nName: " + _name;
		}

		public function get rank():int
		{
			return _rank;
		}

		public function set rank(value:int):void
		{
			_rank = value;
		}

	}
}