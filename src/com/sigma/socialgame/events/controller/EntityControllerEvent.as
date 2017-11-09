package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.objects.EntityObject;

	public class EntityControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "ecInited";
		public static const Started : String = "ecStarted";
		public static const Synced : String = "ecSynced";
		
		public static const EntityObjectAdded : String = "EntityObjectAdded";
		
		private var _entityObject : EntityObject;
		
		public function EntityControllerEvent(type : String)
		{
			super(type, ControllerNames.EntityConrtoller);	
		}

		public function get entityObject():EntityObject
		{
			return _entityObject;
		}

		public function set entityObject(value:EntityObject):void
		{
			_entityObject = value;
		}

	}
}