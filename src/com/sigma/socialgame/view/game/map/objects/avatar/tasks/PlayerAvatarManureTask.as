package com.sigma.socialgame.view.game.map.objects.avatar.tasks
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.clients.WorkerEntityClient;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.map.way.WayPoint;

	public class PlayerAvatarManureTask extends PlayerAvatarBaseTask
	{
		private var _workerEntityClient : WorkerEntityClient;
		
		public function PlayerAvatarManureTask(callback_ : Function, waypoint_ : WayPoint, workerEntityClient_ : WorkerEntityClient)
		{
			super(callback_, waypoint_);
			
			_priority = PlayerAvatarTaskPriority.Interact;			
			_workerEntityClient = workerEntityClient_;
		}
		
		public override function doTask() : void
		{
			_workerEntityClient.manure();
			
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			fCon.manure();
			
			super.doTask();
		}	
	}
}