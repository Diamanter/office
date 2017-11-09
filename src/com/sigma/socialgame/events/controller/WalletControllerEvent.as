package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.wallet.objects.WalletObject;
	import com.sigma.socialgame.model.objects.config.level.LevelData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class WalletControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "wconInited";
		public static const Started : String = "wconStarted";
		public static const Synced : String = "wconSynced";
		
		public static const AmountChanged : String = "wconAmoundChanged";
		public static const LevelChanged : String = "wconLevelChanged";
		
		private var _delta : AmountData;
		private var _amount : WalletObject;
		private var _level : LevelData;
		
		public function WalletControllerEvent(type:String)
		{
			super(type, ControllerNames.WalletController);
		}

		public function get amount():WalletObject
		{
			return _amount;
		}

		public function set amount(value:WalletObject):void
		{
			_amount = value;
		}

		public function get level():LevelData
		{
			return _level;
		}

		public function set level(value:LevelData):void
		{
			_level = value;
		}

		public function get delta():AmountData
		{
			return _delta;
		}

		public function set delta(value:AmountData):void
		{
			_delta = value;
		}


	}
}