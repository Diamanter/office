package com.sigma.socialgame.controller.entity
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.clients.EntityClient;
	import com.sigma.socialgame.controller.entity.clients.WorkerEntityClient;
	import com.sigma.socialgame.controller.entity.objects.EntityObject;
	import com.sigma.socialgame.controller.entity.objects.WorkerEntityObject;
	import com.sigma.socialgame.events.controller.EntityControllerEvent;
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.MapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	
	import flash.utils.Dictionary;
	
	public class EntityController extends Controller
	{
		public static const TAG : String = "EntityController";
		
		private var _objects : Vector.<EntityObject>;
		private var _clients : Vector.<EntityClient>;
		
		private var _objectClients : Dictionary;
		
		public function EntityController()
		{
			super(ControllerNames.EntityConrtoller);
		}
		
		public override function init():void
		{
			Logger.message("Initing entity controller.", TAG, LogLevel.Info, LogModule.Controller);
		
			_clients = new Vector.<EntityClient>();
			_objects = new Vector.<EntityObject>();
			
			_objectClients = new Dictionary();
			
			Logger.message("Entity controller inited.", TAG, LogLevel.Info, LogModule.Controller);
			
			dispatchEvent(new EntityControllerEvent(EntityControllerEvent.Inited));
		}

		public override function start() : void
		{
			Logger.message("Stating entity controller.", TAG, LogLevel.Info, LogModule.Controller);
			
			var newEntObj : EntityObject;
			
			for each (var cellOD : CellMapObjectData in ResourceManager.instance.mapCells)
			{
				newEntObj = EntityFactory.createEntityObject(cellOD);
				
				_objects.push(newEntObj);
			}
			
			for each (var wallOD : WallMapObjectData in ResourceManager.instance.mapWalls)
			{
				newEntObj = EntityFactory.createEntityObject(wallOD);
				
				_objects.push(newEntObj);
			}
		
			Logger.message("Entity controller started.", TAG, LogLevel.Info, LogModule.Controller);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.CellObjectChanged, onCellSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.CellObjectRemoved, onCellSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.CellObjectAdded, onCellSyncEvent);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.TaskAdded, onTaskSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.TaskRemoved, onTaskSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.TaskChanged, onTaskSyncEvent);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.WallObjectChanged, onWallSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.WallObjectRemoved, onWallSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.WallObjectAdded, onWallSyncEvent);
			
			dispatchEvent(new EntityControllerEvent(EntityControllerEvent.Started));
		}
		
		public override function reload():void
		{
			_clients = new Vector.<EntityClient>();
			_objects = new Vector.<EntityObject>();
			
			_objectClients = new Dictionary();

			var newEntObj : EntityObject;
			
			for each (var cellOD : CellMapObjectData in ResourceManager.instance.mapCells)
			{
				newEntObj = EntityFactory.createEntityObject(cellOD);
				
				_objects.push(newEntObj);
			}
			
			for each (var wallOD : WallMapObjectData in ResourceManager.instance.mapWalls)
			{
				newEntObj = EntityFactory.createEntityObject(wallOD);
				
				_objects.push(newEntObj);
			}
		}
		
		protected function findEntityObject(mapobj_ : MapObjectData) : EntityObject
		{
			return findEntityObjectBySOD(mapobj_.storeObject);
		}
		
		protected function findEntityObjectBySOD(storeObject_ : StoreObjectData) : EntityObject
		{
			for each (var entityObj : EntityObject in _objects)
			{
				if (entityObj.mapObject.storeObject.storeId.equals(storeObject_.storeId))
				{
					return entityObj;
				}
			}
			
			return null;
		}
		
		protected function findEntityObjectByCurrTask(task_ : CurrTaskData) : EntityObject
		{
			for each (var entityobj : EntityObject in _objects)
			{
				if (entityobj is WorkerEntityObject && (entityobj as WorkerEntityObject).currTask != null)
				{
					if ((entityobj as WorkerEntityObject).currTask.id == task_.id)
						return entityobj;
				}
			}
			
			return null;
		}

		protected function onTaskSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			switch (e.type)
			{
				case ResourceSynchronizerEvent.TaskAdded:
					break;
				
				case ResourceSynchronizerEvent.TaskRemoved:
					break;
				
				case ResourceSynchronizerEvent.TaskChanged:
					
					var eo : EntityObject = findEntityObjectByCurrTask(e.task);
					var ec : EntityClient = _objectClients[eo];
					
					if (ec != null)
						(ec as WorkerEntityClient).update();
					
					break;
			}
		}
		
		protected function onCellSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			var entObj : EntityObject = findEntityObject(e.cellObject);
			var client : EntityClient = _objectClients[entObj];
			
			var ecEvent : EntityControllerEvent;
			var newEntityObject : EntityObject;
			
			switch (e.type)
			{
				case ResourceSynchronizerEvent.CellObjectChanged:
					
					if (client != null)
					{
						client.update();
					}
					
					break;
				
				case ResourceSynchronizerEvent.CellObjectRemoved:
					
					if (client != null)
					{
						client.remove();
					}
					
					removeEntityObject(entObj);
						
					break;
				
				case ResourceSynchronizerEvent.CellObjectAdded:
					
					newEntityObject = addEntityObject(e.cellObject);
					
					ecEvent = new EntityControllerEvent(EntityControllerEvent.EntityObjectAdded);
					ecEvent.entityObject = newEntityObject;
					dispatchEvent(ecEvent);
					
					break;
			}
		}
		
		protected function onWallSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			var entObj : EntityObject;// = findEntityObject(e.wallObject);
			var client : EntityClient;// = _objectClients[entObj];
			
			var ecEvent : EntityControllerEvent;
			var newEntityObject : EntityObject;
			
			switch (e.type)
			{
				case ResourceSynchronizerEvent.WallObjectChanged:
					
					entObj = findEntityObject(e.wallObject);
					client = _objectClients[entObj];
					
					if (client != null)
					{
						client.update();
					}
					
					break;
				
				case ResourceSynchronizerEvent.WallObjectRemoved:
					
					entObj = findEntityObject(e.wallObject);
					client = _objectClients[entObj];
					
					if (client != null)
					{
						client.remove();
					}
					
					removeEntityObject(entObj);
					
					break;
				
				case ResourceSynchronizerEvent.WallObjectAdded:
					
					newEntityObject = addEntityObject(e.wallObject);
					
					ecEvent = new EntityControllerEvent(EntityControllerEvent.EntityObjectAdded);
					ecEvent.entityObject = newEntityObject;
					dispatchEvent(ecEvent);
					
					break;
			}
		}
		
		public function addEntityObject(mapObj_ : MapObjectData) : EntityObject
		{
			var newEntityObj : EntityObject = EntityFactory.createEntityObject(mapObj_);
			
			_objects.push(newEntityObj);
			
			return newEntityObj;
		}
		
		public function removeEntityObjectBySOD(storeObject_ : StoreObjectData) : void
		{
			var eo : EntityObject = findEntityObjectBySOD(storeObject_);
				
			removeEntityObject(eo);
		}
		
		public function removeEntityObject(entObj_ : EntityObject) : void
		{
			removeEntityClientByObj(entObj_);

			_objects.splice(_objects.indexOf(entObj_), 1);
			
			//TODO: correct removing
		}
		
		protected function removeEntityClientByObj(entObj_ : EntityObject) : void
		{
			delete _objectClients[entObj_];
		}
		
		public function removeEntityClient(entityClient_ : EntityClient) : void
		{
			if (_objectClients[entityClient_.entityObj] == null)
			{
				Logger.message("Specified entity client doesn't exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				return;
			}
			
			removeEntityClientByObj(entityClient_.entityObj);
		}
		
		public function getClientByStoreId(storeId_ : StoreIdentifier) : EntityClient
		{
			var entObject : EntityObject;
			
			for each (var entObj : EntityObject in _objects)
			{
				if (!entObj) return null;
				if (entObj.mapObject.storeObject.storeId.equals(storeId_))
				{
					entObject = entObj;
					
					break;
				}
			}
			
			if (entObject == null)
			{
				Logger.message("Could not find EntityObject by specified StoreId: " + storeId_.toString(), TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			if (_objectClients[entObject] != null)
			{
				Logger.message("Entity client to specified entity object allready exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				Logger.message(entObject.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var newClient : EntityClient = EntityClientFactory.createClient(entObject);
			
			_objectClients[entObject] = newClient;
			
			return newClient;
		}
		
		public function getClient(entObj_ : EntityObject) : EntityClient
		{
			if (_objectClients[entObj_] != null)
			{
				Logger.message("Entity client to specified entity object allready exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				Logger.message(entObj_.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var newClient : EntityClient = EntityClientFactory.createClient(entObj_);
			
			_objectClients[entObj_] = newClient;
			
			return newClient;
		}
		
		public function get objects():Vector.<EntityObject>
		{
			return _objects;
		}

	}
}