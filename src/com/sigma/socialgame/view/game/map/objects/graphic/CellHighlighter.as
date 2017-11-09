package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.view.game.map.Map;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import flash.geom.Vector3D;
	
	public class CellHighlighter extends Sprite
	{
		private var _mapObj : MapObject;

		private var _cells : Vector.<Vector.<DisplayObject>>;
		private var _walls : Vector.<DisplayObject>;
		
		private var _canMatrix : Vector.<Number>;
		private var _cannotMatrix : Vector.<Number>;
		
		public function CellHighlighter()
		{
			super();
			
			_canMatrix = new Vector.<Number>();
			_cannotMatrix = new Vector.<Number>();
			
			_canMatrix = _canMatrix.concat(new <Number>[0, 0, 0, 0, 0]); // red
			_canMatrix = _canMatrix.concat(new <Number>[0, 0, 0, 1, 0]); // green
			_canMatrix = _canMatrix.concat(new <Number>[0, 0, 0, 0, 0]); // blue
			_canMatrix = _canMatrix.concat(new <Number>[0, 0, 0, 1, 0]); // alpha
			
			_cannotMatrix = _cannotMatrix.concat(new <Number>[0, 0, 0, 1, 0]); // red
			_cannotMatrix = _cannotMatrix.concat(new <Number>[0, 0, 0, 0, 0]); // green
			_cannotMatrix = _cannotMatrix.concat(new <Number>[0, 0, 0, 0, 0]); // blue
			_cannotMatrix = _cannotMatrix.concat(new <Number>[0, 0, 0, 1, 0]); // alpha
		}
		
		public function hightLight(can_ : Boolean, rot_ : int) : void
		{
			if (_mapObj is CellObject)
			{
				if (rot_ == MapRotation.NorthWest || rot_ == MapRotation.SouthEast)
				{
					scaleX = -1.0;
				}
				else
				{
					scaleX = 1.0;
				}
				
				canPlaceCell(can_);
			}
			else
			{
				if (rot_ == MapRotation.NorthWest)
				{
					scaleX = -1.0;
				}
				else
				{
					scaleX = 1.0;
				}
				
				canPlaceWall(can_);
			}
		}

		protected function canPlaceCell(can_ : Boolean) : void
		{
			var i : int;
			var j : int;
			
			var colorMF : ColorMatrixFilter;
			var filter : Array;
			
			for (i = 0; i < cellObject.width; i++)
			{
				for (j = 0; j < cellObject.height; j++)
				{
					colorMF = new ColorMatrixFilter((can_ ? _canMatrix : _cannotMatrix));
					
					_cells[i][j].filter = colorMF;
				}
			}
		}
		
		protected function canPlaceWall(can_ : Boolean) : void
		{
			var i : int;
			
			var colorMF : ColorMatrixFilter;
			var filters : Array;
			
			for (i = 0; i < wallObject.width; i++)
			{
				colorMF = new ColorMatrixFilter((can_ ? _canMatrix : _cannotMatrix));
				
				_walls[i].filter = colorMF;
			}
		}
		
		public function get mapObject():MapObject
		{
			return _mapObj;
		}

		public function set mapObject(value:MapObject):void
		{
			clearArrays();
			
			_mapObj = value;
			
			var i : int;
			var vec3 : Vector3D;
			
			if (_mapObj is CellObject)
			{
				_cells = new Vector.<Vector.<DisplayObject>>();
				
				var j : int;
				
				for (i = 0; i < cellObject.width; i++)
				{
					_cells[i] = new Vector.<DisplayObject>();
					
					for (j = 0; j < cellObject.height; j++)
					{
						_cells[i][j] = new Sprite();
						
						addChild(_cells[i][j]);

						vec3 = Map.instance.getCellCoords(-i, -j);
						
						_cells[i][j].x = vec3.x;
						_cells[i][j].y = vec3.y;
					}
				}
			}
			else
			{
				_walls = new Vector.<DisplayObject>();
				
				for (i = 0; i < wallObject.width; i++)
				{
					_walls[i] = new Sprite();
					
					addChild(_walls[i]);
					
					vec3 = Map.instance.getWallCoords(MapRotation.NorthWest, -i);
					
					_walls[i].x = vec3.x;
					_walls[i].y = vec3.y;
				}
			}
		}
		
		protected function clearArrays() : void
		{
			var i : int;
			var j : int;
			
			if (_cells != null)
			{
				for (i = 0; i < cellObject.width; i++)
				{
					for (j = 0; j < cellObject.height; j++)
					{
						removeChild(_cells[i][j]);
					}
				}
				
				_cells = null;
			}
			
			if (_walls != null)
			{
				for (i = 0; i < wallObject.width; i++)
				{
					removeChild(_walls[i]);
				}
				
				_walls = null;
			}
		}
		
		protected function get cellObject() : CellObject
		{
			return _mapObj as CellObject;
		}
		
		protected function get wallObject() : WallObject
		{
			return _mapObj as WallObject;
		}
	}
}