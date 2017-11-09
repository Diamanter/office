package com.sigma.socialgame.controller.map.clients
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.events.controller.MapClientEvent;
	
	import flash.events.EventDispatcher;
	
	public class MapClient extends EventDispatcher
	{
		private var _mapController : MapController;
		private var _mapObject : MapObject;
		
		public function MapClient()
		{
			super();
		}
		
		protected function get mapController() : MapController
		{
			if (_mapController == null)
				_mapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			return _mapController;
		}
		
		public function updated() : void
		{
			dispatchEvent(new MapClientEvent(MapClientEvent.Updated));
		}
		
		public function removed() : void
		{
			dispatchEvent(new MapClientEvent(MapClientEvent.Removed));
		}

		public function get mapObject():MapObject
		{
			return _mapObject;
		}

		public function set mapObject(value:MapObject):void
		{
			_mapObject = value;
		}

	}
}