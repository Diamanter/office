package com.sigma.socialgame.view.game
{
	import com.sigma.socialgame.common.Address;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.events.view.WorkerLimitEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.param.ParamType;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class WorkerLimit extends EventDispatcher
	{
		private var _data : XML;
		private var _limits : Object;
		
		private static var _instance : WorkerLimit;
		
		public function WorkerLimit()
		{
			_instance = this;
			_limits = new Object();
			_limits[1] = 1;
			_limits[4] = 2;
			_limits[6] = 3;
			_limits[8] = 4;
			_limits[10] = 5;
			_limits[14] = 6;
			_limits[18] = 7;
			_limits[20] = 8;
			_limits[24] = 9;
			_limits[28] = 10;
			_limits[30] = 11;
			_limits[34] = 12;
			_limits[38] = 14;
			_limits[40] = 16;
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			wCon.addEventListener(WalletControllerEvent.LevelChanged, onLevelChanged);
			
			//ResourceManager.instance.sendParam(ParamType.ReserveTask, String(this.limit(wCon.currLevel.rank)));
			
		}

		public function init() : void
		{
			/*var loader : URLLoader = new URLLoader();
			var urlreq : URLRequest = new URLRequest(Address.Limits);
			
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(urlreq);*/
		}
		
		protected function onComplete(e : Event) : void
		{
			/*_data = XML(e.target.data);
			
			_limits = new Object();
			
			for each (var limit : XML in _data.limit)
			{
				_limits[int(limit.@level)] = int(limit.@workers);
			}
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			wCon.addEventListener(WalletControllerEvent.LevelChanged, onLevelChanged);
			
			ResourceManager.instance.sendParam(ParamType.ReserveTask, String(this.limit(wCon.currLevel.rank)));
			
			dispatchEvent(new WorkerLimitEvent(WorkerLimitEvent.Inited));*/
		}
		
		protected function onLevelChanged(e : WalletControllerEvent) : void
		{
			ResourceManager.instance.sendParam(ParamType.ReserveTask, String(this.limit(e.level.rank)));
		}
		
		public function canAddWorker() : Boolean
		{
			if (limit(walletCon.currLevel.rank) > mapCon.howManyWorkers())
			{
				return true;
			}
			
			return false;
		}

		public function limit(lvl_ : int) : int
		{
			for (var i : int = lvl_; i >= 0; i--)
			{
				if (_limits[i] != null)
					return _limits[i];
			}
			
			return 0;
		}
		
		protected function get mapCon() : MapController
		{
			return ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
		}
		
		protected function get walletCon() : WalletController
		{
			return ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
		}
		
		public static function get instance() : WorkerLimit
		{
			return _instance;
		}
	}
}