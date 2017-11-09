package com.sigma.socialgame.view.game.map
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.EntityController;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.object.CellObjectData;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.WallObjectData;
	import com.sigma.socialgame.view.game.map.objects.CellEntity;
	import com.sigma.socialgame.view.game.map.objects.DecorCellEntity;
	import com.sigma.socialgame.view.game.map.objects.DecorWallEntity;
	import com.sigma.socialgame.view.game.map.objects.TrimCellEntity;
	import com.sigma.socialgame.view.game.map.objects.TrimWallEntity;
	import com.sigma.socialgame.view.game.map.objects.WallEntity;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;
	import com.sigma.socialgame.view.game.map.objects.WorkspaceEntity;

	public class MapFactory
	{
		public static const TAG : String = "MapFactory";
		
		public static function createCellEntity(cellObj_ : CellObject) : CellEntity
		{
			var newCellEnt : CellEntity;
			
			var obj : CellObjectData = cellObj_.mapObject.storeObject.object as CellObjectData;

			if (obj == null)
			{
				return null;
			}
			
			var mapCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			var entCon : EntityController = ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController;
			
			switch (obj.type)
			{
				case ObjectTypes.Decor:
					
					Logger.message("Creating cell decor game entity.", TAG, LogLevel.Debug, LogModule.View);
					
					newCellEnt = new DecorCellEntity();
					
					newCellEnt.mapClient = mapCon.getCellClient(cellObj_);
					newCellEnt.entityClient = entCon.getClientByStoreId(cellObj_.mapObject.storeObject.storeId);
					
					Logger.message(newCellEnt.toString(), "", LogLevel.Debug, LogModule.View);
					
					return newCellEnt;
					
				break;
				
				case ObjectTypes.Trim:
					
					Logger.message("Creting trim game entity.", TAG, LogLevel.Debug, LogModule.View);
					
					newCellEnt = new TrimCellEntity();
					
					newCellEnt.mapClient = mapCon.getCellClient(cellObj_);
					newCellEnt.entityClient = entCon.getClientByStoreId(cellObj_.mapObject.storeObject.storeId);
					
					Logger.message(newCellEnt.toString(), "", LogLevel.Debug, LogModule.View);
					
					return newCellEnt;
					
					break;
				
				case ObjectTypes.Workspace:
					
					Logger.message("Creting workspace game entity.", TAG, LogLevel.Debug, LogModule.View);
					
					newCellEnt = new WorkspaceEntity();
					
					newCellEnt.mapClient = mapCon.getCellClient(cellObj_);
					newCellEnt.entityClient = entCon.getClientByStoreId(cellObj_.mapObject.storeObject.storeId);
					
					Logger.message(newCellEnt.toString(), "", LogLevel.Debug, LogModule.View);
					
					return newCellEnt;
					
					break;
				
				case ObjectTypes.Worker:
					
					Logger.message("Creting worker game entity.", TAG, LogLevel.Debug, LogModule.View);
					
					newCellEnt = new WorkerEntity();
					
					newCellEnt.mapClient = mapCon.getCellClient(cellObj_);
					newCellEnt.entityClient = entCon.getClientByStoreId(cellObj_.mapObject.storeObject.storeId);
					
					Logger.message(newCellEnt.toString(), "", LogLevel.Debug, LogModule.View);
					
					return newCellEnt;
					
					break;
			}
			
			Logger.message("Unknown object type: " + obj.type, TAG, LogLevel.Error, LogModule.View);
			
			return newCellEnt;
		}
		
		public static function createWallEntity(wallObj_ : WallObject) : WallEntity
		{
			var newWallEnt : WallEntity;
			
			var obj : WallObjectData = wallObj_.mapObject.storeObject.object as WallObjectData;
			
			var mapCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			var entCon : EntityController = ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController;
			
			switch (obj.type)
			{
				case ObjectTypes.Decor:
					
					Logger.message("Creating wall decor game entity.", TAG, LogLevel.Debug, LogModule.View);
					
					newWallEnt = new DecorWallEntity();
					
					newWallEnt.mapClient = mapCon.getWallClient(wallObj_);
					newWallEnt.entityClient = entCon.getClientByStoreId(wallObj_.mapObject.storeObject.storeId);
					
					Logger.message(newWallEnt.toString(), "", LogLevel.Debug, LogModule.View);
					
					return newWallEnt;
					
					break;
				
				case ObjectTypes.Trim:
					
					Logger.message("Creating trim game entity.", TAG, LogLevel.Debug, LogModule.View);
					
					newWallEnt = new TrimWallEntity();
					
					newWallEnt.mapClient = mapCon.getWallClient(wallObj_);
					newWallEnt.entityClient = entCon.getClientByStoreId(wallObj_.mapObject.storeObject.storeId);
					
					Logger.message(newWallEnt.toString(), "", LogLevel.Debug, LogModule.View);
					
					return newWallEnt;
					
					break;
			}
			
			Logger.message("Unknown object type: " + obj.type, TAG, LogLevel.Error, LogModule.View);
			
			return newWallEnt;
		}
	}
}