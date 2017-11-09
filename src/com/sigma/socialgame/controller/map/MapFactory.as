package com.sigma.socialgame.controller.map
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;

	public class MapFactory
	{
		public static const TAG : String = "MapFactory";
		
		public static function ctreateCellObject(obj_ : CellMapObjectData) : CellObject
		{
			if (obj_ == null)
			{
				Logger.message("CellMapObjectData must be non null.", TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			Logger.message("Creating Cell Object.", TAG, LogLevel.Debug, LogModule.Controller);
	
			var newMO : CellObject = new CellObject();
	
			newMO.mapObject = obj_;
	
			var storeCont : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var so : StoreObject = storeCont.findStoreObject(newMO.mapObject.storeObject);
			newMO.storeObject = so;
			
			Logger.message(newMO.toString(), "", LogLevel.Debug, LogModule.Controller);
			
			return newMO;
		}
		
		public static function ctreateWallObject(obj_ : WallMapObjectData) : WallObject
		{
			if (obj_ == null)
			{
				Logger.message("WallMapObjectData must be non null.", TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			Logger.message("Creating Wall Object.", TAG, LogLevel.Debug, LogModule.Controller);
			
			var newMO : WallObject = new WallObject();
			
			newMO.mapObject = obj_;
			
			var storeCont : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var so : StoreObject = storeCont.findStoreObject(newMO.mapObject.storeObject);
			newMO.storeObject = so;
			
			Logger.message(newMO.toString(), "", LogLevel.Debug, LogModule.Controller);
			
			return newMO;
		}
	}
}