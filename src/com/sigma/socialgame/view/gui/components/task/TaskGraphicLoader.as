package com.sigma.socialgame.view.gui.components.task
{
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class TaskGraphicLoader extends Sprite
	{
		private var _skin : MovieClip;
		private var _image : String;
		
		public function TaskGraphicLoader()
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
			
			ResourceManager.instance.getSWFLib(_image, onSWFLoaded);
		}
		
		public function onSWFLoaded(swfLib_ : SWFLib) : void
		{
			var clazz : Class = ResourceManager.instance.getGraphicClazz(_image, swfLib_);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
			}
		}
	}
}