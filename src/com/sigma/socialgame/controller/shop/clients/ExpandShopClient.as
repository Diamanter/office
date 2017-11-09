package com.sigma.socialgame.controller.shop.clients
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.shop.ShopController;
	import com.sigma.socialgame.controller.shop.objects.ExpandShopObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.ExpandShopClientEvent;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	import com.sigma.socialgame.model.objects.sync.unlock.ExpandUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	
	import flash.events.EventDispatcher;

	public class ExpandShopClient extends EventDispatcher
	{
		private var _expand : ExpandShopObject;
		
		private var _wasLock : Boolean;
		
		public function ExpandShopClient()
		{
			super();

			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			wCon.addEventListener(WalletControllerEvent.LevelChanged, onWalletConEvent);
			wCon.addEventListener(WalletControllerEvent.AmountChanged, onWalletConEvent);
		}

		protected function onWalletConEvent(e : WalletControllerEvent) : void
		{
			switch (e.type)
			{
				case WalletControllerEvent.LevelChanged:
					
					if (_wasLock == false && unlocked == true)
						dispatchEvent(new ExpandShopClientEvent(ExpandShopClientEvent.Unlocked));
					
					break;
			}
		}
		
		public function get unlocked() : Boolean
		{
			for each (var unlocked : UnlockedData in ResourceManager.instance.unlocked)
			{
				if (unlocked is ExpandUnlockedData)
				{
					if (_expand.expandObject.id == (unlocked as ExpandUnlockedData).expand.id)
					{
						return true;
					}
				}
			}
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			if (_expand.expandObject.condition != null)
			{
				if (_expand.expandObject.condition.level > 0)
					if (_expand.expandObject.condition.level <= wCon.currLevel.rank)
						return true;
				
				if (_expand.expandObject.condition.friends > 0)
					if (_expand.expandObject.condition.friends <= fCon.appFriends.length)
						return true;
			}
			else
				return true;
			
			return false;
		}

		public function unlock() : void
		{
			if (canUnlock)
			{
				if (shopController.unlockExpandObject(_expand))
					dispatchEvent(new ExpandShopClientEvent(ExpandShopClientEvent.Unlocked));
			}
		}
		
		public function get canUnlock() : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			if (_expand.expandObject.condition != null)
			{
				if (_expand.expandObject.condition.price.amount >= wCon.getAmount(_expand.expandObject.condition.price.currency.type).amountData.amount)
					return true;
			}
			
			return false;
		}
		
		public function buy(curr_ : CurrencyData) : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;

			for each (var price : AmountData in expand.expandObject.prices)
			{
				if (price.currency.type == curr_.type)
				{
					if (wCon.getAmount(curr_.type).amountData.amount >= price.amount)
					{
						shopController.buyExpandObject(expand);
						
						return true;
					}
				}
			}
				
			return false;
		}
		
		public function get expand():ExpandShopObject
		{
			return _expand;
		}

		public function set expand(value:ExpandShopObject):void
		{
			_expand = value;
			
			_wasLock = unlocked;
		}

		public function get canExpand() : Boolean
		{
			var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			if (mCon.width < _expand.expandObject.width || mCon.height < _expand.expandObject.height)
			{
				return true;
			}
			
			return false;
		}
		
		protected function get shopController() : ShopController
		{
			return ControllerManager.instance.getController(ControllerNames.ShopController) as ShopController;
		}
	}
}