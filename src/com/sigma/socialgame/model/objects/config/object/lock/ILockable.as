package com.sigma.socialgame.model.objects.config.object.lock
{
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;

	public interface ILockable
	{
		function get condition() : ConditionData;
		function set condition(condition_ : ConditionData) : void;
	}
}