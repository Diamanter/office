package com.sigma.socialgame.controller.shop
{
	import com.sigma.socialgame.common.utils.Map;
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.shop.clients.ExpandShopClient;
	import com.sigma.socialgame.controller.shop.clients.ShopClient;
	import com.sigma.socialgame.controller.shop.objects.ExpandShopObject;
	import com.sigma.socialgame.controller.shop.objects.ShopObject;
	import com.sigma.socialgame.controller.shop.objects.WorkerShopObject;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.ShopClientEvent;
	import com.sigma.socialgame.events.controller.ShopControllerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.expand.ExpandData;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.WorkerObjectData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.BuyAvailableData;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.model.objects.sync.wallet.WorkerAmountData;
	
	import flash.utils.Dictionary;
	
	public class ShopController extends Controller
	{
		public static const TAG : String = "ShopController";
		
		private var _shop : Vector.<ShopObject>;
		private var _clientToObject : Dictionary;
		
		private var _expand : Vector.<ExpandShopObject>;
		private var _clientToExpand : Dictionary;
		
		public function ShopController()
		{
			super(ControllerNames.ShopController);
		}
		
		public override function init():void
		{
			_shop = new Vector.<ShopObject>();
			
			_clientToObject = new Dictionary();
			
			_expand = new Vector.<ExpandShopObject>();
			
			_clientToExpand = new Dictionary();
			
			dispatchEvent(new ShopControllerEvent(ShopControllerEvent.Inited));
		}
		
		public override function start():void
		{
			var newSO : ShopObject;
			var newESO : ExpandShopObject;
			
			var buyable : Boolean;
			
			var workers : Vector.<WorkerShopObject> = new Vector.<WorkerShopObject>(); 
			
			for each (var object : ObjectData in ResourceManager.instance.objects)
			{
				if (object.objectId.id == "dmg1")
					buyable = true;
				
				buyable = false;
				
				for each (var avail : AvailableData in object.available)
				{
					if (avail.type == AvailableTypes.Buy)
					{
						buyable = true;
						break;
					}
				}
				
				if (!buyable)
					continue;
				
				if (object.type == ObjectTypes.Worker)
				{
					for each (var skill : SkillData in (object as WorkerObjectData).skills)
					{
						newSO = ShopFactory.createWorkerShopObject(object, skill);
						
						if (newSO != null)
						{
//							_shop.push(newSO);
							workers.push(newSO as WorkerShopObject);							
						}
					}
				}
				else
				{
					newSO = ShopFactory.createShopObject(object);
					
					if (newSO != null)
					{
						_shop.push(newSO);
					}
				}
				
			}
			
			workers = workers.sort(function (left : WorkerShopObject, right : WorkerShopObject) : int
			{
				if (left.workerObject.objectId.id == right.workerObject.objectId.id)
				{
					if (left.skill.rank > right.skill.rank)
					{
						return 1;
					}
					else
					{
						return -1;
					}
				}
				else
				{
					if (left.priceRank1.currency.type != right.priceRank1.currency.type)
					{
						if (left.priceRank1.currency.type == CurrencyType.Gold)
						{
							return 1;
						}
						else
						{
							return -1;
						}
					}
					else
					{
						if (left.priceRank1.amount > right.priceRank1.amount)
						{
							return 1;
						}
						else
						{
							return -1;
						}
					}
				}
			});
			
			_shop = _shop.concat(workers);
			for each (var expand : ExpandData in ResourceManager.instance.expands)
			{
				newESO = ShopFactory.createExpandShopObject(expand);
				_expand.push(newESO);
			}
			
			dispatchEvent(new ShopControllerEvent(ShopControllerEvent.Started));
		}
		
		public function getExpandObjectClient(expand_ : ExpandShopObject) : ExpandShopClient
		{
			if (_clientToExpand[expand_] != null)
			{
				return null;
			}
			
			var newClient : ExpandShopClient = ShopClientFactory.createExpandClient(expand_);
			
			_clientToExpand[expand_] = newClient;
			
			return newClient;
		}
		
		public function getShopObjectClient(shopObj_ : ShopObject) : ShopClient
		{
			if (_clientToObject[shopObj_] != null)
			{
				return null;
			}
			
			var newClient : ShopClient = ShopClientFactory.createClient(shopObj_);
			
			_clientToObject[shopObj_] = newClient;
			
			return newClient;
		}
		
		public function unlockExpandObject(expand_ : ExpandShopObject) : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			if (expand_.condition != null)
			{
				var cond : ConditionData = expand_.condition;
				
				if (wCon.getAmount(cond.price.currency.type).amountData.amount >= cond.price.amount)
				{
					wCon.addAmount(cond.price.currency.type, -cond.price.amount);
					
					ResourceManager.instance.addUnlockedExpand(cond.price.currency.type, expand_.expandObject);
					
					return true;
				}
			}
			
			return false;
		}
		
		public function unlockShopObject(shopObject_ : ShopObject) : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;

			if (shopObject_.prices[0] is ILockable)
			{
				var cond : ConditionData = (shopObject_.prices[0] as ILockable).condition;
			
				if (wCon.getAmount(cond.price.currency.type).amountData.amount >= cond.price.amount)
				{
					wCon.addAmount(cond.price.currency.type, -cond.price.amount);
					
					var skill : SkillData;
					
					if (shopObject_.prices[0] is WorkerAmountData)
						skill = (shopObject_ as WorkerShopObject).skill;
					
					ResourceManager.instance.addUnlockedPrice(cond.price.currency.type, shopObject_.object, skill);
					
					return true;
				}
			}
			
			return false;
		}
		
		public function getClientForStoreObject(storeObj : StoreObject) : ShopClient
		{
			for each (var so : ShopObject in _shop)
			{
				if (so.object.objectId.id == storeObj.storeObject.object.objectId.id)
				{
					return _clientToObject[so];
				}
			}
			
			return null;
		}
		
		public function buyExpandObject(expand_ : ExpandShopObject) : void
		{
			var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
	
			//TODO send expand command
			
			ResourceManager.instance.expandOffice(expand_.expandObject.id, expand_.expandObject.prices[0].currency.type);
			
//			mCon.expand(expand_.expandObject.width, expand_.expandObject.height);
		}
		
		public function buyShopObject(shopObject_ : ShopObject, skill_ : SkillData) : StoreObject
		{
			var storeCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var newSO : StoreObject = storeCon.addStoreObject(shopObject_.object, skill_);
			
			return newSO;
		}
		
		public function applyBuyMove(shopObject_ : ShopObject, storeObject_ : StoreObject, curr_ : String, x : int, y : int) : void
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var price : AmountData in shopObject_.prices)
			{
				if (price.currency.type == curr_)
				{
					wCon.addAmount(curr_, -price.amount);
				}
			}
			
//			ResourceManager.instance.buy(shopObject_.object.objectId, curr_, storeObject_.storeObject.storeId.storeId);
			if (shopObject_.object.place == ObjectPlaces.Cell)
				if (shopObject_.object.type == ObjectTypes.Worker)
					ResourceManager.instance.buyMoveCell(shopObject_.object.objectId, curr_, storeObject_.storeObject.storeId.storeId, x, y, (shopObject_ as WorkerShopObject).skill.id);
				else
					ResourceManager.instance.buyMoveCell(shopObject_.object.objectId, curr_, storeObject_.storeObject.storeId.storeId, x, y);
			else
				ResourceManager.instance.buyMoveWall(shopObject_.object.objectId, curr_, storeObject_.storeObject.storeId.storeId, y, x);
		}
		
		public function applyBuy(shopObject_ : ShopObject, storeObject_ : StoreObject, curr_ : String) : void
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var price : AmountData in shopObject_.prices)
			{
				if (price.currency.type == curr_)
				{
					wCon.addAmount(curr_, -price.amount);
				}
			}
			
			if (shopObject_.object.type == ObjectTypes.Worker)
				ResourceManager.instance.buy(shopObject_.object.objectId, curr_, storeObject_.storeObject.storeId.storeId, (shopObject_ as WorkerShopObject).skill.id);
			else
				ResourceManager.instance.buy(shopObject_.object.objectId, curr_, storeObject_.storeObject.storeId.storeId);
		}
		
		public function get shop():Vector.<ShopObject>
		{
			return _shop;
		}

		public function get expand():Vector.<ExpandShopObject>
		{
			return _expand;
		}

		
	}
}