package com.sigma.socialgame.controller.shop
{
	import com.sigma.socialgame.controller.shop.clients.ExpandShopClient;
	import com.sigma.socialgame.controller.shop.clients.ShopClient;
	import com.sigma.socialgame.controller.shop.objects.ExpandShopObject;
	import com.sigma.socialgame.controller.shop.objects.ShopObject;

	public class ShopClientFactory
	{
		public static function createClient(shopObj_ : ShopObject) : ShopClient
		{
			var newClient : ShopClient = new ShopClient();
			
			newClient.shopObject = shopObj_;
			
			return newClient;
		}
		
		public static function createExpandClient(expand_ : ExpandShopObject) : ExpandShopClient
		{
			var newClient : ExpandShopClient = new ExpandShopClient();
			
			newClient.expand = expand_;
			
			return newClient;
		}
	}
}