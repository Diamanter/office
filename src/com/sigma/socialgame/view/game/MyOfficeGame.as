package com.sigma.socialgame.view.game
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.quest.QuestController;
	import com.sigma.socialgame.events.controller.ControllerManagerEvent;
	import com.sigma.socialgame.events.model.ResourceManagerEvent;
	import com.sigma.socialgame.events.model.social.SocialNetworkEvent;
	import com.sigma.socialgame.events.sound.SoundManagerEvent;
	import com.sigma.socialgame.events.view.WorkerLimitEvent;
	import com.sigma.socialgame.events.view.gui.GuiManagerEvent;
	import com.sigma.socialgame.events.view.gui.HelpManagerEvent;
	import com.sigma.socialgame.events.view.gui.SkinManagerEvent;
	import com.sigma.socialgame.events.view.gui.StringManagerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.model.param.QualityState;
	import com.sigma.socialgame.model.social.SocialNetwork;
	import com.sigma.socialgame.sound.SoundManager;
	import com.sigma.socialgame.view.console.Console;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.WorkerLimit;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
//	import com.sigma.socialgame.view.gui.components.SimplePbar;
	import com.sigma.socialgame.view.gui.components.help.HelpManager;
	import com.sigma.socialgame.view.gui.components.xmltest.XmlTestWindow;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.StarlingRoot;
	
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	import flash.events.UncaughtErrorEvent;
	import starling.core.Starling;
	import starling.filters.*;
	
	import mx.logging.Log;
	import mx.core.Singleton;
	
	public class MyOfficeGame extends Sprite
	{
		private var _resManager : ResourceManager;
		private var _conManager : ControllerManager;
		
		private var _stringManager : StringManager;
		private var _helpManager : HelpManager;
		private var _skinManager : SkinManager;
		private var _guiManager : GuiManager;
		
		private var _soundManager : SoundManager;
		private var _limits : WorkerLimit;
		
		private var _field : Field;
		
		private var _socNetwork : SocialNetwork;
		
		private static var _instance : MyOfficeGame;
		
		/*[Embed(source="../data/build/LoadDarker.swf")]
		private var _loadDarker : Class;
		private var _loadDrk : MovieClip;
		
		[Embed(source="../data/build/LoadImage.swf")]
		private var _loadImage : Class;
		private var _loadImg : MovieClip;
		
		[Embed(source="../data/build/ServerIsDown.swf")]
		private var _loadServer : Class;
		private var _loadSrv : MovieClip;*/
		
//		private var _pbar : SimplePbar;
		
		private var _viewport:flash.geom.Rectangle;
		private var _starling : Starling;
		
		public const isIOS:Boolean = (Capabilities.manufacturer.indexOf("iOS") != -1);
		public const isAndroid:Boolean = (Capabilities.manufacturer.indexOf("Android") != -1);
		public const isMobile:Boolean = isIOS || isAndroid;
		public var parameters:Object;
		public var isLocal:Boolean;
		public var serverPath:String;
		public var versionAssets:String;
		
		public var loader:MovieClip;
		public var loaded:Boolean= false;
		
		public var fadeFilter:FragmentFilter;
		
/*		[Embed(source="../data/build/LoadScreen.swf")]
		private var _loadScreen : Class;
		private var _loadScr : MovieClip;
*/		
		public function MyOfficeGame()
		{			

//			scaleX = 0.94; //760
//			scaleY = 0.94; //686
			
			//Security.allowInsecureDomain("http://wildfly.java-dev.rwsib.ru");
			Security.loadPolicyFile("http://tomcat.java-dev.rwsib.ru/crossdomain.xml");
//			Logger.logging = false;
			
			//_loadSrv = new _loadServer();
			
			/*_loadDrk = new _loadDarker();
			addChild(_loadDrk);
			
			_loadImg = new _loadImage();
			addChild(_loadImg);*/
			
			//_pbar = new SimplePbar();
			//addChild(_pbar);
//			_loadScr = new _loadScreen();
//			addChild(_loadScr);
			
			if (stage)
				init(null)
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		protected function init(e : Event) : void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (parent && parent.parent) loader = parent.parent as MovieClip;
			stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleGlobalErrors);
			
			parameters = loader ? loader.loaderInfo.parameters : loaderInfo.parameters;
			versionAssets = parameters.vAssets || "";
			serverPath = parameters.server;
			isLocal = (loader ? loader.loaderInfo.url : loaderInfo.url).indexOf("app:") != -1;
			
			Logger.priority = LogLevel.Info;
			
			_instance = this;
			
			var con : Console = new Console();
			
			addChild(con);
			
			con.height = 300;
			con.width = 807;
			
			con.x = 0;
			con.y = 430;
			
			//_socNetwork = new SocialNetwork(stage, SocialNetwork.Odnoklassniki);
			
			if (!isLocal) _socNetwork = new SocialNetwork(stage, SocialNetwork.Facebook);
			else _socNetwork = new SocialNetwork(stage, "Null");
			
			//stage.quality = StageQuality.LOW;
			
			_resManager = new ResourceManager();
			_conManager = new ControllerManager();
			_field = new Field();
			_skinManager = new SkinManager();
			_stringManager = new StringManager();
			_helpManager = new HelpManager();
			_guiManager = new GuiManager();
			_soundManager = new SoundManager();
			_limits = new WorkerLimit();
			
			//_helpManager.addEventListener(HelpManagerEvent.Inited, onHelpLoaded);
			_skinManager.addEventListener(SkinManagerEvent.SkinsLoaded, onSkinsLoaded)
			_conManager.addEventListener(ControllerManagerEvent.ControllersStarted, onControllersStarted);
			_conManager.addEventListener(ControllerManagerEvent.ControllersReloaded, onControllersReloaded);
			_soundManager.addEventListener(SoundManagerEvent.SoundManagerInited, onSoundsLoaded);
			//_limits.addEventListener(WorkerLimitEvent.Inited, onLimitsInited)
			
			_conManager.init();
			_resManager.init();
	
			_resManager.addEventListener(ResourceManagerEvent.Reloading, onReloading);
			
			_socNetwork.addEventListener(SocialNetworkEvent.MeLoaded, onMe);
			_socNetwork.loadMe();
			//_viewport = new flash.geom.Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			_viewport = new flash.geom.Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			_starling = new Starling(StarlingRoot, stage, _viewport, null, "auto", "auto");
			
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			_starling.antiAliasing = 2;
			
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function (e:Event):void {
				_starling.start();
				 fadeFilter = new ToyBlockFilter();//new GlassFilter(0.9, 200);
			});
			
			/*_loadDrk.scaleX = 1.0;
			_loadDrk.scaleY = 1.0;
			
			var wsc : Number = dim.x / _loadDrk.width;
			var hsc : Number = dim.y / _loadDrk.height;
			
			var resK : Number = wsc > hsc ? wsc : hsc;
			
			if (wsc < 1.0 || hsc < 1.0)
			{
				resK = 1 / resK;
			}
			
			_loadDrk.scaleX = resK;
			_loadDrk.scaleY = resK;
			
			_loadDrk.x = (dim.x - _loadDrk.width) / 2 - _loadDrk.width;
			_loadDrk.y = (dim.y - _loadDrk.height) / 2 - _loadDrk.height;
			
			_loadImg.x = dim.x / 2;
			_loadImg.y = dim.y / 2;*/
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
		}
		
		public function handleGlobalErrors(e:Object) : void 
		{
			trace(e);
			trace(e.error.getStackTrace());
		}
		
		protected function onReloading(e : ResourceManagerEvent) : void
		{
			trace("reloading")
			//addChild(_loadDrk);
			
			//_back.width = dim.x;
			//_back.height = dim.y;
			
			/*_loadDrk.scaleX = 1.0;
			_loadDrk.scaleY = 1.0;
			
			var wsc : Number = dim.x / _loadDrk.width;
			var hsc : Number = dim.y / _loadDrk.height;
			
			var resK : Number = wsxwsCXWAXCWc > hsc ? wsc : hsc;
			
			if (wsc < 1.0 || hsc < 1.0)
			{
				resK = 1 / resK;
			}
			
			_loadDrk.scaleX = resK;
			_loadDrk.scaleY = resK;
			
			_loadDrk.x = (dim.x - _loadDrk.width) / 2;
			_loadDrk.y = (dim.y - _loadDrk.height) / 2;*/
			
//			_back.x = -_back.width / 2;
//			_back.y = -_back.height / 2;
			
			//addChild(_loadImg);
	
			//_loadImg.x = dim.x / 2;
			//_loadImg.y = dim.y / 2;
		}
		
		protected function onMe(e : SocialNetworkEvent) : void
		{
			progress = 0.1;
			
			_socNetwork.addEventListener(SocialNetworkEvent.AppFriendsLoaded, onAppFriends);
			_socNetwork.loadAppFriends();
		}
		
		protected function onUserId(e : ContextMenuEvent) : void
		{
			GuiManager.instance.showAlert("User Id", "User Id: " + _socNetwork.me.uid);
		}
		
		protected function onAppFriends(e : SocialNetworkEvent) : void
		{
			progress = 0.3;
			
			_resManager.startGame();
			
/*			progress = 0.2;
			
			_socNetwork.addEventListener(SocialNetworkEvent.FriendsLoaded, onFriends);
			_socNetwork.loadFriends();
*/		}
		
		/*protected function onFriends(e : SocialNetworkEvent) : void
		{
			progress = 0.3;
			
			_resManager.startGame();
		}*/
		
		protected function onControllersStarted(e : ControllerManagerEvent) : void
		{
			progress = 0.4;
			
			trace("Initind sounds");
			
			/*if (ParamManager.instance.getSyncParam(ParamType.QualityState) == QualityState.Low)
				stage.quality = StageQuality.MEDIUM;
			else
				stage.quality = StageQuality.LOW;
			*/
			_soundManager.init();
		}
			
		protected function onSoundsLoaded(e : SoundManagerEvent) : void
		{
			progress = 0.5;
			
			trace("SoundsLoaded");
			trace("Initing Help");
			
			_skinManager.init();
			//_helpManager.init();
		}
		
		public function serverError() : void
		{
			if (loader) {
				loader_mc.visible = false;
				server_mc.y = 0;
				server_mc.visible = true;
				loader.setChildIndex(server_mc, parent.numChildren);
			}
			if (Starling.current && Starling.current.root) Starling.current.root.touchable = false;
		}
		
		protected function onControllersReloaded(e : ControllerManagerEvent) : void
		{
			_field.reload();
			_guiManager.myOffice(_resManager.myOffice);
			
			//removeChild(_loadDrk);
			//removeChild(_loadImg);
		}
		
		/*protected function onHelpLoaded(e : HelpManagerEvent) : void
		{
			progress = 0.6;
			
			trace("Help loaded");
			trace("Initng strings");

			_limits.init();
		}
		
		protected function onLimitsInited(e : WorkerLimitEvent) : void
		{
			progress = 0.7;
			
			trace("Limits loaded");
			trace("Initing skins");
			
			_skinManager.init();
		}*/
		
		//private var _back : MovieClip;
		//private var _loadScrBack : MovieClip;
		//private var _scrAsp : Number;
		
		protected function onSkinsLoaded(e : SkinManagerEvent) : void
		{
			progress = 1.0;
			
			trace("Skins loaded");
			
			_stringManager.init(_socNetwork.me.language);

			(Starling.current.root as StarlingRoot).addChild(_field);
			addChild(_guiManager);
			
			_guiManager.addEventListener(GuiManagerEvent.Inited, guiInited);
			_guiManager.init();
		}
		
		protected function guiInited(e : GuiManagerEvent) : void
		{
/*			var my_menu : ContextMenu = new ContextMenu();
			
			var myid : ContextMenuItem = new ContextMenuItem("user id");
			myid.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onUserId);
			
			my_menu.customItems.push(myid);
			
			contextMenu = my_menu;
*/			
			_field.init();
			
			_guiManager.mapInited();
			
//			removeChild(_loadScr);
//			removeChild(_loadDrk);
//			removeChild(_loadImg);
//			removeChild(_pbar);
			if (loader) loader_mc.visible = false;
			guiStart();
		}
		
		protected function guiStart() : void
		{
			if (server_mc) server_mc.visible = false;
			if (back_mc) back_mc.visible = false;
			//x = Starling.current.stage.stageWidth/2 - 807/2;
			//y = 20;
			loaded = true;
			
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).checkLock();
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).checkDone();
			_guiManager.checkGifts();
		}
		
		private var _qual : int = 0;
		
		private var _xmlTest : XmlTestWindow;
		
		private var quals : Array = [StageQuality.BEST, StageQuality.HIGH, StageQuality.MEDIUM, StageQuality.LOW];
			
		protected function onKeydown(e : KeyboardEvent) : void
		{
			if (e.charCode == 's'.charCodeAt())
			{
				_resManager.syncGame(true);
				
				var was : Boolean = Logger.logging;
				Logger.logging = true;
				Logger.message(_resManager.toSyncString(), "", LogLevel.Debug, LogModule.Model);
				Logger.message(ControllerManager.instance.getController(ControllerNames.MapController).toString(), "", LogLevel.Debug, LogModule.Controller);
				//Logger.logging = was;
			} 
			else if (e.charCode == 'q'.charCodeAt())
			{
				_qual = (_qual + 1) % 4;
				
				stage.quality = quals[_qual];
			}
			
			else if (e.charCode == 'f'.charCodeAt() && e.ctrlKey)
			{
				if (stage.displayState == StageDisplayState.NORMAL)  
					stage.displayState = StageDisplayState.FULL_SCREEN;
				else 
					stage.displayState = StageDisplayState.NORMAL;					
			}
			
/*			if (e.charCode == 't'.charCodeAt())
			{
				if (_xmlTest == null)
					_xmlTest = new XmlTestWindow();

				try
				{
					getChildIndex(_xmlTest);	
				}
				catch (e : ArgumentError)
				{
					addChild(_xmlTest);
				}
			}
*/		}
		
		public function get dimNormal() : Point
		{
			return new Point(810, 730);
		}
		
		public function get dim() : Point
		{
			if (stage.displayState != StageDisplayState.NORMAL)
			{
				return new Point(stage.fullScreenWidth / root.scaleX, stage.fullScreenHeight / root.scaleY);
			}
			else
			{
				return new Point(stage.stageWidth, stage.stageHeight);
				//return new Point(810, 730);
			}
		}
		
		public function set fade(filter:FragmentFilter) : void
		{
			filter ? Map.instance.flatten() : Map.instance.unflatten();
			Starling.current.root.touchable = filter==null;
			Starling.current.root.filter = filter;
		}
		
		private var _progress:Number = 0;
		public function get progress() : Number
		{
			return _progress;
		}
		public function set progress(val_:Number) : void
		{
			_progress = val_;
			if (!loader) return;
			loader_mc.bar.scaleX = val_;
			loader_mc.Text.text = String(val_ * 100) + "%";
		}
		
		public function get loader_mc() : MovieClip
		{
			if (loader) return loader.loader_mc;
			else return null;
		}
		
		public function get back_mc() : MovieClip
		{
			if (loader) return loader.back_mc;
			else return null;
		}
		
		public function get server_mc() : MovieClip
		{
			if (loader) return loader.server_mc;
			else return null;
		}
		
		public static function get instance() : MyOfficeGame
		{
			return _instance;
		}
	}
}