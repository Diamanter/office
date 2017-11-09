package com.sigma.socialgame.model.objects.sync.map
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	
	public class MapObjectData
	{
		private var _storeObject : StoreObjectData;
		
		public function MapObjectData()
		{
		}
		
		public function get storeObject():StoreObjectData
		{
			return _storeObject;
		}
		
		public function set storeObject(storeId_:StoreObjectData):void
		{
			_storeObject = storeId_;
		}
		
		public function toString() : String
		{
			return "StoreObject: " + _storeObject.toString();
		}
	}
}