package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class ToolTip extends Sprite
	{
		private var _skin : MovieClip;
		
		public function ToolTip()
		{
			super();
			
			var classType : Class = SkinManager.instance.getSkin(GuiIds.ToolTip);
			
			if (classType != null)
			{
				_skin = new classType();
				
				addChild(_skin);
			}
		}
		
		private static const ExperienceText : String = "Text"; 
		
		public function get textField() : TextField
		{
			return _skin[ExperienceText] as TextField;
		}
	}
}