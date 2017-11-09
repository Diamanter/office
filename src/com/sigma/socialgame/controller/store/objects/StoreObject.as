package com.sigma.socialgame.controller.store.objects
{
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;

	public class StoreObject
	{
		private var _storeObject : StoreObjectData;
		
		public function StoreObject()
		{
		}

		public function get storeObject():StoreObjectData
		{
			return _storeObject;
		}

		public function set storeObject(value:StoreObjectData):void
		{
			_storeObject = value;
		}
		
		public function toString() : String
		{
			return "StoreObject: " + _storeObject.toString();
		}
	}
}