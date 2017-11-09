package com.sigma.socialgame.view.gui.components.shop
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class WindowShop extends Sprite
	{
		private var _skin : MovieClip;
		
		public function WindowShop()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.WindowShop);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
			}
		}
		protected const _closeButt : String = "Close";
		protected const _applyButt : String = "ApplyButton";
		protected const _chooseButt : String = "ChooseButton";		
		protected const _leftButt : String = "LeftButton";		
		protected const _rightButt: String = "RightButton";
		protected const _titleField : String = "Title";
		protected const _stickers : String = "Stickers";
		protected const _backButt : String = "BackButton";
		
		protected const _help : String = "Help";
		
		protected function get help() :  MovieClip
		{
			return _skin[_help];
		}
		
		protected function get chooseButt() : MovieClip
		{
			return _skin[_chooseButt] as MovieClip;
		}		
		
		protected function get backButt() : MovieClip
		{
			return _skin[_backButt] as MovieClip;
		}
		
		protected function get stickers() : MovieClip
		{
			return _skin[_stickers] as MovieClip;
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
		
		protected function get applyButt() : MovieClip
		{
			return _skin[_applyButt] as MovieClip;
		}
		
		protected function get leftButt() : MovieClip
		{
			return _skin[_leftButt] as MovieClip;
		}
		
		protected function get rightButt() : MovieClip
		{
			return _skin[_rightButt] as MovieClip;
		}
		
		protected function get titleTextField() : TextField
		{
			return _skin[_titleField] as TextField;
		}
	}
}