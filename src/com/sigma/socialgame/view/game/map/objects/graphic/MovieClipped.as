package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.view.game.map.Map;
	import starling.display.MovieClip;
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import starling.textures.SubTexture;

	public class MovieClipped extends MovieClip
	{
		private var frame:Rectangle;
		private var romb:Boolean = false;
		private var rombX:Number = 0;
		private var rombY:Number = 0;
		private var rombWidth:Number = Map.CellWidth;
		
		public function MovieClipped(textures_ : Vector.<Texture>, framerate_ : int=12, border_ : Number=0)
		{
			super(textures_, framerate_);
			
			var texture:Texture = getFrameTexture(0);
			var textureFrame:Rectangle = texture.frame != null ? texture.frame : new Rectangle ( 0, 0, texture.width, texture.height );
			var subtexture:SubTexture = texture as SubTexture;
			var clipping:Rectangle = subtexture.clipping;
			frame = new Rectangle(Math.abs(textureFrame.x),	Math.abs(textureFrame.y), clipping.width * subtexture.root.width, clipping.height * subtexture.root.height);	
			frame.inflate(border_, border_);
			//trace(frame, subtexture.root.width)
		}
		
		public function set rombClip(value:Boolean) {
			romb = value;
			rombX = frame.x + frame.width/2;
			rombY = frame.y + frame.height/2;
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if (frame && frame.containsPoint (localPoint )) {
				if (romb && (Math.abs((localPoint.x-rombX)/rombWidth) + Math.abs((localPoint.y-rombY)/rombWidth*1.665) > 1) ) return null;
				return this;
			} else {
				return null;
			}
		}
		
		public function get clipping():Rectangle
		{
			return frame;
		}
		
	}
}
