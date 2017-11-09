package com.sigma.socialgame.controller
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.map.MapController;
	
	import flash.events.EventDispatcher;
	
	public class Controller extends EventDispatcher
	{
		private var _name : String;
		
		public function Controller(name_ : String)
		{
			super();
			
			_name = name_;
		}
		
		public function init():void
		{
			Logger.message("Using abstract function \"init\".", "Controller", LogLevel.Warning, LogModule.Controller);
		}
		
		public function start() : void
		{
			Logger.message("Using abstract function \"start\".", "Controller", LogLevel.Warning, LogModule.Controller);
		}
		
		public function reload() : void
		{
			Logger.message("Using abstract function \"reload\".", "Controller", LogLevel.Warning, LogModule.Controller);
		}
		
/*		public function sync() : void
		{
			Logger.message("Using abstract function \"sync\".", "Controller", LogLevel.Warning, LogModule.Controller);
		}
*/		
		public function get name():String
		{
			return _name;
		}
	}
}