package com.sigma.socialgame.controller.shop
{
	import com.sigma.socialgame.controller.shop.objects.ExpandShopObject;
	import com.sigma.socialgame.controller.shop.objects.ShopObject;
	import com.sigma.socialgame.controller.shop.objects.WorkerShopObject;
	import com.sigma.socialgame.model.objects.config.expand.ExpandData;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;

	public class ShopFactory
	{
		public static function createShopObject(object_ : ObjectData) : ShopObject
		{
			var newSO : ShopObject;
			
			for each (var avail : AvailableData in object_.available)
			{
				if (avail.type == AvailableTypes.Buy)
				{
					newSO = new ShopObject();
					newSO.object = object_;
					return newSO;
				}
			}
		
			return null;
		}
		
		public static function createWorkerShopObject(object_ : ObjectData, skill_ : SkillData) : WorkerShopObject
		{
			var newSO : WorkerShopObject;
			
			for each (var avail : AvailableData in object_.available)
			{
				if (avail.type == AvailableTypes.Buy)
				{
					newSO = new WorkerShopObject();
					newSO.object = object_;
					newSO.skill = skill_;
					
					return newSO;
				}
			}
			
			return null;
		}
		
		public static function createExpandShopObject(expand_ : ExpandData) : ExpandShopObject
		{
			var newSO : ExpandShopObject = new ExpandShopObject();
			
			newSO.expandObject = expand_;
			
			return newSO;
		}
	}
}