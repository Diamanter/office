package com.sigma.socialgame.view.gui.components
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.core.ByteArrayAsset;
	
	public class SimplePbar extends Sprite
	{
		[Embed(source="../../../../../../../data/build/LoadBar.swf", mimeType="application/octet-stream")]
		private var _barCls : Class;
		
		private var _loader : Loader;
		private var _bar : MovieClip;
		
		private var _loaded : Boolean = false;
		private var _val : Number = -1.0;
		
		private var _place : Point = new Point(-169.55, 303);
		
		public function SimplePbar()
		{
			super();
	
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			context.allowCodeImport = true;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loader.loadBytes((new _barCls()) as ByteArray, context);
		}
		
		protected function onComplete(e : Event) : void
		{
			var loaderInfo : LoaderInfo = e.target as LoaderInfo;
			var cls : Class = loaderInfo.applicationDomain.getDefinition("progressbar") as Class;
			
			_bar = new cls();
			
			addChild(_bar);
			
			_bar.x = MyOfficeGame.instance.dim.x / 2 + _place.x;
			_bar.y = MyOfficeGame.instance.dim.y / 2 + _place.y;
			
			_loaded = true;
			
			if (_val > -1.0)
				progress = _val;
		}
		
		public function set progress(val_ : Number) : void
		{
			if (!_loaded)
			{
				_val = val_;
				
				return;
			}
			
			_bar.bar.scaleX = val_;
			_bar.Text.text = String(val_ * 100) + "%";
		}
	}
}