package com.sigma.socialgame.controller.shop.clients
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.controller.sell.SellController;
	import com.sigma.socialgame.controller.shop.ShopController;
	import com.sigma.socialgame.controller.shop.objects.ShopObject;
	import com.sigma.socialgame.controller.shop.objects.WorkerShopObject;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.MapControllerEvent;
	import com.sigma.socialgame.events.controller.ShopClientEvent;
	import com.sigma.socialgame.events.controller.StoreControllerEvent;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.model.objects.sync.unlock.PriceUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.model.objects.sync.wallet.WorkerAmountData;
	
	import flash.events.EventDispatcher;
	
	public class ShopClient extends EventDispatcher
	{
		private var _shopObject : ShopObject;
		
		private var _wasLock : Boolean;
		
		public function ShopClient()
		{
			super();
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			wCon.addEventListener(WalletControllerEvent.LevelChanged, onWalletConEvent);
			wCon.addEventListener(WalletControllerEvent.AmountChanged, onWalletConEvent);
			
			var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			sCon.addEventListener(StoreControllerEvent.StoreObjectAdded, onStoreConEvent);
			sCon.addEventListener(StoreControllerEvent.StoreObjectRemoved, onStoreConEvent);
			
			var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			mCon.addEventListener(MapControllerEvent.CellObjectAdded, onMapConEvent);
			mCon.addEventListener(MapControllerEvent.CellObjectRemoved, onMapConEvent);
			mCon.addEventListener(MapControllerEvent.WallObjectAdded, onMapConEvent);
			mCon.addEventListener(MapControllerEvent.WallObjectRemoved, onMapConEvent);
		}
		
		protected function onMapConEvent(e : MapControllerEvent) : void
		{
			dispatchEvent(new ShopClientEvent(ShopClientEvent.AmountChanged));
		}
		
		protected function onStoreConEvent(e : StoreControllerEvent) : void
		{
			dispatchEvent(new ShopClientEvent(ShopClientEvent.AmountChanged));
		}
		
		protected function onWalletConEvent(e : WalletControllerEvent) : void
		{
			switch (e.type)
			{
				case WalletControllerEvent.LevelChanged:
					
					if (_wasLock == false && unlocked == true)
						dispatchEvent(new ShopClientEvent(ShopClientEvent.Unlocked));
					
					break;
			}
		}
		
		public function get canUnlock() : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;

			if (shopObject.prices[0] as ILockable)
			{
				if ((shopObject.prices[0] as ILockable).condition.price.amount > 0)
					return true;
			}
			
			return false;
		}
		
		public function get unlocked() : Boolean
		{
			for each (var unlocked : UnlockedData in ResourceManager.instance.unlocked)
			{
				if (unlocked is PriceUnlockedData)
				{
					if (shopObject.object.objectId.equals((unlocked as PriceUnlockedData).object.objectId))
					{
						if (shopObject.object.type == ObjectTypes.Worker)
						{
							if ((shopObject.prices[0] as WorkerAmountData).skill.id == (unlocked as PriceUnlockedData).skill.id)
							{
								return true;
							}
						}
						else
						{
							return true;
						}
					}
				}
			}

			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			if (shopObject.prices[0] is ILockable)
			{
				if ((shopObject.prices[0] as ILockable).condition.level > 0)
					if ((shopObject.prices[0] as ILockable).condition.level <= wCon.currLevel.rank)
						return true;
				
				if ((shopObject.prices[0] as ILockable).condition.friends > 0)
					if ((shopObject.prices[0] as ILockable).condition.friends <= fCon.appFriends.length)
						return true;
			}
			else
				return true;
			
			return false;
		}
		
		protected function alreadyHaveStoreObjects() : Vector.<StoreObject>
		{
			var obj : Vector.<StoreObject> = new Vector.<StoreObject>();
			
			var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			for each (var store : StoreObject in sCon.store)
			{
				if (shopObject.object.objectId.equals(store.storeObject.object.objectId))
				{
					if (shopObject.object.type == ObjectTypes.Worker)
					{
						if ((shopObject as WorkerShopObject).skill.id != (store.storeObject as WorkerStoreObjectData).currSkill.id)
							continue;
					}
					
					obj.push(store);
				}
			}
			
			var object : StoreObject;
			
			if (shopObject.object.place == ObjectPlaces.Cell)
			{
				for each (var co : CellObject in mCon.cellObjects)
				{
					for each (object in obj)
					{ 
						if (object.storeObject.storeId.equals(co.mapObject.storeObject.storeId))
						{
							if (shopObject.object.type == ObjectTypes.Worker)
							{
								if ((shopObject as WorkerShopObject).skill.id != (co.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
									continue;
							}
							
							obj.splice(obj.indexOf(object), 1);
							
							break;
						}
					}
				}
			}
			else
			{
				for each (var wo : WallObject in mCon.wallObjects)
				{
					for each (object in obj)
					{
						if (object.storeObject.storeId.equals(wo.mapObject.storeObject.storeId))
						{
							if (shopObject.object.type == ObjectTypes.Worker)
							{
								if ((shopObject as WorkerShopObject).skill.id != (wo.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
									continue;
							}
							
							obj.splice(obj.indexOf(object), 1);
							
							break;
						}
					}
				}
			}
			
			return obj;
		}
		
		public function alreadyHave() : int
		{
			return alreadyHaveStoreObjects().length;
		}
		
		public function get shopObject():ShopObject
		{
			return _shopObject;
		}
		
		public function set shopObject(value:ShopObject):void
		{
			_shopObject = value;
			
			_wasLock = unlocked;
		}
		
		private var _buyCurr : String;
		private var _buyObj : StoreObject;
		private var _buySkill : SkillData;
		
		public function buyAgain() : StoreObject
		{
			return buy(_buyCurr, _buySkill);
		}
		
		public function get wasBought() : Boolean
		{
			return _wasBought;
		}
		
		private var _wasBought : Boolean;
		
		public function select() : StoreObject
		{
			var objs : Vector.<StoreObject> = alreadyHaveStoreObjects();
			
			if (objs.length == 0)
				return null;
			else
				return objs[0];
		}
		
		public function sell(skill_ : SkillData = null) : void
		{
			var have : Vector.<StoreObject> = alreadyHaveStoreObjects();
			
			if (have.length > 0)
			{
				var sCon : SellController = ControllerManager.instance.getController(ControllerNames.SellController) as SellController;
				
				sCon.sell(have[0].storeObject);
			}
		}
		
		public function buy(curr_ : String, skill_ : SkillData = null) : StoreObject
		{
			var have : Vector.<StoreObject> = alreadyHaveStoreObjects();
			
			if (have.length > 0)
			{
				_wasBought = false;
				
				return have[0];
			}
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var price : AmountData in shopObject.prices)
			{
				if (price.currency.type == curr_)
				{
					if (wCon.getAmount(curr_).amountData.amount >= price.amount)
					{
						_buyCurr = curr_;
						_buySkill = skill_;
						
						_wasBought = true;
						
						return (_buyObj = shopController.buyShopObject(shopObject, skill_));
					}
				}
			}
			
			return null;
		}
		
		public function unlock() : void
		{
			if (canUnlock)
			{
				if (shopController.unlockShopObject(shopObject))
					dispatchEvent(new ShopClientEvent(ShopClientEvent.Unlocked));
			}
		}
		
		public function applyBuyMove(x : int, y : int) : void
		{
			if (_wasBought)
				shopController.applyBuyMove(shopObject, _buyObj, _buyCurr, x, y);
		}
		
		public function applyBuy() : void
		{
			if (_wasBought)
				shopController.applyBuy(shopObject, _buyObj, _buyCurr);
		}
		
		protected function get shopController() : ShopController
		{
			return ControllerManager.instance.getController(ControllerNames.ShopController) as ShopController;
		}
	}
}