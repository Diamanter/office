package com.sigma.socialgame.model.objects.config.convert
{
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class ConvertData
	{
		private var _fromCurr : AmountData;
		private var _toCurr : AmountData;
		
		private var _id : int;
		
		public function ConvertData()
		{
		}

		public function get fromCurr():AmountData
		{
			return _fromCurr;
		}

		public function set fromCurr(value:AmountData):void
		{
			_fromCurr = value;
		}

		public function get toCurr():AmountData
		{
			return _toCurr;
		}

		public function set toCurr(value:AmountData):void
		{
			_toCurr = value;
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