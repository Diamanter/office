package com.sigma.socialgame.view.gui.components
{
	import flash.display.Sprite;
	import com.sigma.socialgame.view.gui.components.customize.CustomizeItem;

	public class BaseScreen extends Sprite
	{
		private var _num : int;
		private var _dim : int;
		
		public function BaseScreen(dim_ : int)
		{
			_dim = dim_;
			_num = 0;
		}
		
		public function addItem(item_ : Sprite) : void
		{			
			addChild(item_);
			
			var xf : int = (_num % _dim);
			var yf : int = (_num / _dim);			
			
			item_.x = item_.width * xf;
			item_.y = item_.height * yf;
			
			_num++;
		}
	}
}