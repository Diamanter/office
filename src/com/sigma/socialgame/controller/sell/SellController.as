package com.sigma.socialgame.controller.sell
{
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.facade.MapEntityFacade;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.SellControllerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.SellAvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.WorkerSellAvailableData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	
	public class SellController extends Controller
	{
		public function SellController()
		{
			super(ControllerNames.SellController);
		}

		public override function init():void
		{
			dispatchEvent(new SellControllerEvent(SellControllerEvent.Inited));
		}
		
		public override function start():void
		{
			dispatchEvent(new SellControllerEvent(SellControllerEvent.Started));
		}
		
		public function sell(storeObject_ : StoreObjectData) : void
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var curr : String;
			
			for each (var avail : AvailableData in storeObject_.object.available)
			{
				if (avail.type == AvailableTypes.Sell)
				{
					if (storeObject_.object.type == ObjectTypes.Worker)
					{
						var wSellAval : WorkerSellAvailableData = avail as WorkerSellAvailableData;
						var price : AmountData = wSellAval.getSkillPrice((storeObject_ as WorkerStoreObjectData).currSkill.id);
						
						curr = price.currency.type;
						
						wCon.addAmount(price.currency.type, price.amount);
					}
					else
					{
						var sellAvail : SellAvailableData = avail as SellAvailableData;
						
						curr = sellAvail.prices[0].currency.type;
						
						wCon.addAmount(sellAvail.prices[0].currency.type, sellAvail.prices[0].amount);
					}
				}
			}

			MapEntityFacade.removeToStore(storeObject_);
			sCon.removeStoreObjectByData(storeObject_);
			
			//TODO remove from Resource
			
			ResourceManager.instance.sell(storeObject_.storeId, curr);
		}
	}
}