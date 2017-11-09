package com.sigma.socialgame.model.objects.config.object
{
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;

	public class WorkerObjectData extends CellObjectData
	{
		private var _skills : Vector.<SkillData>;
		private var _tasks : Vector.<TaskData>;
		
		public function WorkerObjectData()
		{
			super();
		}

		public function get skills():Vector.<SkillData>
		{
			return _skills;
		}

		public function set skills(value:Vector.<SkillData>):void
		{
			_skills = value;
		}

		public override function toString():String
		{
			return super.toString() + "\nSkills: " + _skills;
		}

		public function get tasks():Vector.<TaskData>
		{
			return _tasks;
		}

		public function set tasks(value:Vector.<TaskData>):void
		{
			_tasks = value;
		}
	}
}