package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.controller.entity.objects.WorkerEntityState;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class WorkerState extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _state : String;
		
		public function WorkerState()
		{
			super();
		}
		
		public function get state():String
		{
			return _state;
		}

		public function set state(state_ : String) : void
		{
			if (_state == state_)
				return;
			
			_state = state_;
			
			var textures : Vector.<Texture>;
			
			switch (_state)
			{
				case WorkerEntityState.NeedWork:
					textures = SkinManager.instance.getSkinTextures(GuiIds.NeedWork);
					break;
				
				case WorkerEntityState.Working:
					textures = SkinManager.instance.getSkinTextures(GuiIds.Working);
					break;
				
				case WorkerEntityState.WorkDone:
					textures = SkinManager.instance.getSkinTextures(GuiIds.WorkDone);
					break;
			}

			if (_skin != null)
			{
				_skin.removeFromParent(true);
			}
			
			if (textures != null && textures.length>0)
			{
				_skin = new MovieClip(textures, 12);
				
				addChild(_skin);
			}
		}
	}
}