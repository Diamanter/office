package com.sigma.socialgame.model.objects.sync.wallet
{
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;

	public class WorkerAmountData extends AmountData
	{
		private var _skill : SkillData;
		
		public function WorkerAmountData()
		{
			super();
		}
		
		public function get skill():SkillData
		{
			return _skill;
		}

		public function set skill(value:SkillData):void
		{
			_skill = value;
		}

	}
}