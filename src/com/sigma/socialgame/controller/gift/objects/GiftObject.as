package com.sigma.socialgame.controller.gift.objects
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;

	public class GiftObject
	{
		private var _object : ObjectData;
		
		public function GiftObject()
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

	}
}