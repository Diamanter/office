package com.sigma.socialgame.controller
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.avatar.AvatarController;
	import com.sigma.socialgame.controller.entity.EntityController;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.quest.QuestController;
	import com.sigma.socialgame.controller.sell.SellController;
	import com.sigma.socialgame.controller.shop.ShopController;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.AvatarControllerEvent;
	import com.sigma.socialgame.events.controller.ControllerEvent;
	import com.sigma.socialgame.events.controller.ControllerManagerEvent;
	import com.sigma.socialgame.events.controller.EntityControllerEvent;
	import com.sigma.socialgame.events.controller.FriendsControllerEvent;
	import com.sigma.socialgame.events.controller.GiftControllerEvent;
	import com.sigma.socialgame.events.controller.MapControllerEvent;
	import com.sigma.socialgame.events.controller.QuestControllerEvent;
	import com.sigma.socialgame.events.controller.SellControllerEvent;
	import com.sigma.socialgame.events.controller.ShopControllerEvent;
	import com.sigma.socialgame.events.controller.StoreControllerEvent;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.events.model.ResourceManagerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	
	import flash.events.EventDispatcher;

	public class ControllerManager extends EventDispatcher
	{
		private var _controllers : Vector.<Controller>;
		private var _controllerIndMap : Object;
		
		private var _inited : int;
		private var _started : int;
		private var _synced : int;
		
		private var _eventDisp : EventDispatcher;
		
		private static var _instance : ControllerManager;
		
		public function ControllerManager()
		{
			super();
			
			_eventDisp = new EventDispatcher();
			
			_instance = this;
			
			_controllers = new Vector.<Controller>();
			_controllerIndMap = new Object();
			
			Logger.message("Creating controllers.", "ControllerManager", LogLevel.Info, LogModule.Controller);
			
			_controllers.push(new StoreController());
			_controllers.push(new EntityController());
			_controllers.push(new MapController());
			_controllers.push(new WalletController());
			_controllers.push(new ShopController());
			_controllers.push(new SellController());
			_controllers.push(new FriendsContoller());
			_controllers.push(new AvatarController());
			_controllers.push(new GiftController());
			_controllers.push(new QuestController());
			
			_controllerIndMap[ControllerNames.StoreController] = 0;
			_controllerIndMap[ControllerNames.EntityConrtoller] = 1;
			_controllerIndMap[ControllerNames.MapController] = 2;
			_controllerIndMap[ControllerNames.WalletController] = 3;
			_controllerIndMap[ControllerNames.ShopController] = 4;
			_controllerIndMap[ControllerNames.SellController] = 5;
			_controllerIndMap[ControllerNames.FriendsController] = 6;
			_controllerIndMap[ControllerNames.AvatarController] = 7;
			_controllerIndMap[ControllerNames.GiftController] = 8;
			_controllerIndMap[ControllerNames.QuestController] = 9;
			
			_controllers[_controllerIndMap[ControllerNames.MapController]].addEventListener(MapControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.EntityConrtoller]].addEventListener(EntityControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.StoreController]].addEventListener(StoreControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.WalletController]].addEventListener(WalletControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.ShopController]].addEventListener(ShopControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.SellController]].addEventListener(SellControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.FriendsController]].addEventListener(FriendsControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.AvatarController]].addEventListener(AvatarControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.GiftController]].addEventListener(GiftControllerEvent.Inited, onControllerInited);
			_controllers[_controllerIndMap[ControllerNames.QuestController]].addEventListener(QuestControllerEvent.Inited, onControllerInited);
			
			_controllers[_controllerIndMap[ControllerNames.MapController]].addEventListener(MapControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.EntityConrtoller]].addEventListener(EntityControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.StoreController]].addEventListener(StoreControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.WalletController]].addEventListener(WalletControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.ShopController]].addEventListener(ShopControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.SellController]].addEventListener(SellControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.FriendsController]].addEventListener(FriendsControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.AvatarController]].addEventListener(AvatarControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.GiftController]].addEventListener(GiftControllerEvent.Started, onControllerStarted);
			_controllers[_controllerIndMap[ControllerNames.QuestController]].addEventListener(QuestControllerEvent.Started, onControllerStarted);
			
			ResourceManager.instance.addEventListener(ResourceManagerEvent.Started, onStart);
			ResourceManager.instance.addEventListener(ResourceManagerEvent.Reload, onReload);
			
			Logger.message("Controllers created.", "ControllerManager", LogLevel.Info, LogModule.Controller);
		}
		
		protected function onReload(e : ResourceManagerEvent) : void
		{
			for each (var con : Controller in _controllers)
			{
				con.reload();
			}
			
			dispatchEvent(new ControllerManagerEvent(ControllerManagerEvent.ControllersReloaded));
		}
		
		protected function onStart(e : ResourceManagerEvent) : void
		{
			Logger.message("Starting controllers.", "ControllerManager", LogLevel.Info, LogModule.Controller);
			
			_started = 0;
			
			for each (var con : Controller in _controllers)
			{
				//Logger.message(con.name, "", LogLevel.Info, LogModule.Controller);
				con.start();
			}
		}
		
		public function getController(name_ : String) : Controller
		{
			return _controllers[_controllerIndMap[name_]];
		}
		
		public function init() : void
		{
			Logger.message("Initing controllers.", "ControllerManager", LogLevel.Info, LogModule.Controller);
			
			_inited = 0;
			
			for each (var con : Controller in _controllers)
			{
				//Logger.message(con.name, "", LogLevel.Info, LogModule.Controller);
				con.init();
			}
		}
		
		protected function onControllerInited(e : ControllerEvent) : void
		{
			//Logger.message("Controller inited: " + e.controllerName, "ControllerManager", LogLevel.Info, LogModule.Controller);
			
			_inited++;
			
			if (_inited == _controllers.length)
			{
				//Logger.message("Controllers inited.", "ControllerManager", LogLevel.Info, LogModule.Controller);
				
				dispatchEvent(new ControllerManagerEvent(ControllerManagerEvent.ControllersInited));
			}
		}
		
		protected function onControllerStarted(e : ControllerEvent) : void
		{
			//Logger.message("Controller started: " + e.controllerName, "ControllerManager", LogLevel.Info, LogModule.Controller);
			
			_started++;
			
			if (_started == _controllers.length)
			{
				//Logger.message("Controllers started.", "ControllerManager", LogLevel.Info, LogModule.Controller);
				
				dispatchEvent(new ControllerManagerEvent(ControllerManagerEvent.ControllersStarted));
			}
		}
		
		public function get eventDisp() : EventDispatcher
		{
			return _eventDisp;
		}
		
		public static function get instance() : ControllerManager
		{
			return _instance;
		}
	}
}