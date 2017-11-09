package com.sigma.socialgame.view.gui.components.quest
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ConfirmQuestItem extends Sprite
	{
		private var _skin : MovieClip;
		
		public function ConfirmQuestItem(image_ : String, count_ : int)
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.ConfirmQuestItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				var im : Class = SkinManager.instance.getSkin(image_);
				
				image.addChild(new im());
				
				gold.visible = false;
				coins.visible = false;
				
				costTF.text = String(count_);
			}

		}
		
		private const _gold : String = "Gold";
		private const _coins : String = "Coins";
		
		private const _cost : String = "Cost";
		private const _image : String = "image";
		
		protected function get coins() : MovieClip
		{
			return _skin[_coins];
		}
		
		protected function get gold() : MovieClip
		{
			return _skin[_gold];
		}
		
		protected function get costTF() : TextField
		{
			return _skin[_cost] as TextField;
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image] as MovieClip;
		}
	}
}