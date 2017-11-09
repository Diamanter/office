package com.sigma.socialgame.view.gui.components.customize
{
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class CustomizeGraphicLoader extends Sprite
	{
		private var _skin : MovieClip;
		private var _image : String;
		
		public function CustomizeGraphicLoader()
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
			
			ResourceManager.instance.getSWFLib(image_, onSWFLoaded);
		}
		
		protected function onSWFLoaded(swfLib_ : SWFLib) : void
		{
			var clazz : Class;
			
			clazz = ResourceManager.instance.getGraphicClazz(_image, swfLib_);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
			}
		}
	}
}