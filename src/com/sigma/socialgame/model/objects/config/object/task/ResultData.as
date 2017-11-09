package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;

	public class ResultData
	{
		private var _type : String;
		
		private var _object : ObjectIdentifier;
		private var _amount : int;
		private var _skill : SkillData;
		
		public function ResultData()
		{
		}

		public function get object():ObjectIdentifier
		{
			return _object;
		}

		public function set object(value:ObjectIdentifier):void
		{
			_object = value;
		}

		public function get amount():int
		{
			return _amount;
		}

		public function set amount(value:int):void
		{
			_amount = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
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