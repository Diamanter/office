package com.sigma.socialgame.model.objects.sync.store
{
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	
	public class StoreObjectData
	{
		private var _object : ObjectData;
		
		private var _storeId : StoreIdentifier;
		
		private var _back : StoreIdentifier;
		
		public function StoreObjectData()
		{
		}
		
		public function get object():ObjectData
		{
			return _object;
		}
		
		public function set object(objId_:ObjectData):void
		{
			_object = objId_;
		}
		
		public function get storeId():StoreIdentifier
		{
			return _storeId;
		}
		
		public function set storeId(storeId_:StoreIdentifier):void
		{
			_storeId = storeId_;
		}
		
		public function toString() : String
		{
			return "ObjId: " + _object.toString() + "\nStoreId: " + _storeId;
		}

		public function get backId():StoreIdentifier
		{
			return _back;
		}

		public function set backId(value:StoreIdentifier):void
		{
			_back = value;
		}

	}
}