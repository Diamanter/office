package com.sigma.socialgame.model.objects.config.object.available
{
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	
	import flash.utils.Dictionary;

	public class WorkerBuyAvailableData extends BuyAvailableData
	{
		private var _skillToPrice : Object;
		
		public function WorkerBuyAvailableData()
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