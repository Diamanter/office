package com.sigma.socialgame.controller.gift.clients
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.controller.gift.objects.GiftObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.GiftAvailableData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.view.gui.GuiManager;

	public class GiftClient
	{
		private var _gift : GiftObject;
		
		public function GiftClient()
		{
		}
		
		public function select() : void
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var avail : AvailableData in _gift.object.available)
				if (avail.type == AvailableTypes.Gift)
					if ((avail as GiftAvailableData).price != null)
						if (wCon.getAmount((avail as GiftAvailableData).price.currency.type).amountData.amount < (avail as GiftAvailableData).price.amount)
						{
							GuiManager.instance.noMoneyWindow.visible = true;							
							return;
						}
			
			giftController.select(_gift);
		}
		
		public function get unlocked() : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			//if (wCon.currLevel.rank >= _gift.object.giftable.level)
				//return true;
			
			for each (var avail : AvailableData in _gift.object.available)
			{
				if (avail.type == AvailableTypes.Gift)
					if ((avail as GiftAvailableData).condition != null)
					{
						if (wCon.currLevel.rank >= (avail as GiftAvailableData).condition.level)
							return true;
					}
					else
						return true;
			}			

			return false;
		}
		
		public function get price() : AmountData
		{
			for each (var avail : AvailableData in _gift.object.available)
			{
				if (avail.type == AvailableTypes.Gift)
					return (avail as GiftAvailableData).price;
			}
			
			return null;
		}
	
		public function get gift():GiftObject
		{
			return _gift;
		}

		public function set gift(value:GiftObject):void
		{
			_gift = value;
		}

		private var _gCon : GiftController;
		
		protected function get giftController() : GiftController
		{
			if (_gCon == null)
				_gCon = ControllerManager.instance.getController(ControllerNames.GiftController) as GiftController;
			
			return _gCon;
		}
	}
}