package com.sigma.socialgame.view.game.map.objects.avatar.tasks
{
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;

	public class PlayerAvatarStartJobTask extends PlayerAvatarBaseTask
	{
		private var _workerEntity : WorkerEntity;
		private var _taskData : TaskData;
		
		public function PlayerAvatarStartJobTask(callback_ : Function, waypoint_ : WayPoint, workerEntity_ : WorkerEntity, taskData_ : TaskData)
		{
			super(callback_, waypoint_);
			
			_priority = PlayerAvatarTaskPriority.Interact;			
			_workerEntity = workerEntity_;
			_taskData = taskData_;
		}
		
		public override function doTask() : void
		{
			_workerEntity.startTask(_taskData);
			
			super.doTask();
		}
	}
}