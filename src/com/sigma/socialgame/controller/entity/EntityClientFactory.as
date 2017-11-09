package com.sigma.socialgame.controller.entity
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.entity.clients.DecorEntityClient;
	import com.sigma.socialgame.controller.entity.clients.EntityClient;
	import com.sigma.socialgame.controller.entity.clients.TrimEntityClient;
	import com.sigma.socialgame.controller.entity.clients.WorkerEntityClient;
	import com.sigma.socialgame.controller.entity.clients.WorkspaceEntityClient;
	import com.sigma.socialgame.controller.entity.objects.EntityObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;

	public class EntityClientFactory
	{
		public static const TAG : String = "EntityClientFactory";
		
		public static function createClient(entObj_ : EntityObject) : EntityClient
		{
			if (entObj_ == null)
			{
				Logger.message("EntityObject must be non null", TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var type : String = entObj_.mapObject.storeObject.object.type;
			
			switch (type)
			{
				case ObjectTypes.Decor:
					
					Logger.message("Creating decor entity client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newClient : DecorEntityClient = new DecorEntityClient();
					
					newClient.entityObj = entObj_;
					
					Logger.message(newClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newClient;
					
				break;
				
				case ObjectTypes.Workspace:
					
					Logger.message("Creating workspace entity client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newWClient : WorkspaceEntityClient = new WorkspaceEntityClient();
					
					newWClient.entityObj = entObj_;
					
					Logger.message(newWClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newWClient;
					
				break;
				
				case ObjectTypes.Trim:
					
					Logger.message("Creating trim entity client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newTClient : TrimEntityClient = new TrimEntityClient();
					
					newTClient.entityObj = entObj_;
					
					Logger.message(newTClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newTClient;
					
				break;
				
				case ObjectTypes.Worker:
					
					Logger.message("Creating worker entity client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newWRClient : WorkerEntityClient = new WorkerEntityClient();
					
					newWRClient.entityObj = entObj_;
					
					Logger.message(newWRClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newWRClient;
					
				break;
			}
			
			Logger.message("Unknown object type.", TAG, LogLevel.Error, LogModule.Controller);
			
			return null;
		}
	}
}