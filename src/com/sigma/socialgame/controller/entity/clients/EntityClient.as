package com.sigma.socialgame.controller.entity.clients
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.EntityController;
	import com.sigma.socialgame.controller.entity.objects.EntityObject;
	import com.sigma.socialgame.events.controller.EntityClientEvent;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	
	import flash.events.EventDispatcher;
	
	public class EntityClient extends EventDispatcher
	{
		private var _entController : EntityController;
		
		private var _entObject : EntityObject;
		
		public function EntityClient()
		{
			super();
		}
		
		protected function get entController() : EntityController
		{
			if (_entController == null)
				_entController = ControllerManager.instance.getController(ControllerNames.EntityConrtoller) as EntityController;
			
			return _entController;
		}
		
/*		public function canInteract() : Boolean
		{
			Logger.message("Using abstract function \"canInteract\".", "EntityControllerClient", LogLevel.Warning, LogModule.Controller);
			
			return false;
		}
		
		public function interact():void
		{
			Logger.message("Using abstract function \"interact\".", "EntityControllerClient", LogLevel.Warning, LogModule.Controller);
		}
*/		
		public function update() : void
		{
			dispatchEvent(new EntityClientEvent(EntityClientEvent.Updated));
		}
		
		public function remove() : void
		{
			dispatchEvent(new EntityClientEvent(EntityClientEvent.Removed));
		}
		
		public function get canSell() : Boolean
		{
			for each (var avail : AvailableData in entityObj.mapObject.storeObject.object.available)
			{
				if (avail.type == AvailableTypes.Sell)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function get entityObj():EntityObject
		{
			return _entObject;
		}
		
		public function set entityObj(entObj_:EntityObject):void
		{
			_entObject = entObj_;
		}
		
		public override function toString() : String
		{
			return "EntObject: " + _entObject.toString();
		}
	}
}