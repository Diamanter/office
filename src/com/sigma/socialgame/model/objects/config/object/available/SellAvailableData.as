package com.sigma.socialgame.model.objects.config.object.available
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class SellAvailableData extends AvailableData
	{
		private var _prices : Vector.<AmountData>;
		
		public function SellAvailableData()
		{
			super();
		}

		public function get prices():Vector.<AmountData>
		{
			return _prices;
		}

		public function set prices(value:Vector.<AmountData>):void
		{
			_prices = value;
		}

		public override function toString():String
		{
			return super.toString() + "\nPrice: " + _prices.toString();
		}
	}
}