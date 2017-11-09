package com.sigma.socialgame.view.gui.components.inventory
{
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class InventoryGraphicLoader extends Sprite
	{
		private var _skin : MovieClip;
		private var _image : String;
		private var _skill : SkillData;
		
		public function InventoryGraphicLoader()
		{
			super();
		}
		
		public function setImage(image_ : String, skill_ : SkillData = null) : void
		{
			_image = image_;
			
			_skill = skill_;
			
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
			
			if (_skill != null)
				clazz = ResourceManager.instance.getGraphicClazz(_image + "" + _skill.rank, swfLib_);
			else
				clazz = ResourceManager.instance.getGraphicClazz(_image, swfLib_);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				_skin.scaleX = 0.8;
				_skin.scaleY = 0.8;
			}
		}
	}
}