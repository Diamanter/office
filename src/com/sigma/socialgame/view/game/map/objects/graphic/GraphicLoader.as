package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	
	import starling.display.MovieClip;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.animation.Juggler;
	import flash.geom.Vector3D;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class GraphicLoader extends Sprite
	{
		public static const TAG : String = "GraphicLoader";
		
		protected var _mapObj : MapObject;
		protected var _classes : Object;
		protected var _textures : Object;
		
		protected var _mc : MovieClipped;
		protected var _border : int = 0;
		
		protected var _state : String;
		
		protected var _loaded : Boolean;
		
		public function GraphicLoader()
		{
			super();
			
			_loaded = false;
			useHandCursor = true;
		}
		
		public function get mapObject() : MapObject
		{
			return _mapObj;
		}
		
		public function set mapObject(mapObj_ : MapObject) : void
		{
			_mapObj = mapObj_;
		}
		
		public function load() : void
		{
			var states : Array = GraphicLoaderFactory.createStates(_mapObj.mapObject.storeObject.object);
			var classes : Array = GraphicLoaderFactory.createClasses(_mapObj.mapObject.storeObject.object, states);
			
			var newclass : Class;
			
			_classes = new Object();
			_textures = new Object();
			//trace("::load", states, classes)
			for (var i : int = 0; i < states.length; i++)
			{
				//newclass = ResourceManager.instance.getGraphicClazz(classes[i], swfLib_);
				//_classes[states[i]] = newclass;
				//_textures[states[i]] = SkinManager.instance.getAtlasTextures("personal", classes[i]);
				//trace(_textures[states[i]])
				_textures[states[i]] = SkinManager.instance.getSkinTextures(classes[i]);
				//trace("::", classes[i], _textures[states[i]]);
			}
			
			_loaded = true;
			
			dispatchEvent(new GraphicLoaderEvent(GraphicLoaderEvent.Loaded));
			//ResourceManager.instance.getSWFLib(_mapObj.mapObject.storeObject.object.objectId.id, onSWFLibLoaded);
		}
		
		public function get loaded() : Boolean
		{
			return _loaded;
		}
		
		public function set loaded(value : Boolean) : void
		{
			_loaded = value;
		}
		
		protected function onSWFLibLoaded(swfLib_ : SWFLib) : void
		{
			if (swfLib_ == null)
			{
				return;
			}
			
		}
	
		public function get mc() : MovieClip
		{
			return _mc as MovieClip;
		}
		
		public function selectState(state_ : String) : void
		{
			if (_state == state_)
			{
				Logger.message("Specifide state: " + state_ + " for " + _mapObj.toString() + "is already selected.", TAG, LogLevel.Warning, LogModule.View);
			}
			
			if (_mc != null)
				removeChild(_mc);
			
			var textures : Vector.<Texture> = _textures[state_];
			
			if (textures == null || textures.length==0)
			{
				Logger.message("There is no graphic class for specified state: " + state_ + " for " + _mapObj.toString(), TAG, LogLevel.Error, LogModule.View);
				return;
			}
			else if (textures.length==1)
			{
				_mc = new MovieClipped(textures, 12, _border);
			}
			else 
			{
				_mc = new MovieClipped(textures, 12, _border);
				Starling.juggler.add(_mc);
			}
			_mc.pivotX = _mc.width/2;
			_mc.pivotY = _mc.height;
			
			_state = state_;
			
			addChild(_mc);
			
			if (_mapObj && _mapObj.storeObject.storeObject && _mapObj.storeObject.storeObject.object.place == ObjectPlaces.Cell && _mapObj.storeObject.storeObject.object.type == ObjectTypes.Trim) _mc.rombClip = true;
		}
		
		public function get state() : String
		{
			return _state;
		}
		
	}
}