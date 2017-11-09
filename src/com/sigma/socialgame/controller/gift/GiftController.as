package com.sigma.socialgame.controller.gift
{
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	import com.sigma.socialgame.controller.gift.clients.GiftClient;
	import com.sigma.socialgame.controller.gift.objects.CurrGiftObject;
	import com.sigma.socialgame.controller.gift.objects.GiftObject;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.events.controller.GiftControllerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.sync.gift.GiftData;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.GiftAvailableData;
	
	import flash.utils.Dictionary;
	
	public class GiftController extends Controller
	{
		private var _giftable : Vector.<GiftObject>;
		
		private var _selected : GiftObject;
		
		private var _clientToGift : Dictionary;
		
		private var _currGifts : Vector.<CurrGiftObject>;
		
		public function GiftController()
		{
			super(ControllerNames.GiftController);
		}
		
		public function get giftable():Vector.<GiftObject>
		{
			return _giftable;
		}

		public override function init():void
		{
			_giftable = new Vector.<GiftObject>();
			_currGifts = new Vector.<CurrGiftObject>();
			
			_clientToGift = new Dictionary();
			
			dispatchEvent(new GiftControllerEvent(GiftControllerEvent.Inited));
		}
		
		public override function start():void
		{
			for each (var od : ObjectData in ResourceManager.instance.objects)
			{
				//if (od.giftable != null)
				//	_giftable.push(GiftFactory.createGift(od));
				
				for each (var avail : AvailableData in od.available)
					if (avail.type == AvailableTypes.Gift)
						_giftable.push(GiftFactory.createGift(od));
			}
			
			for each (var gd : GiftData in ResourceManager.instance.gifts)
			{
				_currGifts.push(GiftFactory.createCurrGift(gd));
			}
			
			dispatchEvent(new GiftControllerEvent(GiftControllerEvent.Started));
		}
		
		public function select(go_ : GiftObject) : void
		{
			if (go_ == null) return;
			
			_selected = go_;
			
			var event : GiftControllerEvent  = new GiftControllerEvent(GiftControllerEvent.Selected);
			event.selected = _selected;
			dispatchEvent(event);
		}
		
		public function unselect() : void
		{
			_selected = null;
			
			dispatchEvent(new GiftControllerEvent(GiftControllerEvent.Unselected));
		}
		
		public function sendGift() : void
		{
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			var curr : String = "";
			
			for each (var fo : FriendObject in fCon.selected)
			{
				fo.friend.gifts++;
				//ResourceManager.instance.sendGift(fo.socFriend.uid, _selected.object.objectId);
				for each (var avail : AvailableData in _selected.object.available)
				{
					if (avail.type == AvailableTypes.Gift)
						if ((avail as GiftAvailableData).price != null)
						{
							curr = (avail as GiftAvailableData).price.currency.type;
							wCon.addAmount((avail as GiftAvailableData).price.currency.type, -(avail as GiftAvailableData).price.amount);
						}
				}
				
				ResourceManager.instance.sendGift(fo.socFriend.uid, _selected.object.objectId, curr);			}
		}
		
		public function getClient(go_ : GiftObject) : GiftClient
		{
			if (_clientToGift[go_] != null)
				return null;
			
			var newGC : GiftClient = GiftFactory.createGiftClient(go_);
			
			_clientToGift[go_] = newGC;
			
			return newGC;
		}
		
		public function confirmGifts() : void
		{
			var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			for each (var currGift : CurrGiftObject in currGifts)
			{
				ResourceManager.instance.confirmGift(currGift.gift.id, sCon.addStoreObject(currGift.gift.obejct).storeObject.storeId.storeId); 
			}
		}
		
		public function removeClient(go_ : GiftObject) : void
		{
			if (_clientToGift[go_] != null)
				delete _clientToGift[go_];
		}

		public function get currGifts():Vector.<CurrGiftObject>
		{
			return _currGifts;
		}

	}
}