package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.view.gui.components.customize.CustomizeItem;
	
	import flash.display.Sprite;

	public class BaseTab extends Sprite
	{
		private var _screens : Vector.<BaseScreen>;
		
		private var _num : int;
		private var _screensNum : int;
		
		private var _currScreen : int;
		private var _xDim : int;
		private var _yDim : int;
		
		public function BaseTab(xDim_ : int, yDim_ : int)
		{
			_xDim = xDim_;
			_yDim = yDim_;
			_num = 0;
			_screensNum = 1;
			_currScreen = 0;
			
			_screens = new Vector.<BaseScreen>();
			
			_screens.push(new BaseScreen(_xDim));
			
			//addChild(_screens[_currScreen]);
		}
		
		public function addItem(item_ : Sprite) : void
		{
			var itemsPerScreen : int = _xDim * _yDim;
			
			var itemsOnLastScreen : int = _num - itemsPerScreen * (_screensNum - 1);
			
			if (itemsOnLastScreen > itemsPerScreen - 1)
			{
				_screensNum++;
				
				_screens.push(new BaseScreen(_xDim));
				addChild(_screens[_screensNum - 1]);
				_screens[_screensNum - 1].visible = false;
			}
			
			_screens[_screensNum - 1].addItem(item_);
			
			_num++;
		}
		
		public function get canLeft() : Boolean
		{
			return _currScreen > 0;
		}
		
		public function get canRight() : Boolean
		{
			return _currScreen < _screensNum - 1;
		}
		
		public function gotoLeft() : void
		{
			if (_currScreen > 0)
			{
				_screens[_currScreen].visible = false;
				_currScreen--;
				_screens[_currScreen].visible = true;
			}
		}
		
		public function gotoRight() : void
		{
			if (_currScreen < _screensNum - 1)
			{
				_screens[_currScreen].visible = false;
				_currScreen++;
				_screens[_currScreen].visible = true;
			}
		}
	}
}