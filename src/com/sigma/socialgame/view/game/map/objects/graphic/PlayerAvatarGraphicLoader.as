package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.AvatarController;
	import com.sigma.socialgame.events.controller.AvatarControllerEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPartType;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatarState;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.game.map.objects.graphic.MovieClipped;
	
	import starling.core.Starling;
	import starling.animation.Juggler;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import flash.geom.Vector3D;

	public class PlayerAvatarGraphicLoader extends Sprite
	{
		public static const Sides : int = 2;
		
		private var _state : int;
		private var _dir : int;
		private var _rootNE : Sprite;
		private var _rootNW : Sprite;
		private var _loaded : Boolean;
		private var _mc : MovieClip;
		private var _partsNW : Vector.<Image>;
		private var _partsNE : Vector.<Image>;
		private var _frame : int = 0;

		public function PlayerAvatarGraphicLoader()
		{
			_loaded = false;
			_partsNW = new Vector.<Image>();
			_partsNE = new Vector.<Image>();
		}
		
		public function get dir():int
		{
			return _dir;
		}
		
		public function get loaded() : Boolean
		{
			return _loaded;
		}
		
		public function set dir(value:int):void
		{
			_dir = value;
			
			if (_rootNW==null) return;
			
			_rootNW.visible = false;
			_rootNE.visible = false;
			
			switch (_dir)
			{
				case MapRotation.SouthWest:
					_rootNW.visible = true;					
					_rootNW.scaleX = 1.0;
				break;
				case MapRotation.SouthEast:
					_rootNW.visible = true;					
					_rootNW.scaleX = -1.0;					
				break;
				
				case MapRotation.NorthWest:
					_rootNE.visible = true;					
					_rootNE.scaleX = 1.0;
				break;
				
				case MapRotation.NorthEast:
					_rootNE.visible = true;					
					_rootNE.scaleX = -1.0;					
				break;
			}
			placeParts();
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{
			_state = value;
			switch (_state)
			{
				case PlayerAvatarState.Standing:
					_mc.currentFrame = 0;
					Starling.juggler.remove(_mc);
				break;
				
				case PlayerAvatarState.Walking:
					_mc.currentFrame = 1;
					Starling.juggler.add(_mc);
				break;
				
				case PlayerAvatarState.Interacting:
					_mc.currentFrame = 11;
					Starling.juggler.add(_mc);
				break;
			}
			placeParts();
		}		
		
		private function updateParts() {
			
		}
		
		public function load() : void
		{
			var skinType : Class = null;
			
			//skinType = SkinManager.instance.getSkin(GuiIds.PlayerAvatar + PlayerAvatarPartInfo.NWPostfix);
			trace("Avatar", GuiIds.PlayerAvatar , PlayerAvatarPartInfo.NWPostfix)
			
			var texture:Texture = SkinManager.instance.getSkinTexture("Shadow");
			_mc = new MovieClip(new <Texture>[texture], 30);
			_mc.pivotX = _mc.width/2;
			_mc.pivotY = 49;
			_mc.touchable = false;
			addChild(_mc);
			
			_rootNW = new Sprite();
			addChild(_rootNW);
			
			_rootNE = new Sprite();		
			addChild(_rootNE);
			
			for (var i:int=0; i<18; i++) {
				_mc.addFrame(texture);
			}

			var avatarController : AvatarController = 
				ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			avatarController.addEventListener(AvatarControllerEvent.AvatarChanged, reloadParts);
			
			var newPart : Image;
			var baseClassName : String;
			var partObject : Object;
				
			for each (var linkInfo : Object in PlayerAvatarPartInfo.LinksNW)
			{
				partObject = avatarController.currPartByType(linkInfo.Type);
				baseClassName = partObject==null ? "" : partObject.part.image;
				
				texture = SkinManager.instance.getSkinTexture(baseClassName + linkInfo.Postfix + PlayerAvatarPartInfo.NWPostfix);
				if (texture==null) continue;
				newPart = new Image(texture);
				newPart.pivotX = newPart.width/2;
				newPart.pivotY = newPart.height/2;
				newPart.touchable = false;
				_rootNW.addChild(newPart);
				_partsNW.push(newPart);
			}
				
			for each (linkInfo in PlayerAvatarPartInfo.LinksNE)
			{
				partObject = avatarController.currPartByType(linkInfo.Type);
				baseClassName = partObject==null ? "" : partObject.part.image;
			
				texture = SkinManager.instance.getSkinTexture(baseClassName + linkInfo.Postfix + PlayerAvatarPartInfo.NEPostfix);
				if (texture==null) continue;
				newPart = new Image(texture);
				newPart.pivotX = newPart.width/2;
				newPart.pivotY = newPart.height/2;
				newPart.scaleX = -1;
				newPart.touchable = false;
				_rootNE.addChild(newPart);
				_partsNE.push(newPart);
				
				/*var newPart : PlayerAvatarPartGraphicLoader = new PlayerAvatarPartGraphicLoader(linkInfo);
				newPart.addEventListener(GraphicLoaderEvent.Loaded, onAvatarPartLoaded);
				_parts.push(newPart);*/
			}
			
			/*for each (var part : PlayerAvatarPartGraphicLoader in _parts)
			{
				part.load();
			}*/
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			dispatchEvent(new GraphicLoaderEvent(GraphicLoaderEvent.Loaded));	
			placeParts();
		}
		
		public function onFrame() {
			if (_state == PlayerAvatarState.Walking && _mc.currentFrame>10) _mc.currentFrame = 1;
			if (_state == PlayerAvatarState.Interacting && _mc.currentFrame==0) _mc.currentFrame = 11;
			if (_frame != _mc.currentFrame) {
				_frame = _mc.currentFrame;
				placeParts();
			}
		}
		
		public function reloadParts() : void
		{
			_partsNW = new Vector.<Image>();
			_partsNE = new Vector.<Image>();
			
			var avatarController : AvatarController = 
				ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			var texture:Texture;
			var newPart : Image;
			var baseClassName : String;
				
			for each (var linkInfo : Object in PlayerAvatarPartInfo.LinksNW)
			{
				baseClassName = avatarController.currPartByType(linkInfo.Type).part.image;
				
				texture = SkinManager.instance.getSkinTexture(baseClassName + linkInfo.Postfix + PlayerAvatarPartInfo.NWPostfix);
				if (texture==null) continue;
				newPart = new Image(texture);
				newPart.pivotX = newPart.width/2;
				newPart.pivotY = newPart.height/2;
				newPart.touchable = false;
				_rootNW.addChild(newPart);
				_partsNW.push(newPart);
			}
				
			for each (linkInfo in PlayerAvatarPartInfo.LinksNE)
			{
				baseClassName = avatarController.currPartByType(linkInfo.Type).part.image;
			
				texture = SkinManager.instance.getSkinTexture(baseClassName + linkInfo.Postfix + PlayerAvatarPartInfo.NEPostfix);
				if (texture==null) continue;
				newPart = new Image(texture);
				newPart.pivotX = newPart.width/2;
				newPart.pivotY = newPart.height/2;
				newPart.touchable = false;
				_rootNE.addChild(newPart);
				_partsNE.push(newPart);
			}
			placeParts();
		}	
		
		/*protected function onAvatarPartLoaded(e : GraphicLoaderEvent) : void
		{
			for each (var part : PlayerAvatarPartGraphicLoader in _parts)
			{
				if (!part.loaded) return; 
			}
			
			_loaded = true;
			
			placeParts();
			
			//_rootNW.gotoAndStop(1);
			//_rootNE.gotoAndStop(1);
			
			dispatchEvent(new GraphicLoaderEvent(GraphicLoaderEvent.Loaded));	
		}*/
		
		protected function placeParts() : void
		{
			var n:int;
			var part:Image;
			if (_rootNW.visible) {
				for each (var linkInfo : Object in PlayerAvatarPartInfo.LinksNW)
				{
					n = linkInfo.N;
					part = _partsNW[n];
					part.x = linkInfo.X[_frame];
					part.y = linkInfo.Y[_frame];
					part.rotation = linkInfo.R[_frame];
					//trace(_frame, linkInfo.Link, part.x, part.y, part.rotation)
				}
			}
			if (_rootNE.visible) {
				for each (linkInfo in PlayerAvatarPartInfo.LinksNE)
				{
					n = linkInfo.N;
					part = _partsNE[n];
					part.x = linkInfo.X[_frame];
					part.y = linkInfo.Y[_frame];
					part.rotation = linkInfo.R[_frame];
					//trace(_frame, linkInfo.Link, part.x, part.y, part.rotation)
				}
			}
			/*var roots : Array = [_rootNW, _rootNE];
			
			for each(var part : PlayerAvatarPartGraphicLoader in _parts)
			{
				var linkInfo : Object = part.linkInfo;
				
				for (var side : int = 0; side < 2; ++side)
				{
					trace(roots[side], linkInfo.Link)
					var link : Sprite = roots[side][linkInfo.Link] as Sprite;					
					if (link == null) continue;
				
					var partMC : Sprite = part.getPart(side);
					if (partMC != null)
					{
						link.addChild(partMC);
					}
				}
			}*/
		}
	}
}