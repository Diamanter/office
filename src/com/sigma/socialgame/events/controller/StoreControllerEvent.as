package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.store.objects.StoreObject;

	public class StoreControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "sconInited";
		public static const Started : String = "sconStarted";
		public static const Synced : String = "sconSynced";
		
		public static const StoreObjectAdded : String = "sconStoreObjectAdded";
		public static const StoreObjectRemoved : String = "sconStoreObjectRemoved";
		public static const StoreObjectChanged : String = "sconStoreObjectChanged";
		
		private var _storeObject : StoreObject;
		
		public function StoreControllerEvent(type:String)
		{
			super(type, ControllerNames.StoreController);
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