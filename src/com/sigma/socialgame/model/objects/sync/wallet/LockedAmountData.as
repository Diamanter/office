package com.sigma.socialgame.model.objects.sync.wallet
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	
	public class LockedAmountData extends AmountData implements ILockable
	{
		private var _condition : ConditionData;
		
		public function LockedAmountData()
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