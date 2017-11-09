package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	
	public class JobData
	{
		private var _period : Number;
		private var _skill : SkillData;
		private var _id : int;
		
		private var _need : Vector.<NeedData>;
		private var _gives : Vector.<GiveData>; 
		private var _require : Vector.<RequireData>;
		private var _result : Vector.<ResultData>;
		
		private var _manured : ManuredData;
		private var _ferilizer : FertilizerData;
		
		public function JobData()
		{
		}

		public function get gives():Vector.<GiveData>
		{
			return _gives;
		}

		public function set gives(value:Vector.<GiveData>):void
		{
			_gives = value;
		}

		public function get require():Vector.<RequireData>
		{
			return _require;
		}

		public function set require(value:Vector.<RequireData>):void
		{
			_require = value;
		}

		public function get result():Vector.<ResultData>
		{
			return _result;
		}

		public function set result(value:Vector.<ResultData>):void
		{
			_result = value;
		}

		public function get period():Number
		{
			return _period;
		}

		public function set period(value:Number):void
		{
			_period = value;
		}

		public function toString() :String
		{
			return "Period: " + _period;
		}

		public function get need():Vector.<NeedData>
		{
			return _need;
		}

		public function set need(value:Vector.<NeedData>):void
		{
			_need = value;
		}

		public function get skill():SkillData
		{
			return _skill;
		}

		public function set skill(value:SkillData):void
		{
			_skill = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get manured():ManuredData
		{
			return _manured;
		}

		public function set manured(value:ManuredData):void
		{
			_manured = value;
		}

		public function get ferilizer():FertilizerData
		{
			return _ferilizer;
		}

		public function set ferilizer(value:FertilizerData):void
		{
			_ferilizer = value;
		}


	}
}