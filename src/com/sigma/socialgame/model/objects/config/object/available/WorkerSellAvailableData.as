package com.sigma.socialgame.model.objects.config.object.available
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class WorkerSellAvailableData extends SellAvailableData
	{
		private var _skillToPrice : Object;
		
		public function WorkerSellAvailableData()
		{
			super();
			
			_skillToPrice = new Object();
		}
		
		public function addSkillPrice(skillId_ : int, price_ : AmountData) : void
		{
			_skillToPrice[skillId_] = price_;
		}
		
		public function getSkillPrice(skillId_ : int) : AmountData
		{
			return _skillToPrice[skillId_];
		}
	}
}