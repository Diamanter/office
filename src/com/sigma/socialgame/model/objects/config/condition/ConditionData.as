package com.sigma.socialgame.model.objects.config.condition
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class ConditionData
	{
		private var _id : int;
		
		private var _price : AmountData;
		
		private var _friends : int = 0;
		private var _level : int = 0;
		
		public function ConditionData()
		{
		}

		public function get price():AmountData
		{
			return _price;
		}

		public function set price(value:AmountData):void
		{
			_price = value;
		}

		public function get friends():int
		{
			return _friends;
		}

		public function set friends(value:int):void
		{
			_friends = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function toString() : String
		{
			return "Price: " + _price + "\nFriends: " + _friends + "\nLevel: " + _level;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

	}
}