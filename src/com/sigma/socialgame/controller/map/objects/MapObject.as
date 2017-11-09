package com.sigma.socialgame.controller.map.objects
{
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.model.objects.sync.map.MapObjectData;

	public class MapObject
	{
		private var _mapObject : MapObjectData;
		private var _storeObject : StoreObject;
		
		public function MapObject()
		{
		}
		
		public function get mapObject() : MapObjectData
		{
			return _mapObject;
		}
		
		public function set mapObject(storeObj_ : MapObjectData) : void
		{
			_mapObject = storeObj_;
		}
		
		public function toString() : String
		{
			return "StoreObject: " + _mapObject.toString(); 
		}

		public function get storeObject():StoreObject
		{
			return _storeObject;
		}

		public function set storeObject(value:StoreObject):void
		{
			_storeObject = value;
		}

	}
}