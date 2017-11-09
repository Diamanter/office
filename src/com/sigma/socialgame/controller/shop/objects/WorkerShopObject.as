package com.sigma.socialgame.controller.shop.objects
{
	import com.sigma.socialgame.model.objects.config.object.WorkerObjectData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.WorkerBuyAvailableData;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class WorkerShopObject extends ShopObject
	{
		private var _skill : SkillData;
		
		public function WorkerShopObject()
		{
			super();
		}

		public function get skill():SkillData
		{
			return _skill;
		}

		public function set skill(value:SkillData):void
		{
			_skill = value;
		}

		public function get priceRank1() : AmountData
		{
			var prices : Vector.<AmountData>;
			
			for each (var avail : AvailableData in object.available)
			{
				if (avail.type == AvailableTypes.Buy)
				{
					prices = new Vector.<AmountData>();
					
					for each (var skill : SkillData in (object as WorkerObjectData).skills)
					{
						if (skill.rank == 1)
						{
							return (avail as WorkerBuyAvailableData).getSkillPrice(skill.id);
						}
					}
				}
			}
			
			return null;
		}
		
		public override function get prices():Vector.<AmountData>
		{
			var prices : Vector.<AmountData>;
			
			for each (var avail : AvailableData in object.available)
			{
				if (avail.type == AvailableTypes.Buy)
				{
					prices = new Vector.<AmountData>();
					
					prices.push((avail as WorkerBuyAvailableData).getSkillPrice(_skill.id));
					
					return prices;
				}
			}
			
			return null;
		}
		
		public function get workerObject() : WorkerObjectData
		{
			return object as WorkerObjectData;
		}
	}
}