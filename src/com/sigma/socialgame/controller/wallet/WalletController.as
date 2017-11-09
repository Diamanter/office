package com.sigma.socialgame.controller.wallet
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.wallet.objects.ConvertObject;
	import com.sigma.socialgame.controller.wallet.objects.MoneyObject;
	import com.sigma.socialgame.controller.wallet.objects.WalletObject;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.convert.ConvertData;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.level.LevelData;
	import com.sigma.socialgame.model.objects.config.money.MoneyData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.sound.SoundEvents;
	import com.sigma.socialgame.sound.SoundManager;
	
	public class WalletController extends Controller
	{
		public static const TAG : String = "WalletController";
		
		private var _wallet : Vector.<WalletObject>;
		
		private var _converts : Vector.<ConvertObject>;
		private var _moneys : Vector.<MoneyObject>;
		
		private var _levels : Vector.<LevelData>;
		private var _levelsDictionary : Object;
		
		private var _currLevel : LevelData;
		
		public function WalletController()
		{
			super(ControllerNames.WalletController);
		}
		
		public override function init():void
		{
			_wallet = new Vector.<WalletObject>();
			_converts = new Vector.<ConvertObject>();
			_moneys = new Vector.<MoneyObject>();
			
			dispatchEvent(new WalletControllerEvent(WalletControllerEvent.Inited));
		}
		
		public override function start() : void
		{
			Logger.message("Starting wallet controller.", TAG, LogLevel.Info, LogModule.Controller);
			
			_levels = ResourceManager.instance.levels;
			_levelsDictionary = ResourceManager.instance.levelsDictionary;
			
			for each (var convert : ConvertData in ResourceManager.instance.convert)
			{
				_converts.push(WalletFactory.createConvertObject(convert));
			}
			
			_converts.sort(function compare(left : ConvertObject, right : ConvertObject) : Number
			{
				if (left.convertData.fromCurr.amount < right.convertData.fromCurr.amount)
					return -1;
				else if (left.convertData.fromCurr.amount > right.convertData.fromCurr.amount)
					return 1;
				
				return 0;
			});
			
			for each (var money : MoneyData in ResourceManager.instance.money)
			{
				_moneys.push(WalletFactory.createMoneyObject(money));
			}
			
			_moneys.sort(function compare(left : MoneyObject, right : MoneyObject) : Number
			{
				if (left.moneyData.gold < right.moneyData.gold)
					return -1;
				else if (left.moneyData.gold > right.moneyData.gold)
					return 1;
				
				return 0;
			});
			
			for each (var amount : AmountData in ResourceManager.instance.wallet)
			{
				addWalletObject(amount);
			}
			
			calcLevel();
			
			Logger.message("Wallet controller started.", TAG, LogLevel.Info, LogModule.Controller);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.AmountChanged, onWalletSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.AmountRemoved, onWalletSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.AmountAdded, onWalletSyncEvent);
			
			dispatchEvent(new WalletControllerEvent(WalletControllerEvent.Started));
		}
		
		public function convert(convert_ : ConvertObject) : void
		{
			addAmount(convert_.convertData.fromCurr.currency.type, -convert_.convertData.fromCurr.amount);
			addAmount(convert_.convertData.toCurr.currency.type, convert_.convertData.toCurr.amount);
			
			ResourceManager.instance.convertCurr(convert_.convertData.id);
		}
		
		protected function onWalletSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			var amount : WalletObject = getAmount(e.amount.currency.type);
			var wcEvent : WalletControllerEvent;

			switch (e.type)
			{
				case ResourceSynchronizerEvent.AmountChanged:
					
					wcEvent = new WalletControllerEvent(WalletControllerEvent.AmountChanged);
					wcEvent.amount = amount;
					dispatchEvent(wcEvent);
					
					break;
				
				case ResourceSynchronizerEvent.AmountRemoved:
					
					//TODO 
					
					break;
				
				case ResourceSynchronizerEvent.AmountAdded:
					
					//TODO
					
					break;
			}
		}
		
		public function getAmount(curr_ : String) : WalletObject
		{
			for each (var amount : WalletObject in _wallet)
			{
				if (amount.amountData.currency.type == curr_)
					return amount;
			}
			
			return null;
		}
		
		public function get currLevel() : LevelData
		{
			return _currLevel;
		}
		
		public function get nextLevel() : LevelData
		{
			return _levelsDictionary[_currLevel.rank + 1];
		}
		
		private function getLevelExperience(level : LevelData) : int
		{
			if (level == null) return -1;
			
			for each (var until : AmountData in level.until)
			{
				if (until.currency.type == CurrencyType.Experience)
				{
					return until.amount;	
				}
			}
			
			return -1;
		}		
		
		public function get currentLevelExperience() : int
		{
			return getLevelExperience(_currLevel);
		}
		
		public function get nextLevelExperience() : int
		{
			return getLevelExperience(nextLevel);
		}
		
		protected function calcLevel() : void
		{
			if (_wallet.length == 0)
				return;
			
			var lastLevel : LevelData;
			
			var bigger : Boolean;
			
			for each (var level : LevelData in _levels)
			{
				bigger = true;
				
				for each (var until : AmountData in level.until)
				{
					if (getAmount(until.currency.type).amountData.amount < until.amount)
					{
						bigger = false;
					}
				}
				
				if (bigger)
				{
					if (lastLevel != null)
					{
						if (lastLevel.rank < level.rank)
							lastLevel = level;
					}
					else
						lastLevel = level;
				}
			}

			if (_currLevel != null)
			{
				if (lastLevel.rank != _currLevel.rank)
				{
					_currLevel = lastLevel;
					
					SoundManager.instance.playEvent(SoundEvents.Level);
					
					var wEvent : WalletControllerEvent = new WalletControllerEvent(WalletControllerEvent.LevelChanged);
					wEvent.level = _currLevel;
					dispatchEvent(wEvent);
				}
			}
			else
			{
				_currLevel = lastLevel;
			}
		}
		
		public function addAmount(curr_ : String, add_ : int) : void
		{
			for each (var amount : WalletObject in _wallet)
			{
				if (amount.amountData.currency.type == curr_)
				{
					amount.amountData.amount += add_;
					
					var wEvent : WalletControllerEvent = new WalletControllerEvent(WalletControllerEvent.AmountChanged);
					wEvent.amount = amount;
					
					var deltaAmount : AmountData = new AmountData();
					
					deltaAmount.currency = amount.amountData.currency;
					deltaAmount.amount = add_;
					
					wEvent.delta = deltaAmount;
					
					dispatchEvent(wEvent);
					
					calcLevel();
				}
			}
		}
		
		public function get wallet() : Vector.<WalletObject>
		{
			return _wallet;
		}
		
		protected function addWalletObject(amount : AmountData) : void
		{
			var newWO : WalletObject = WalletFactory.createWalletObject(amount);
			
			_wallet.push(newWO);
		}
		
		protected function removeWalletObject(wallObj_ : WalletObject) : void
		{
			_wallet.splice(_wallet.indexOf(wallObj_), 1);
		}

		public function get converts():Vector.<ConvertObject>
		{
			return _converts;
		}

		public function get moneys():Vector.<MoneyObject>
		{
			return _moneys;
		}


	}
}
	