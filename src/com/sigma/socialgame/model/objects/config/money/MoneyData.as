package com.sigma.socialgame.model.objects.config.money
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class MoneyData
	{
		private var _amount : AmountData;
		private var _gold : int;
		private var _desc : String;
		private var _id : int;
		
		public function MoneyData()
		{
		}

		public function get amount():AmountData
		{
			return _amount;
		}

		public function set amount(value:AmountData):void
		{
			_amount = value;
		}

		public function get gold():int
		{
			return _gold;
		}

		public function set gold(value:int):void
		{
			_gold = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}


	}
}