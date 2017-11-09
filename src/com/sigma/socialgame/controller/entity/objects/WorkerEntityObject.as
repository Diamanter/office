package com.sigma.socialgame.controller.entity.objects
{
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.map.WorkerMapObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;

	public class WorkerEntityObject extends EntityObject
	{
		private var _state : String;
		
		public function WorkerEntityObject()
		{
			super();
		}

		public function get currTask():CurrTaskData
		{
			return (mapObject as WorkerMapObjectData).currTask;
		}

		public function set currTask(value:CurrTaskData):void
		{
			(mapObject as WorkerMapObjectData).currTask = value;
		}

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			_state = value;
		}

		public function get currSkill():SkillData
		{
			return (mapObject as WorkerMapObjectData).currSkill;
		}

		public function set currSkill(value:SkillData):void
		{
			(mapObject as WorkerMapObjectData).currSkill = value;
		}
	}
}