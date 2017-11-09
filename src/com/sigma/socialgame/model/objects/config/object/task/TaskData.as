package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;

	public class TaskData
	{
		private var _id : int;
		private var _name : String;
		private var _jobs : Vector.<JobData>;
		private var _image : String;
		
		public function TaskData()
		{
		}

		public function get jobs():Vector.<JobData>
		{
			return _jobs;
		}

		public function set jobs(value:Vector.<JobData>):void
		{
			_jobs = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}
	
		public function toString() : String
		{
			return "Id: " + _id;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}
	}
}