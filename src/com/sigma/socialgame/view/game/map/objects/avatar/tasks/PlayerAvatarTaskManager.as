package com.sigma.socialgame.view.game.map.objects.avatar.tasks
{
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatarState;
	
	import flash.utils.setTimeout;
	
//	import flashx.textLayout.debug.assert;

	public class PlayerAvatarTaskManager
	{
		private static var _tasks : Vector.<PlayerAvatarBaseTask> = null;
		private static var _avatar : PlayerAvatar = null;
		public static const InteractTimeMs : int = 1000;
		
		public static function Initialize(avatar_ : PlayerAvatar) : void
		{
			_avatar = avatar_;
			_avatar.onStopMove = onAvatarStopMove;
			_tasks = new Vector.<PlayerAvatarBaseTask>();
		}
		
		protected static function onAvatarWaypointReached() : void
		{
			if (_tasks.length == 0)
			{
				return;
			}
			
			var currentTask : PlayerAvatarBaseTask = _tasks.shift();
			
			if (currentTask.priority == PlayerAvatarTaskPriority.Interact)
			{
				_avatar.state = PlayerAvatarState.Interacting;
				setTimeout(
					function():void
					{
						_avatar.state = PlayerAvatarState.Walking;
						currentTask.doTask();
						_avatar.nextTarget();
					},
					InteractTimeMs
				)
				return;
			}
			currentTask.doTask();
			_avatar.nextTarget();
		}
		
		protected static function onAvatarStopMove() : void
		{
			_avatar.state = PlayerAvatarState.Standing;
		}
		
		public static function addTask(task : PlayerAvatarBaseTask, removeWithLowestPriority : Boolean = false) : void
		{
			if (_avatar == null) return;
			
			if (removeWithLowestPriority)
			{
				_avatar.clearAllWaypoints();
				var newTasks : Vector.<PlayerAvatarBaseTask> = new Vector.<PlayerAvatarBaseTask>();
				
				for each (var taskToCheck : PlayerAvatarBaseTask in _tasks)
				{
					if (taskToCheck.priority >= task.priority)
					{
						newTasks.push(taskToCheck);
						_avatar.addWayPoint(taskToCheck.waypoint, onAvatarWaypointReached);
					}
				}
				
				_tasks = newTasks;
			}
						
			_tasks.push(task);
			
			_avatar.addWayPoint(task.waypoint, onAvatarWaypointReached);
			_avatar.move();
		}
	}
}