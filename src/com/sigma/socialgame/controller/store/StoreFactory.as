package com.sigma.socialgame.controller.store
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;

	public class StoreFactory
	{
		public static const TAG : String = "StoreFactory";
		
		public static function createStoreObject(thing : StoreObjectData) : StoreObject
		{
			Logger.message("Creating store object.", TAG, LogLevel.Debug, LogModule.Controller);
			
			var newSO : StoreObject = new StoreObject();
			
			newSO.storeObject = thing;
			
			Logger.message(newSO.toString(), "", LogLevel.Debug, LogModule.Controller);
			
			return newSO;
		}
	}
}