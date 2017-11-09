package com.sigma.socialgame.controller.entity
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.objects.EntityObject;
	import com.sigma.socialgame.controller.entity.objects.WorkerEntityObject;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.sync.map.MapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WorkerMapObjectData;

	public class EntityFactory
	{
		public static const TAG : String = "EntityFactory";
		
		public static function createEntityObject(obj_ : MapObjectData) : EntityObject
		{
			if (obj_ == null)
			{
				Logger.message("MapObectData must be non null.", TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var obj : ObjectData = obj_.storeObject.object;
			
			var storeCont : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var so : StoreObject;
			
			switch (obj.type)
			{
				case ObjectTypes.Decor:
				case ObjectTypes.Trim:
				case ObjectTypes.Workspace:
					
					Logger.message("Creating Entity Object.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newEntity : EntityObject = new EntityObject();
					
					newEntity.mapObject = obj_;
					
					so = storeCont.findStoreObject(newEntity.mapObject.storeObject);
					newEntity.storeObject = so;
					
					Logger.message(newEntity.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newEntity;
					
				case ObjectTypes.Worker:
					
					var newWEntity : WorkerEntityObject = new WorkerEntityObject();
					
					newWEntity.mapObject = obj_;

					so = storeCont.findStoreObject(newWEntity.mapObject.storeObject);
					newWEntity.storeObject = so;
					
					newWEntity.currSkill = (newWEntity.mapObject as WorkerMapObjectData).currSkill;
	
					return newWEntity;
			}
			
			return null;
		}
	}
}