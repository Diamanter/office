package com.sigma.socialgame.controller.avatar
{
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.clients.AvatarPartClient;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.AvatarControllerEvent;
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPartType;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableData;
	import com.sigma.socialgame.model.objects.config.object.available.AvailableTypes;
	import com.sigma.socialgame.model.objects.config.object.available.BuyAvailableData;
	import com.sigma.socialgame.model.objects.sync.avatar.CurrAvatarPart;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	
	import flash.utils.Dictionary;
	
	public class AvatarController extends Controller
	{
		private var _parts : Vector.<AvatarPartObject>;
		private var _currParts : Vector.<AvatarPartObject>;
		
		private var _tempParts : Vector.<AvatarPartObject>;
		private var _currAmounts : Vector.<AmountData>;
		
		private var _partsByType : Object;
		
		private var _clientsToPart : Dictionary;
		
		public function AvatarController()
		{
			super(ControllerNames.AvatarController);
		}

		public override function init():void
		{
			_parts = new Vector.<AvatarPartObject>();
			_currParts = new Vector.<AvatarPartObject>();
			
			_partsByType = new Object();
			
			_clientsToPart = new Dictionary();
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.AvatarChanged, onAvatarChanged);
			dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.Inited));
		}
		
		protected function onAvatarChanged(e : ResourceSynchronizerEvent) : void
		{
			_currParts = new Vector.<AvatarPartObject>();
			
			for each (var currpart : CurrAvatarPart in ResourceManager.instance.currAvatarParts)
			{
				_currParts.push(AvatarFactory.createAvatarPartObject(currpart.part));
			}
			
			dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.AvatarChanged));
		}
		
		public override function start():void
		{
			for each (var part : AvatarPart in ResourceManager.instance.avatarParts)
			{
				_parts.push(AvatarFactory.createAvatarPartObject(part));
			}

			var types : Array = [AvatarPartType.Body, AvatarPartType.Boots, AvatarPartType.Head, AvatarPartType.Eyes, AvatarPartType.Hair, AvatarPartType.Legs];
			
			for each (var type : String in types)
			{
				_partsByType[type] = new Vector.<AvatarPartObject>();
			}
			
			for each (var partObj : AvatarPartObject in _parts)
			{
				_partsByType[partObj.part.type].push(partObj);
			}
			
			for each (var currpart : CurrAvatarPart in ResourceManager.instance.currAvatarParts)
			{
				_currParts.push(AvatarFactory.createAvatarPartObject(currpart.part));
			}
			
			dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.Started));
		}
		
		public function wasBought(part_ : AvatarPartObject) : Boolean
		{
			for each (var part : CurrAvatarPart in ResourceManager.instance.boughtAvatarParts)
			{
				if (part.part.id == part_.part.id)
					return true;
			}
			
			return false;
		}

		public function partsByType(type_ : String) : Vector.<AvatarPartObject>
		{
			return _partsByType[type_];
		}
		
		public function currPartByType(type_ : String) : AvatarPartObject
		{
			for each (var currPart : AvatarPartObject in _currParts)
			{
				if (currPart.part.type == type_)
					return currPart;
			}
			
			return null;
		}
		
		public function getClient(part_ : AvatarPartObject) : AvatarPartClient
		{
			if (_clientsToPart[part_] != null)
				return null;
			
			var newClient : AvatarPartClient = AvatarFactory.createAvatarPartClient(part_);
			
			_clientsToPart[part_] = newClient;
			
			return newClient; 
		}
		
		public function startFitting() : void
		{
			_tempParts = _currParts.slice();
			_currAmounts = new Vector.<AmountData>();
			
			dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.StartFitting));
		}
		
		public function cancelFitting() : void
		{
			if (_tempParts != null)
				_currParts = _tempParts.slice();
			
			dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.CancelFitting));
		}
		
		public function canBuy() : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var amount : AmountData in _currAmounts)
			{
				if (wCon.getAmount(amount.currency.type).amountData.amount < amount.amount)
					return false;
			}
			
			return true;
		}
		
		public function applyFitting() : void
		{
			if (!canBuy())
			{
				_currParts = _tempParts.slice();
				
				dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.CancelFitting));
				
				return;
			}
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var amount : AmountData in _currAmounts)
			{
				wCon.addAmount(amount.currency.type, -amount.amount);
			}
			
			//sendcomands
			
			var types : Array = [AvatarPartType.Body,
								 AvatarPartType.Boots,
								 AvatarPartType.Head,
								 AvatarPartType.Eyes,
								 AvatarPartType.Hair,
								 AvatarPartType.Legs,
								];
			
			var oldpart : AvatarPartObject;
			var newpart : AvatarPartObject;
			
			var part : AvatarPartObject;
			
			for each (var type : String in types)
			{
				for each (part in _currParts)
				{
					if (part.part.type == type)
					{
						newpart = part;
						
						break;
					}
				}
				
				for each (part in _tempParts)
				{
					if (part.part.type == type)
					{
						oldpart = part;
						
						break;
					}
				}
				
				if (oldpart.part.id != newpart.part.id)
					ResourceManager.instance.avatarPart(newpart.part.id);
			}
			
			dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.AvatarChanged));
		}
		
		public function fitPart(part_ : AvatarPartObject) : void
		{
			var ind : int;
			
			for (var i : int = 0; i < _currParts.length; i++)
			{
				if (_currParts[i].part.type == part_.part.type)
				{
					ind = i;
					
					break;
				}
			}
			
			if (_currParts[i].part.id == part_.part.id)
				return;
			
			_currParts[i] = part_;
			
			var acEvent : AvatarControllerEvent = new AvatarControllerEvent(AvatarControllerEvent.FitPartChanged);
			acEvent.part = part_;
			dispatchEvent(acEvent);
			
			checkAmounts();
		}
		
		protected function checkAmounts() : void
		{
			var newAmounts : Vector.<AmountData> = makeAmounts();
			
			if (_currAmounts == null)
			{
				_currAmounts = newAmounts;
				
				dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.AmountChanged));
				
				return;
			}
			
			var found : Boolean;
			var diff : Boolean = false;
			
			var newamount : AmountData;
			var oldamount : AmountData;
			
			for each (newamount in newAmounts)
			{
				found = false;
				
				for each (oldamount in _currAmounts)
				{
					if (newamount.currency.type == oldamount.currency.type)
					{
						found = true;
						
						if (newamount.amount != oldamount.amount)
							diff = true;
						
						break;
					}
				}
				
				if (!found)
					diff = true;
			}
			
			for each (oldamount in _currAmounts)
			{
				found = false;
				
				for each (newamount in newAmounts)
				{
					if (oldamount.currency.type == newamount.currency.type)
					{
						found = true;
						
						break;
					}
				}
				
				if (!found)
					diff = true;
			}

			_currAmounts = newAmounts;
			
			if (diff)
			{
				dispatchEvent(new AvatarControllerEvent(AvatarControllerEvent.AmountChanged));
			}
		}

		protected function makeAmounts() : Vector.<AmountData>
		{
			var newAmount : Vector.<AmountData> = new Vector.<AmountData>();
			
			var found : Boolean;
			
			var diff : Boolean = false;
			
			for each (var newpart : AvatarPartObject in _currParts)
			{
				found = false;
				
				if (wasBought(newpart))
					continue;	
				
				for each (var oldpart : AvatarPartObject in _tempParts)
				{
					if (oldpart.part.id == newpart.part.id)
					{
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					for each (var avail : AvailableData in newpart.part.availables)
					{
						if (avail.type == AvailableTypes.Buy)
						{
							for each (var price : AmountData in (avail as BuyAvailableData).prices)
							{
								found = false;
								
								for each (var amount : AmountData in newAmount)
								{
									if (price.currency.type == amount.currency.type)
									{
										amount.amount += price.amount;
										
										found  = true;
										
										break;
									}
								}
								
								if (!found)
								{
									var newAm : AmountData = new AmountData();
									
									newAm.currency = price.currency;
									newAm.amount = price.amount;
									
									newAmount.push(newAm);
								}
							}
						}
					}
				}
			}
			
			return newAmount; 
		}
		
		public function get currAmounts() : Vector.<AmountData>
		{
			return _currAmounts;
		}
		
		public function get parts():Vector.<AvatarPartObject>
		{
			return _parts;
		}

		public function get currParts():Vector.<AvatarPartObject>
		{
			return _currParts;
		}


	}
}