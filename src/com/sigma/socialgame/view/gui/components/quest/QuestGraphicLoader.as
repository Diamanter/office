package com.sigma.socialgame.view.gui.components.quest
{
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class QuestGraphicLoader extends Sprite
	{
		private var _skin : MovieClip;
		private var _image : String;
		
		public function QuestGraphicLoader()
		{
			super();
		}
		
		public function setImage(image_ : String) : void
		{
			_image = image_;
			
			if (_skin != null)
			{
				removeChild(_skin);
				
				_skin = null;
			}

			var clazz : Class = SkinManager.instance.getQuestSkin(image_);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
			}
		}
	}
}