package com.sigma.socialgame.controller.wallet.objects
{
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class WalletObject
	{
		private var _amountData : AmountData;
		
		public function WalletObject()
		{
		}

		public function get amountData():AmountData
		{
			return _amountData;
		}

		public function set amountData(value:AmountData):void
		{
			_amountData = value;
		}

		public function toString() : String
		{
			return "Amout: " + _amountData.toString();
		}
	}
}