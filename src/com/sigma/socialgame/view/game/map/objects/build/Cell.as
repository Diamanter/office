package com.sigma.socialgame.view.game.map.objects.build
{
	
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import flash.geom.Point;
	
	public class Cell extends Sprite
	{
		
		private var _mapX : int;
		private var _mapY : int;
		
		public function Cell()
		{
			super();
			//var img:Image = new Image(SkinManager.instance.getSkinTexture("pol1_NW"));
			//img.pivotX = img.width/2;
			//img.pivotY = img.height;
			//addChild(img);
		}
		
		public function toString() : String
		{
			return "Cell";
		}

		public function get mapX():int
		{
			return _mapX;
		}

		public function set mapX(value:int):void
		{
			_mapX = value;
		}

		public function get mapY():int
		{
			return _mapY;
		}

		public function set mapY(value:int):void
		{
			_mapY = value;
		}
		
		public function hitTestPoint(x1:Number, y1:Number, shape:Boolean=true):Boolean
		{
			return hitTest(new Point(x1,y1))==this;
		}


	}
}