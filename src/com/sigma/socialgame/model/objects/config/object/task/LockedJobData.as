package com.sigma.socialgame.model.objects.config.object.task
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	
	public class LockedJobData extends JobData implements ILockable
	{
		private var _condition : ConditionData;
		
		public function LockedJobData()
		{
			super();
		}
		
		public function get condition():ConditionData
		{
			return _condition;
		}
		
		public function set condition(condition_:ConditionData):void
		{
			_condition = condition_;
		}
	}
}