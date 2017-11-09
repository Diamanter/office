package com.sigma.socialgame.view.gui.components.gifts
{
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GiftGraphicLoader extends Sprite
	{
		private var _skin : MovieClip;
		private var _image : String;
		
		public function GiftGraphicLoader()
		{
			super();
		}
		
		public function setImage(image_ : String) : void
		{
			_image = image_;
			
			ResourceManager.instance.getSWFLib(image_, onSWFLoaded);
			
			if (_skin != null)
			{
				removeChild(_skin);
				
				_skin = null;
			}
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