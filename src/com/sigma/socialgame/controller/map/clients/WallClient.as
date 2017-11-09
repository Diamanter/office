package com.sigma.socialgame.controller.map.clients
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.map.objects.WallObject;

	public class WallClient extends MapClient
	{
		
		public function WallClient()
		{
			super();
		}
		
		public function checkPos(wall_ : int, x_ : int) : Boolean
		{
			return check(wall_, x_);
		}
		
		public function move(wall_ : int, x_ : int, send : Boolean) : Boolean
		{
			if (!checkPos(wall_, x_))
				return false;
			
			wallObject.wall = wall_;
			wallObject.x = x_;
			
			mapController.moveWallObject(wallObject, send);
			
			return true;
		}
		
		protected function check(wall_ : int, x_ : int) : Boolean
		{
			Logger.message("Using abstract function \"check\".", "MapControllerClient", LogLevel.Warning, LogModule.Controller);
			
			return false;
		}
		
		public function get wallObject():WallObject
		{
			return mapObject as WallObject;
		}
		
		public override function toString() : String
		{
			return "WallObejct: " + wallObject.toString();
		}
	}
}