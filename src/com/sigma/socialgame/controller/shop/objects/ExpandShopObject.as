package com.sigma.socialgame.controller.shop.objects
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.expand.ExpandData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class ExpandShopObject
	{
		private var _expandObject : ExpandData;
		
		public function ExpandShopObject()
		{
		}

		public function get condition() : ConditionData
		{
			return _expandObject.condition;
		}
		
		public function get prices() : Vector.<AmountData>
		{
			return _expandObject.prices;
		}
		
		public function get expandObject():ExpandData
		{
			return _expandObject;
		}

		public function set expandObject(value:ExpandData):void
		{
			_expandObject = value;
		}

	}
}