package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.avatar.Sex;
	import com.sigma.socialgame.view.game.map.objects.avatar.WorkerAvatarState;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.game.map.objects.graphic.MovieClipped;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;
	import starling.animation.Juggler;
	import flash.geom.Vector3D;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class WorkerAvatarGraphicLoader extends GraphicLoader
	{
		private var _sex : String;
		
		private var _sitNWTextures : Vector.<Texture>;
		private var _sitNETextures : Vector.<Texture>;
		
		private var _stepNWTextures : Vector.<Texture>;
		private var _stepNETextures : Vector.<Texture>;
		
		private var _sitNW : MovieClip;
		private var _sitNE : MovieClip;
		
		private var _stepNW : MovieClip;
		private var _stepNE : MovieClip;
		
		private var _currSkin : MovieClip;
		
		private var _avatarState : String;
		private var _dir : int;
		
		public var needToPlayAnimation : Boolean = false;
		
		public function WorkerAvatarGraphicLoader(sex_ : String)
		{
			_sex = sex_;
			
			if (_sex == Sex.Man)
			{
				_sitNETextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarManSitNW);
				_sitNWTextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarManSitNE);
				
				_stepNETextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarManStepNW);
				_stepNWTextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarManStepNE);
			}
			else
			{
				_sitNETextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarWomanSitNW);
				_sitNWTextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarWomanSitNE);
				
				_stepNETextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarWomanStepNW);
				_stepNWTextures = SkinManager.instance.getSkinTextures(GuiIds.WorkerAvatarWomanStepNE);
			}
			
			_border = 15;
			var vec3 : Vector3D = Map.instance.getCellCoords(1, 1);
			if (_sitNWTextures != null) {
				_sitNW = new MovieClipped(_sitNWTextures, 12, _border);
				_sitNW.pivotX = _sitNW.width/2;
				_sitNW.pivotY = _sitNW.height;
				_sitNW.x += vec3.x;
				_sitNW.y += vec3.y - 10;
				_sitNW.setFrameDuration(0,0);
			}
			if (_sitNETextures != null) {
				_sitNE = new MovieClipped(_sitNETextures, 12, _border);
				_sitNE.pivotX = _sitNE.width/2;
				_sitNE.pivotY = _sitNE.height;
				_sitNE.x += vec3.x;
				_sitNE.y += vec3.y - 47;
				_sitNE.setFrameDuration(0,0);
			}
			if (_stepNWTextures != null) {
				_stepNW = new MovieClipped(_stepNWTextures, 12, _border);
				_stepNW.pivotX = _stepNW.width/2;
				_stepNW.pivotY = _stepNW.height;
			}
			if (_stepNETextures != null) {
				_stepNE = new MovieClipped(_stepNETextures, 12, _border);
				_stepNE.pivotX = _stepNE.width/2;
				_stepNE.pivotY = _stepNE.height;
			}
		}

		public function get avatarState():String
		{
			return _avatarState;
		}

		public function set avatarState(value:String):void
		{
			_avatarState = value;
			
			applyState();
		}

		public function get dir():int
		{
			return _dir;
		}

		public function set dir(value:int):void
		{
			_dir = value;
		
			applyDir();
			applyState();
		}

		protected function applyState() : void
		{
			switch (_avatarState)
			{
				case WorkerAvatarState.Standing:

					switch (_dir)
					{
						case MapRotation.NorthEast:
						case MapRotation.NorthWest:
							applySkin(_stepNE);
							break;
						
						case MapRotation.SouthWest:
						case MapRotation.SouthEast:
							applySkin(_stepNW);
							break;
					}
					
					break;
				
				case WorkerAvatarState.Sitting:
					
					switch (_dir)
					{
						case MapRotation.NorthWest:
							applySkin(_sitNW);
							scaleX = -1.0;
							break;
						
						case MapRotation.NorthEast:
							applySkin(_sitNE);
							scaleX = -1.0;
							break;
						
						case MapRotation.SouthWest:
							applySkin(_sitNW);
							scaleX = 1.0;
							break;
						
						case MapRotation.SouthEast:
							applySkin(_sitNE);
							scaleX = 1.0;
							break;
					}
					if (!needToPlayAnimation) _currSkin.currentFrame = 0;
					
					break;
				
				case WorkerAvatarState.Walking:
					
					switch (_dir)
					{
						case MapRotation.NorthWest:
						case MapRotation.NorthEast:
							applySkin(_stepNE);
							break;
						
						case MapRotation.SouthEast:
						case MapRotation.SouthWest:
							applySkin(_stepNW);
							break;
					}

					break;
			}
		}
		
		protected function applyDir() : void
		{
			switch (_dir)
			{
				case MapRotation.NorthWest:
					scaleX = 1.0;
					break;
				
				case MapRotation.NorthEast:
					scaleX = -1.0;
					break;
				
				case MapRotation.SouthEast:
					scaleX = -1.0;
					break;
				
				case MapRotation.SouthWest:
					scaleX = 1.0;
					break;
			}
		}

		protected function applySkin(skin_ : MovieClip) : void
		{
			if (skin_ == null)
				return;
			
			if (_currSkin != null)
			{
				Starling.juggler.remove(_currSkin);
				_currSkin.removeFromParent();
			}
			
			_currSkin = skin_;
			addChild(_currSkin);
			if (needToPlayAnimation)
			{
				Starling.juggler.add(_currSkin);
			}
			else
			{
				Starling.juggler.remove(_currSkin)
				_currSkin.currentFrame = 0;
			}	
		}
		
	}
}