package com.sigma.socialgame.model.objects.sync.unlock
{
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;

	public class PriceUnlockedData extends UnlockedData
	{
		private var _object : ObjectData;
		private var _skill : SkillData;
		
		public function PriceUnlockedData()
		{
			super(UnlockedType.Price);
		}
		
		
		public function get object():ObjectData
		{
			return _object;
		}

		public function set object(value:ObjectData):void
		{
			_object = value;
		}

		public function get skill():SkillData
		{
			return _skill;
		}

		public function set skill(value:SkillData):void
		{
			_skill = value;
		}

		public override function toString():String
		{
			return super.toString() + "\nObjcet: " + _object.toString() + "Skill: " + (_skill == null ? _skill : _skill.toString());
		}
	}
}