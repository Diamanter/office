package com.sigma.socialgame.controller.facade
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.EntityController;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;

	public class MapEntityFacade
	{
		public static function addCellObjectFromStore(storeObject_ : StoreObjectData, x_ : int = 0, y_ : int = 0) : MapObject
		{
			var mod : CellMapObjectData = ResourceManager.instance.addCellObject(storeObject_);
			
			(ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController).addEntityObject(mod);
			return (ControllerManager.instance.getController(ControllerNames.MapController) as MapController).addCellObject(mod, false, x_, y_);
		}
		
		public static function addWallObjectFromStore(storeObject_ : StoreObjectData, wall_ : int = 0, x_ : int = 0) : MapObject
		{
			var mod : WallMapObjectData = ResourceManager.instance.addWallObject(storeObject_);
			
			(ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController).addEntityObject(mod);
			return (ControllerManager.instance.getController(ControllerNames.MapController) as MapController).addWallObject(mod, false, wall_, x_);
		}
		
		public static function removeToStore(storeObject_ : StoreObjectData, server_ : Boolean = false) : void
		{
			var mapC : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			var entC : EntityController = ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController;
			
			var mod : MapObject = mapC.findCellObjectBySOD(storeObject_);
			
			if (mod == null)
			{
				mod = mapC.findWallObjectBySOD(storeObject_);

				if (mod == null)
					return;
				
				ResourceManager.instance.removeWallObject(mod.mapObject);
				mapC.removeWallObject(mod as WallObject);
				entC.removeEntityObjectBySOD(storeObject_);
				
				if (server_)
					ResourceManager.instance.moveToStore(storeObject_.storeId);
			}
			else
			{
				ResourceManager.instance.removeCellObject(mod.mapObject);
				mapC.removeCellObject(mod as CellObject);
				entC.removeEntityObjectBySOD(storeObject_);
				
				if (server_)
					ResourceManager.instance.moveToStore(storeObject_.storeId);
			}

/*			var mod : MapObjectData = (ControllerManager.instance.getController(ControllerNames.MapController) as MapController).removeMapObjectBySOD(storeObject_);
			(ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController).removeEntityObjectBySOD(storeObject_);
			
			if (mod is CellMapObjectData)
				ResourceManager.instance.removeCellObject(mod);
			else if (mod is WallMapObjectData)
				ResourceManager.instance.removeWallObject(mod);
*/		}
	}
}