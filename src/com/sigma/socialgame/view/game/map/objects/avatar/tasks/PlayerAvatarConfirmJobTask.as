package com.sigma.socialgame.view.game.map.objects.avatar.tasks
{
	import com.sigma.socialgame.controller.entity.clients.WorkerEntityClient;
	import com.sigma.socialgame.controller.map.way.WayPoint;
	
	public class PlayerAvatarConfirmJobTask extends PlayerAvatarBaseTask
	{
		private var _workerEntityClient : WorkerEntityClient;
		
		public function PlayerAvatarConfirmJobTask(callback_ : Function, waypoint_ : WayPoint, workerEntityClient_ : WorkerEntityClient)
		{
			super(callback_, waypoint_);
			
			_priority = PlayerAvatarTaskPriority.Interact;			
			_workerEntityClient = workerEntityClient_;
		}
		
		public override function doTask() : void
		{
			_workerEntityClient.acceptWork();
			super.doTask();
		}
	}
}