package com.sigma.socialgame.model.objects.sync.unlock
{
	import com.sigma.socialgame.model.objects.config.object.task.JobData;

	public class JobUnlockedData extends UnlockedData
	{
		private var _job : JobData;
		
		public function JobUnlockedData()
		{
			super(UnlockedType.Job);
		}

		public function get job():JobData
		{
			return _job;
		}

		public function set job(value:JobData):void
		{
			_job = value;
		}

	}
}