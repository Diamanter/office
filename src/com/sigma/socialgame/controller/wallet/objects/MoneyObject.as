package com.sigma.socialgame.controller.wallet.objects
{
	import com.sigma.socialgame.model.objects.config.money.MoneyData;

	public class MoneyObject
	{
		private var _moneyData : MoneyData;
		
		public function MoneyObject()
		{
		}

		public function get moneyData():MoneyData
		{
			return _moneyData;
		}

		public function set moneyData(value:MoneyData):void
		{
			_moneyData = value;
		}

	}
}