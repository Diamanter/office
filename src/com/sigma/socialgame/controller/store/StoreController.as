package com.sigma.socialgame.controller.store
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.events.controller.StoreControllerEvent;
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	
	public class StoreController extends Controller
	{
		public static const TAG : String = "StoreController";
		
		private var _store : Vector.<StoreObject>;
		
		public function StoreController()
		{
			super(ControllerNames.StoreController);
		}
		
		public override function init():void
		{
			_store = new Vector.<StoreObject>();
			
			dispatchEvent(new StoreControllerEvent(StoreControllerEvent.Inited));
		}
		
		public override function start() : void
		{
			Logger.message("Starting store controller.", TAG, LogLevel.Info, LogModule.Controller);
			
			for each (var thing : StoreObjectData in ResourceManager.instance.store)
			{
				addStoreObjectByData(thing);
			}
			
			Logger.message("Store controller started.", TAG, LogLevel.Info, LogModule.Controller);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.StoreObjectChanged, onStoreSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.StoreObjectRemoved, onStoreSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.StoreObjectAdded, onStoreSyncEvent);
			
			dispatchEvent(new StoreControllerEvent(StoreControllerEvent.Started));
		}
		
		public override function reload():void
		{
			_store = new Vector.<StoreObject>();
			
			for each (var thing : StoreObjectData in ResourceManager.instance.store)
			{
				addStoreObjectByData(thing);
			}
		}
		
		public function hasObject(objId_ : ObjectIdentifier) : Boolean
		{
			for each (var storeObject : StoreObject in _store)
			{
				if (storeObject.storeObject.object.objectId.equals(objId_))
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function findStoreObject(storeObject_ : StoreObjectData) : StoreObject
		{
			for each (var storeobject : StoreObject in _store)
			{
				if (storeobject.storeObject.storeId.equals(storeObject_.storeId))
				{
					return storeobject;
				}
			}
			
			return null;
		}
		
		public function get inventory() : Vector.<StoreObject>
		{
			var objs : Vector.<StoreObject> = new Vector.<StoreObject>();
			
			var obj : StoreObject;
			
			var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			var found : Boolean;
			
			for each (obj in _store)
			{
				if (obj.storeObject.object.place == ObjectPlaces.Cell)
				{
					found = false;
					
					for each (var co : CellObject in mCon.cellObjects)
					{
						if (obj.storeObject.storeId.equals(co.mapObject.storeObject.storeId))
						{
							if (obj.storeObject.object.type == ObjectTypes.Worker)
							{
								if ((obj.storeObject as WorkerStoreObjectData).currSkill.id == (co.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
									found = true;
							}
							else
								found = true;
							
							break;
						}
					}
					
					if (!found)
						objs.push(obj);
				}
				else
				{
					found = false;
					
					for each (var wo : WallObject in mCon.wallObjects)
					{
						if (obj.storeObject.storeId.equals(wo.mapObject.storeObject.storeId))
						{
							if (obj.storeObject.object.type == ObjectTypes.Worker)
							{
								if ((obj.storeObject as WorkerStoreObjectData).currSkill.id == (wo.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
									found = true;
							}
							else
								found = true;
							
							break;
						}
					}
					
					if (!found)
						objs.push(obj);
				}
			}
			
/*			for each (obj in _store)
				objs.push(obj);
				
			for each (obj in objs)
			{
				if (obj.storeObject.object.place == ObjectPlaces.Cell)
				{
					for each (var co : CellObject in mCon.cellObjects)
					{
						if (obj.storeObject.storeId.equals(co.mapObject.storeObject.storeId))
						{
							if (obj.storeObject.object.type == ObjectTypes.Worker)
							{
								if ((obj.storeObject as WorkerStoreObjectData).currSkill.id != (co.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
									continue;
							}
							
							objs.splice(objs.indexOf(obj), 1);
							
							break;
						}
					}
				}
				else
				{
					for each (var wo : WallObject in mCon.wallObjects)
					{
						if (obj.storeObject.storeId.equals(wo.mapObject.storeObject.storeId))
						{
							if (obj.storeObject.object.type == ObjectTypes.Worker)
							{
								if ((obj.storeObject as WorkerStoreObjectData).currSkill.id != (wo.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
									continue;
							}
							
							objs.splice(objs.indexOf(obj), 1);
							
							break;
						}
					}
				}
			}
*/			
			return objs;
		}
		
		protected function onStoreSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			var storeobj : StoreObject = findStoreObject(e.storeObject);
			var scEvent : StoreControllerEvent;
			
			var newStoreObject : StoreObject;
			
			switch (e.type)
			{
				case ResourceSynchronizerEvent.StoreObjectChanged:
					
					scEvent = new StoreControllerEvent(StoreControllerEvent.StoreObjectChanged);
					scEvent.storeObject = storeobj;
					dispatchEvent(scEvent);
					
					break;
				
				case ResourceSynchronizerEvent.StoreObjectRemoved:
					
					removeStoreObject(storeobj);
					
					scEvent = new StoreControllerEvent(StoreControllerEvent.StoreObjectRemoved);
					scEvent.storeObject = storeobj;
					dispatchEvent(scEvent);
					
					break;
				
				case ResourceSynchronizerEvent.StoreObjectAdded:
					
					newStoreObject = addStoreObjectByData(e.storeObject);
					
					scEvent = new StoreControllerEvent(StoreControllerEvent.StoreObjectAdded);
					scEvent.storeObject = newStoreObject;
					dispatchEvent(scEvent);
					
					break;
			}
		}

		public function get store() : Vector.<StoreObject>
		{
			return _store;
		}
		
		public function addStoreObject(object : ObjectData, skill_ : SkillData = null) : StoreObject
		{
			return addStoreObjectByData(ResourceManager.instance.addStoreObject(object, skill_)); 
		}
		
		protected function addStoreObjectByData(thing : StoreObjectData) : StoreObject
		{
			var newSO : StoreObject = StoreFactory.createStoreObject(thing);
			
			_store.push(newSO);

			var scEvent : StoreControllerEvent = new StoreControllerEvent(StoreControllerEvent.StoreObjectAdded);
			scEvent.storeObject = newSO;
			dispatchEvent(scEvent);
			
			return newSO;
		}
		
		public function removeStoreObjectByData(storeObject_ : StoreObjectData) : void
		{
			var sO : StoreObject = findStoreObject(storeObject_);
			
			removeStoreObject(sO);
		}
		
		protected function removeStoreObject(storeObject_ : StoreObject) : void
		{
			_store.splice(_store.indexOf(storeObject_), 1);
			
			var scEvent : StoreControllerEvent = new StoreControllerEvent(StoreControllerEvent.StoreObjectRemoved);
			scEvent.storeObject = storeObject_;
			dispatchEvent(scEvent);
		}
	}
}