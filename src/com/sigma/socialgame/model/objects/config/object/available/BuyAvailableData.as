package com.sigma.socialgame.model.objects.config.object.available
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.flags.FlagData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class BuyAvailableData extends AvailableData
	{
		private var _prices : Vector.<AmountData>;
		private var _flags : Vector.<FlagData>;
		
		public function BuyAvailableData()
		{
			super();
		}

		public override function toString():String
		{
			return super.toString() + "\nPrice: " + _prices;
		}

		public function get prices():Vector.<AmountData>
		{
			return _prices;
		}

		public function set prices(value:Vector.<AmountData>):void
		{
			_prices = value;
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