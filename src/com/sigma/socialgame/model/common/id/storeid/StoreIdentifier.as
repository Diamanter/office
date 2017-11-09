package com.sigma.socialgame.model.common.id.storeid
{
	public class StoreIdentifier
	{
		private var _storeId : int;
		
		public function StoreIdentifier()
		{
		}
		
		public function equals(storeId_:StoreIdentifier):Boolean
		{
			return _storeId == storeId_.storeId;
		}
		
		public function clone() : StoreIdentifier
		{
			var newMapId : StoreIdentifier = new StoreIdentifier();
			
			newMapId.storeId = _storeId;
			
			return newMapId;
		}
		
		public function get storeId() : int
		{
			return _storeId;
		}
		
		public function set storeId(mapId_ : int) : void
		{
			_storeId = mapId_;
		}
		
		public function toString() : String
		{
			return "Id: " + _storeId;
		}
	}
}