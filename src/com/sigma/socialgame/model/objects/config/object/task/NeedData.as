package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;

	public class NeedData
	{
		private var _currency : CurrencyData;
		private var _amount : int;
		
		public function NeedData()
		{
		}

		public function get currency():CurrencyData
		{
			return _currency;
		}

		public function set currency(value:CurrencyData):void
		{
			_currency = value;
		}

		public function get amount():int
		{
			return _amount;
		}

		public function set amount(value:int):void
		{
			_amount = value;
		}


	}
}