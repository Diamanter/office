package com.sigma.socialgame.view.gui.components.task
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class FireTask extends Sprite
	{
		private var _skin : MovieClip;
		
		public function FireTask()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.FireTask);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				
			}
		}
	}
}