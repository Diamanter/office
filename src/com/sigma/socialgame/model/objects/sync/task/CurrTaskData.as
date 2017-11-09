package com.sigma.socialgame.model.objects.sync.task
{
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;

	public class CurrTaskData
	{
		private var _storeObject : StoreObjectData;
		
		private var _id : int;
		private var _backId : int;
		
		private var _task : TaskData;
		private var _job : JobData;
		
		private var _time : Number;
		
		private var _complete : Boolean;
		
		private var _manured : Boolean;
		
		public function CurrTaskData()
		{
		}

		public function get storeObject():StoreObjectData
		{
			return _storeObject;
		}

		public function set storeObject(value:StoreObjectData):void
		{
			_storeObject = value;
		}

		public function get task():TaskData
		{
			return _task;
		}

		public function set task(value:TaskData):void
		{
			_task = value;
		}

		public function get time():Number
		{
			return _time;
		}

		public function set time(value:Number):void
		{
			_time = value;
		}

		public function toString() : String
		{
			return "Task: " + _task + "\nTime: " + _time;
		}

		public function get complete():Boolean
		{
			return _complete;
		}

		public function set complete(value:Boolean):void
		{
			_complete = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get job():JobData
		{
			return _job;
		}

		public function set job(value:JobData):void
		{
			_job = value;
		}

		public function get backId():int
		{
			return _backId;
		}

		public function set backId(value:int):void
		{
			_backId = value;
		}

		public function get manured():Boolean
		{
			return _manured;
		}

		public function set manured(value:Boolean):void
		{
			_manured = value;
		}


	}
}