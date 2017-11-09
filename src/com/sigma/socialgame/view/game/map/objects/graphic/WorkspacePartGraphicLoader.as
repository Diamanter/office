package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.map.clients.CellClient;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.view.game.common.GraphicStates;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.animation.Juggler;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.textures.SubTexture;
	
	public class WorkspacePartGraphicLoader extends GraphicLoader
	{
		private var _mcWorkspacePart : MovieClip;
		private var _type : String;
		
		public function WorkspacePartGraphicLoader(type_ : String)
		{
			_type = type_;
			super();
		}
		
		public function get type() : String
		{
			return _type;
		}

		public function set type(value : String):void
		{
			_type = value;
		}

		public var isError : Boolean = false;
		
		public override function selectState(state_:String):void
		{
			isError = false;
			if (_state == state_)
			{
				Logger.message("Specifide state: " + state_ + " for " + mapObject.toString() + "is already selected.", TAG, LogLevel.Warning, LogModule.View);
			}
			
			if (_mcWorkspacePart != null)
				removeChild(_mcWorkspacePart);
			
			var textures : Vector.<Texture> = _textures[_type + "_" + state_];
			if (textures.length==0 && _type.indexOf("_up")!=-1) textures = _textures[_type.split("_up")[0] + "_" + state_];
			
			//var partType : Class = _classes[_type + "_" + state_];
			
			_border = 5;
			if (textures == null || textures.length==0)
			{
				//Logger.message("There is no graphic class for specified state: " + _type + "_" + state_ + " for " + mapObject.toString(), TAG, LogLevel.Error, LogModule.View);
				
				//_mcWorkspacePart = new (ErrorGraphic.getErrorClass(mapObject))();
				textures = SkinManager.instance.getSkinTextures("errorWall_" + state_);
				if (textures.length>0) _mcWorkspacePart = new MovieClipped(textures, 12, _border);
				else return;
				isError = true;
				return;
			}
			else if (textures.length==1)
			{
				_mcWorkspacePart = new MovieClipped(textures, 12, _border);
			}
			else 
			{
				_mcWorkspacePart = new MovieClipped(textures, 12, _border);
				Starling.juggler.add(_mcWorkspacePart);
			}
			
			_mcWorkspacePart.pivotX = _mcWorkspacePart.width/2;
			_mcWorkspacePart.pivotY = _mcWorkspacePart.height;
			_state = state_;
			
			addChild(_mcWorkspacePart);
			
			// NOTE: Если объект будет больше, чем одна клетка, то этот код будет неправильно рассчитывать смещения.
			var vec3 : Vector3D = Map.instance.getCellCoords(1, 1);
			
			_mcWorkspacePart.x += vec3.x;
			_mcWorkspacePart.y += vec3.y;
			
		}
			
		public function get mcWorkspacePart():MovieClip
		{
			return _mcWorkspacePart;
		}
	}
}