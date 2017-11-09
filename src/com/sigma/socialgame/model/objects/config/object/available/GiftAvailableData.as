package com.sigma.socialgame.model.objects.config.object.available
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.flags.FlagData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class GiftAvailableData extends AvailableData
	{
		private var _condition : ConditionData;
		
		private var _price : AmountData;
		
		private var _flags : Vector.<FlagData>;
		
		public function GiftAvailableData()
		{
			super();
		}

		public function get condition():ConditionData
		{
			return _condition;
		}

		public function set condition(value:ConditionData):void
		{
			_condition = value;
		}

		public function get price():AmountData
		{
			return _price;
		}

		public function set price(value:AmountData):void
		{
			_price = value;
		}

		public function get flags():Vector.<FlagData>
		{
			return _flags;
		}

		public function set flags(value:Vector.<FlagData>):void
		{
			_flags = value;
		}


	}
}
