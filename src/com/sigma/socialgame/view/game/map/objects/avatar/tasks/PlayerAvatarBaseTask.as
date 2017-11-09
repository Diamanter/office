package com.sigma.socialgame.view.game.map.objects.avatar.tasks
{
	import com.sigma.socialgame.controller.map.way.WayPoint;
	
	public class PlayerAvatarBaseTask
	{
		private var _callback : Function = null;
		protected var _priority : int = -1;
		public var waypoint : WayPoint;

		public function PlayerAvatarBaseTask(callback_ : Function, waypoint_ : WayPoint)
		{
			_callback = callback_;
			waypoint = waypoint_;
		}
		
		public function get priority() : int
		{
			return _priority;
		}
		
		public function doTask() : void
		{
			if (_callback != null)
			{
				_callback();
			}
		}
	}
}