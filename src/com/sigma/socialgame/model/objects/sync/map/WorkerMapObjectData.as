package com.sigma.socialgame.model.objects.sync.map
{
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;

	public class WorkerMapObjectData extends CellMapObjectData
	{
		private var _currTask : CurrTaskData;
		
		public function WorkerMapObjectData()
		{
			super();
		}

		public function get currSkill():SkillData
		{
			return (storeObject as WorkerStoreObjectData).currSkill;
		}

		public function set currSkill(value:SkillData):void
		{
			(storeObject as WorkerStoreObjectData).currSkill = value;
		}

		public function get currTask():CurrTaskData
		{
			return _currTask;
		}

		public function set currTask(value:CurrTaskData):void
		{
			_currTask = value;
		}

	}
}