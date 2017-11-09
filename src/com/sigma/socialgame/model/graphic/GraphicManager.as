package com.sigma.socialgame.model.graphic
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.common.utils.Map;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.objects.config.graphic.ImageData;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class GraphicManager
	{
		public static const TAG : String = "GraphicManager";

		private var _libs : Map; // <SWFLib, url>
		private var _loading : Map; //<SWFLib, url>
		private var _callBack : Map; //<Vector.<Function>, SWFLib>
		private var _urls : Map; //<url, LoaderInfo>
		
		public function GraphicManager()
		{
			_libs = new Map();
			_loading = new Map();
			_callBack = new Map();
			_urls = new Map();
		}

		public function init() : void
		{
			Logger.message("Initing graphic manager.", TAG, LogLevel.Info, LogModule.Model);
			
			Logger.message("Graphic manager inited", TAG, LogLevel.Info, LogModule.Model);
		}
		
		public function getSWFLib(image_ : String, callBack_ : Function) : void
		{
			var url : String = "";
			
			for each (var image : ImageData in ResourceManager.instance.images)
			{
				if (image.name == image_)
				{
					url = image.skin.url;
				}
			}
			
			if (url == "")
			{
				Logger.message("Could not find skin for Image: " + image_, TAG, LogLevel.Error, LogModule.Model);
				
				callBack_(null);
				
				return;
			}
			
			var lib : SWFLib;
	
			lib = _libs.get(url) as SWFLib;
			
			if (lib != null)
			{
				callBack_(lib);
			}
			else
			{
				lib = _loading.get(url) as SWFLib;
				
				if (lib != null)
				{
					_callBack.get(lib).push(callBack_);
				}
				else
				{
					var swfLib : SWFLib = new SWFLib();
					swfLib.loader = new Loader();
					swfLib.url = url;
					
					_callBack.push(new Vector.<Function>(), swfLib);
					_callBack.get(swfLib).push(callBack_);
					
					Logger.message("Loading swf lib: " + swfLib.url, TAG, LogLevel.Info, LogModule.Model);
					//throw new Error("Manager");
					
					trace(swfLib.url);
					var urlreq : URLRequest = new URLRequest(swfLib.url);
					
					swfLib.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete);
					swfLib.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					
					var context : LoaderContext = new LoaderContext();
					context.applicationDomain = ApplicationDomain.currentDomain;
					
					_loading.push(swfLib, url);
					_urls.push(url, swfLib.loader.contentLoaderInfo)
					
					//callBack_(swfLib);
					swfLib.loader.load(urlreq, context);
				}
			}
		}
		
		protected function onImageComplete(e : Event=null) : void
		{
			var url : String = _urls.get(e.target) as String;
			
			var swflib : SWFLib = _loading.get(url) as SWFLib;
			
			var callBacks : Vector.<Function> = _callBack.get(swflib) as Vector.<Function>;
			
			for each (var func : Function in callBacks)
			{
				func(swflib);
			}
			
			_loading.remove(url);
			_libs.push(swflib, url);
		}
		
		protected function onIOError(e : IOErrorEvent) : void
		{
			trace(TAG, "Could not load file");
		}
		
		public function getClass(className_ : String, swflib_ : SWFLib) : Class
		{
			var resClazz : Class
			
			try
			{
				resClazz = swflib_.loader.contentLoaderInfo.applicationDomain.getDefinition(className_) as Class;
			}
			catch (e : Error)
			{
				Logger.message("Graphic class: " + className_ + " not found in image: " + swflib_.url, TAG, LogLevel.Error, LogModule.Model);
				throw(new Error())
				return null;
			}
			
			Logger.message("Loaded graphic clazz: " + className_ + " in image: " + swflib_.url, TAG, LogLevel.Debug, LogModule.Model);
			
			return resClazz;
		}
	}
}