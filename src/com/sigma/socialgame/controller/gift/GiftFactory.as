package com.sigma.socialgame.controller.gift
{
	import com.sigma.socialgame.controller.gift.clients.GiftClient;
	import com.sigma.socialgame.controller.gift.objects.CurrGiftObject;
	import com.sigma.socialgame.controller.gift.objects.GiftObject;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.sync.gift.GiftData;

	public class GiftFactory
	{
		public static function createGift(od_ : ObjectData) : GiftObject
		{
			var newGift : GiftObject = new GiftObject();
			
			newGift.object = od_;
			
			return newGift;
		}
		
		public static function createCurrGift(gd_ : GiftData) : CurrGiftObject
		{
			var newCGO : CurrGiftObject = new CurrGiftObject();
			
			newCGO.gift = gd_;
			
			return newCGO;
		}
		
		public static function createGiftClient(go_ : GiftObject) : GiftClient
		{
			var newGC : GiftClient = new GiftClient();
			
			newGC.gift = go_;
			
			return newGC;
		}
	}
}