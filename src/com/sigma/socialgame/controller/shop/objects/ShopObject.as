package com.sigma.socialgame.controller.shop.objects
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.BuyAvailableData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class ShopObject
	{
		private var _object : ObjectData;
		
		public function ShopObject()
		{
		}

		public function get object():ObjectData
		{
			return _object;
		}

		public function set object(value:ObjectData):void
		{
			_object = value;
		}

		public function get prices() : Vector.<AmountData>
		{
			for each (var avail : AvailableData in object.available)
			{
				if (avail.type == AvailableTypes.Buy)
				{
					return (avail as BuyAvailableData).prices;
				}
			}
			
			return null;
		}
		
		public function toString() : String
		{
			return "Object: " + _object.toString();
		}
	}
}