package com.sigma.socialgame.view.game.map.objects.build
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Image;
	
	import flash.geom.Point;
	
	public class Wall extends Sprite
	{
		private var _wall : int;
		private var _mapX : int;
		
		public function Wall(wall_ : int)
		{
			super();
			
			//var wall : Image = new Image(SkinManager.instance.getSkinTexture("pol1_NW"));
			//wall.pivotX = wall.width/2;
			//wall.pivotY = wall.height;
			
			//addChild(wall);
			
			if (wall_ == MapRotation.NorthEast)
			{
				scaleX = -1.0;
			}
		}
		
		public function toString():String
		{
			return "Wall";
		}

		public function get wall():int
		{
			return _wall;
		}

		public function set wall(value:int):void
		{
			_wall = value;
		}

		public function get mapX():int
		{
			return _mapX;
		}

		public function set mapX(value:int):void
		{
			_mapX = value;
		}

		public function hitTestPoint(x1:Number, y1:Number, shape:Boolean=true):Boolean
		{
			return hitTest(new Point(x1,y1))==this;
		}


	}
}