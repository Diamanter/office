package com.sigma.socialgame.controller.map
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.map.clients.CellClient;
	import com.sigma.socialgame.controller.map.clients.DecorCellClient;
	import com.sigma.socialgame.controller.map.clients.DecorWallClient;
	import com.sigma.socialgame.controller.map.clients.TrimCellClient;
	import com.sigma.socialgame.controller.map.clients.TrimWallClient;
	import com.sigma.socialgame.controller.map.clients.WallClient;
	import com.sigma.socialgame.controller.map.clients.WorkerClient;
	import com.sigma.socialgame.controller.map.clients.WorkspaceClient;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;

	public class MapClientFactory
	{
		public static const TAG : String = "MapClientFactory";
		
		public static function createCellClient(cellObj_ : CellObject) : CellClient
		{
			if (cellObj_ == null)
			{
				Logger.message("CellObject must be non null.", TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var type : String = cellObj_.mapObject.storeObject.object.type;
			
			switch (type)
			{
				case ObjectTypes.Decor:
					
					Logger.message("Creating decor cell client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newClient : DecorCellClient = new DecorCellClient();
					
					newClient.mapObject = cellObj_;
					
					Logger.message(newClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newClient;
					
				break;
				
				case ObjectTypes.Workspace:

					Logger.message("Creating workspace cell client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newWClient : WorkspaceClient = new WorkspaceClient();
					
					newWClient.mapObject = cellObj_;
					
					Logger.message(newWClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newWClient;

				break;
				
				case ObjectTypes.Trim:
					
					Logger.message("Creating trim cell client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newTClient : TrimCellClient = new TrimCellClient();
					
					newTClient.mapObject = cellObj_;
					
					Logger.message(newTClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newTClient;
					
				break;
				
				case ObjectTypes.Worker:
					
					Logger.message("Creating worker cell client.", TAG, LogLevel.Debug, LogModule.Controller);
					
					var newWRClient : WorkerClient = new WorkerClient();
					
					newWRClient.mapObject = cellObj_;
					
					Logger.message(newWRClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newWRClient;
					
				break;
			}
			
			Logger.message("Unknown object type.", TAG, LogLevel.Error, LogModule.Controller);
			
			return null;
		}
		
		public static function createWallClient(wallObj_ : WallObject) : WallClient
		{
			var type : String = wallObj_.mapObject.storeObject.object.type;
			
			switch (type)
			{
				case ObjectTypes.Decor:
					
					Logger.message("Creating decor wall client.", "MapClientFctory", LogLevel.Debug, LogModule.Controller);
					
					var newClient : DecorWallClient = new DecorWallClient();
					
					newClient.mapObject = wallObj_;
					
					Logger.message(newClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newClient;
					
				break;
				
				case ObjectTypes.Trim:
					
					Logger.message("Creating trim wall client.", "MapClientFctory", LogLevel.Debug, LogModule.Controller);
					
					var newTClient : TrimWallClient = new TrimWallClient();
					
					newTClient.mapObject = wallObj_;
					
					Logger.message(newTClient.toString(), "", LogLevel.Debug, LogModule.Controller);
					
					return newTClient;
					
				break;
			}
			
			Logger.message("Unknown object type.", "MapClientFactory", LogLevel.Error, LogModule.Controller);
			
			return null;
		}
	}
}