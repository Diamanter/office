package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;

	public class GiveData
	{
		private var _amount : int;
		private var _currency : CurrencyData;
		
		public function GiveData()
		{
		}

		public function get amount():int
		{
			return _amount;
		}

		public function set amount(value:int):void
		{
			_amount = value;
		}

		public function get currency():CurrencyData
		{
			return _currency;
		}

		public function set currency(value:CurrencyData):void
		{
			_currency = value;
		}


	}
}