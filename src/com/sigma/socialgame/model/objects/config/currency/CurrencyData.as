package com.sigma.socialgame.model.objects.config.currency
{
	public class CurrencyData
	{
		private var _type : String;
		private var _spendable : Boolean;
		
		public function CurrencyData()
		{
		}
		
		public function equals(curr_ : CurrencyData) : Boolean
		{
			return _type == curr_.type && _spendable == curr_.spendable;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(type_:String):void
		{
			_type = type_;
		}

		public function get spendable():Boolean
		{
			return _spendable;
		}

		public function set spendable(value:Boolean):void
		{
			_spendable = value;
		}

		public function toString() : String
		{
			return "Type: " + _type + "\nSpendable: " + _spendable;
		}
	}
}