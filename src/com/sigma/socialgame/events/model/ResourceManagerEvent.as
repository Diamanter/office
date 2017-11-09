package com.sigma.socialgame.events.model
{
	import flash.events.Event;
	
	public class ResourceManagerEvent extends Event
	{
		public static const Started : String = "rmStarted";
		public static const Synced : String = "rmSynced";
		public static const Finished : String = "rmFinished";

		public static const QuestsUpdated : String = "rmQuestsUpdated";
		public static const Reload : String = "rmReload";
		
		public static const Reloading : String = "rmReloading";
		
		private var _myOffice : Boolean; 
		
		public function ResourceManagerEvent(type:String)
		{
			super(type);
		}

		public function get myOffice():Boolean
		{
			return _myOffice;
		}

		public function set myOffice(value:Boolean):void
		{
			_myOffice = value;
		}
	}
}