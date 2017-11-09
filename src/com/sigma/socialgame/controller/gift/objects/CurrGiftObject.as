package com.sigma.socialgame.controller.gift.objects
{
	import com.sigma.socialgame.model.objects.sync.gift.GiftData;

	public class CurrGiftObject
	{
		private var _gift : GiftData;
		
		public function CurrGiftObject()
		{
		}

		public function get gift():GiftData
		{
			return _gift;
		}

		public function set gift(value:GiftData):void
		{
			_gift = value;
		}

	}
}