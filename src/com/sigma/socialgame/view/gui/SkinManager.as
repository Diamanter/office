package com.sigma.socialgame.view.gui
{
	import com.sigma.socialgame.common.Address;
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.view.gui.SkinManagerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.view.game.MyOfficeGame;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import starling.utils.AssetManager;
	import starling.textures.Texture;
	
	public class SkinManager extends EventDispatcher
	{
		public static const TAG : String = "SkinManager";
		
		private static var _instance : SkinManager;
		
		private var _skins : Loader;
		private var _questSkins : Loader;
		private var _assets : AssetManager;
		
		public function SkinManager()
		{
			super();
			
			_instance = this;
		}
		
		public function init() : void
		{
			_assets = new AssetManager();
			_assets.verbose = false;
			var vAssets:String = MyOfficeGame.instance.versionAssets;
			var vFonts:String = "2";
			var vLocals:String = "3";
			var path:String = (MyOfficeGame.instance.isLocal && !MyOfficeGame.instance.isMobile) ? "C:/Users/Denis/Drive/work/office/data/assets/" : "assets/";
			_assets.enqueue(path + "Background.png");
			_assets.enqueue(path + "locale/ru_RU.xml?v="+vLocals);
			_assets.enqueue(path + "locale/en_US.xml?v="+vLocals);
			_assets.enqueue(path + "personal.xml?v="+vAssets);
			_assets.enqueue(path + "personal.atf?v="+vAssets);
			_assets.enqueue(path + "avatar.xml?v="+vAssets);
			_assets.enqueue(path + "avatar.atf?v="+vAssets);
			_assets.enqueue(path + "basic.xml?v="+vAssets);
			_assets.enqueue(path + "basic.atf?v="+vAssets);
			_assets.enqueue(path + "workers.xml?v="+vAssets);
			_assets.enqueue(path + "workers.atf?v="+vAssets);
			_assets.enqueue(path + "skin.xml?v="+vAssets);
			_assets.enqueue(path + "skin.atf?v="+vAssets);
			_assets.enqueue(path + "imp.fnt?v="+vFonts);
			_assets.enqueue(path + "imp2.fnt?v="+vFonts);
			_assets.enqueue(path + "ver.fnt?v="+vFonts);
			_assets.enqueue(path + "ver2.fnt?v="+vFonts);
			_assets.loadQueue(function(ratio:Number):void {
				if (ratio>0.8 && MyOfficeGame.instance.progress<0.8) MyOfficeGame.instance.progress = 0.8;
				else if (ratio>0.6 && MyOfficeGame.instance.progress<0.7) MyOfficeGame.instance.progress = 0.7;
				else if (ratio>0.1 && MyOfficeGame.instance.progress<0.6) MyOfficeGame.instance.progress = 0.6;
				if (ratio==1.0) {
					dispatchEvent(new SkinManagerEvent(SkinManagerEvent.SkinsLoaded));
					//trace(_assets.getTextureNames());
				}
			});
			
			_skins = new Loader();
			_questSkins = new Loader();
			
			var urlreq : URLRequest = new URLRequest(Address.Skin);
			
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			_skins.contentLoaderInfo.addEventListener(Event.INIT, onSkinsComplete);
			//_skins.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_skins.load(urlreq, context);
		}
		
		protected function onQuestSkinsComplete(e : Event) : void
		{
			//dispatchEvent(new SkinManagerEvent(SkinManagerEvent.SkinsLoaded));
		}
		
		protected function onSkinsComplete(e : Event) : void
		{
			
			var urlreq : URLRequest = new URLRequest(Address.QuestSkin);
			
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			_questSkins.contentLoaderInfo.addEventListener(Event.COMPLETE, onQuestSkinsComplete);
			_questSkins.load(urlreq, context);
		}
		
		public function getAtlasTexture(atlas_:String, name_ : String) : Texture
		{
			return _assets.getTextureAtlas(atlas_).getTexture(name_);
		}
		
		public function getAtlasTextures(atlas_:String, name_ : String) : Vector.<Texture>
		{
			return _assets.getTextureAtlas(atlas_).getTextures(name_);
		}
		
		public function getSkinTexture(name_ : String) : Texture
		{
			//trace(name_)
			return _assets.getTexture(name_);
		}
		
		public function getSkinTextures(name_ : String) : Vector.<Texture>
		{
			//trace(name_)
			return _assets.getTextures(name_);
		}
		
		public function getByteArray(name_ : String) : ByteArray
		{
			//trace(name_)
			return _assets.getByteArray(name_);
		}
		
		public function getXML(name_ : String) : XML
		{
			//trace(name_)
			return _assets.getXml(name_);
		}
		
		public function getSkin(name_ : String) : Class
		{
			var resClazz : Class
			
			try
			{
				resClazz = _skins.contentLoaderInfo.applicationDomain.getDefinition(name_) as Class;
				//trace(name_, resClazz);
			}
			catch (e : Error)
			{
				Logger.message("Skin class: " + name_ + " not found in skins.", TAG, LogLevel.Error, LogModule.View);
				
				return null;
			}
			
			Logger.message("Loaded skin class: " + name_, TAG, LogLevel.Debug, LogModule.View);
			
			return resClazz;
		}
		
		public function getQuestSkin(name_ : String) : Class
		{
			var resClazz : Class
			
			try
			{
				resClazz = _questSkins.contentLoaderInfo.applicationDomain.getDefinition(name_) as Class;
			}
			catch (e : Error)
			{
				Logger.message("Quest skin class: " + name_ + " not found in quest skins.", TAG, LogLevel.Error, LogModule.View);
				
				return null;
			}
			
			Logger.message("Loaded quest skin class: " + name_, TAG, LogLevel.Debug, LogModule.View);
			
			return resClazz;
		}
		
		public static function get instance() : SkinManager
		{
			return _instance;
		}
	}
}