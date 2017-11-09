package com.sigma.socialgame.common.utils
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.Logger;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XMLLoader
	{
		private static var _instance : XMLLoader;
		
		private var _callBack : Map;
		private var _names : Map;
		
		public function XMLLoader()
		{
			_callBack = new Map();
			_names = new Map();
		}
		
		protected function loadXMLInt(filename : String, callBack : Function) : void
		{
			Logger.message("Loading XML: " + filename, "XMLLoader", LogLevel.Debug);
			
			var urlreq : URLRequest = new URLRequest(filename);
			
			var urlloader : URLLoader = new URLLoader();
			
			_callBack.push(callBack, urlloader);
			_names.push(filename, urlloader);
			
			urlloader.addEventListener(Event.COMPLETE, onComplete);
			
			urlloader.load(urlreq);
		}
		
		protected function onComplete(e : Event) : void
		{
			var data : XML = XML(e.target.data);
		
			Logger.message("Loaded XML: " + _names.get(e.target), "XMLLoader", LogLevel.Debug);
			
			_callBack.get(e.target)(data);
			
			_callBack.remove(e.target);
			_names.remove(e.target);
		}
		
		public static function loadXML(filename : String, callBack : Function) : void
		{
			instance.loadXMLInt(filename, callBack);
		}
		
		protected static function get instance() : XMLLoader
		{
			if (_instance == null)
				_instance = new XMLLoader();
			
			return _instance;
		}
	}
}