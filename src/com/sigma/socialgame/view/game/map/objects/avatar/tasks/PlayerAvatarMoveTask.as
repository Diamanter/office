package com.sigma.socialgame.view.game.map.objects.avatar.tasks
{
	import com.sigma.socialgame.controller.map.way.WayPoint;

	public class PlayerAvatarMoveTask extends PlayerAvatarBaseTask
	{
		public function PlayerAvatarMoveTask(callback_ : Function, waypoint_ : WayPoint)
		{
			super(callback_, waypoint_);
			
			_priority = PlayerAvatarTaskPriority.Move;
		}
	}
}