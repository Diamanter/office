package com.sigma.socialgame.model.objects.sync.wallet
{
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	
	public class AmountData
	{
		private var _currency : CurrencyData;
		private var _value : int;
		
		public function AmountData()
		{
		}
		
		public function equals(amount_ : AmountData) : Boolean
		{
			return _currency.equals(amount_.currency) && _value == amount_.amount;
		}
		
		public function get currency():CurrencyData
		{
			return _currency;
		}
		
		public function set currency(curr_:CurrencyData):void
		{
			_currency = curr_;
		}
		
		public function get amount():int
		{
			return _value;
		}
		
		public function set amount(val_:int):void
		{
			_value = val_;
		}
		
		public function toString() : String
		{
			return "Value: " + _value + "\nCurr: " + (_currency == null ? _currency : _currency.toString());
		}
	}
}