package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.AvatarController;
	import com.sigma.socialgame.events.controller.AvatarControllerEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	public class PlayerAvatarPartGraphicLoader extends EventDispatcher
	{
		private var _state : int;
		private var _dir : int;
		private var _parts : Array;
		private var _linkInfo : Object;
		private var _loaded : Boolean;
		private var _baseClassName : String; 
		
		public function get loaded() : Boolean
		{
			return _loaded;
		}
		
		public function get linkInfo() : Object
		{
			return _linkInfo;
		}
		
		public function PlayerAvatarPartGraphicLoader(linkInfo_ : Object)
		{
			var avatarController : AvatarController = 
				ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			avatarController.addEventListener(AvatarControllerEvent.AvatarChanged, reload);
			_linkInfo = linkInfo_;
			_baseClassName = avatarController.currPartByType(_linkInfo.Type).part.image;
			_loaded = false;
			_parts = [new Sprite(), new Sprite()];	
		}
	
		public function reload(e : Event) : void
		{
			var avatarController : AvatarController = 
				ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			var newClassName : String = avatarController.currPartByType(_linkInfo.Type).part.image;
			if (_baseClassName == newClassName)
			{
				return;
			}
			
			_baseClassName = newClassName;
			
			for (var i : int = 0; i < PlayerAvatarGraphicLoader.Sides; ++i)
			{
				while (_parts[i].numChildren > 0)
				{
					_parts[i].removeChildAt(0);
				}
			}
			
			load();
		}
		
		public function load() : void
		{
			//ResourceManager.instance.getSWFLib(_baseClassName, onSWFLibLoaded);
			trace(_baseClassName + _linkInfo.Postfix + PlayerAvatarPartInfo.NWPostfix)
			if (!_loaded)
			{
				_loaded = true;
				dispatchEvent(new GraphicLoaderEvent(GraphicLoaderEvent.Loaded));
			}
		}
		
		protected function onSWFLibLoaded(swfLib_ : SWFLib) : void
		{
			/*var classes : Array = [
				_baseClassName + _linkInfo.Postfix + PlayerAvatarPartInfo.NWPostfix,
				_baseClassName + _linkInfo.Postfix + PlayerAvatarPartInfo.NEPostfix
				// TODO: add more classes
			];
			
			
			
			for (var i : int = 0; i < PlayerAvatarGraphicLoader.Sides; ++i) 
			{
				var textures : Vector.<Texture> = _textures[_type + "_" + state_];
				if (textures.length==0 && _type.indexOf("_up")!=-1) textures = _textures[_type.split("_up")[0] + "_" + state_];
				
				if (skinType != null)
				{
					var temp : MovieClip = new skinType(); 
					_parts[i].addChild(temp); 
				}
			}
			
			*/
		}
		
		public function getPart(index : int) : Sprite
		{
			return _parts[index] as Sprite;
		}
		
		public function get dir():int
		{
			return _dir;
		}
		
		public function set dir(value:int):void
		{
			_dir = value;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{
			_state = value;
		}
		
	}
}