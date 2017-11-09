package com.sigma.socialgame.view.gui.components.money
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class SomeMoneyWindow extends Sprite
	{
		protected var _skin : MovieClip
		
		public function SomeMoneyWindow()
		{
			super();
		}
		
		private const _closeButt : String = "Close";
		
		private const _buyGoldButt : String = "Ok_Gold";
		private const _buyCoinsButt : String = "Gold_shm";
		
		private const _downButt : String = "Button_Down";
		private const _upButt : String = "Button_Up";
		
		private const _title : String = "Title";
		private const _message : String = "Message_Text";
		
		private const _slots : String = "image";
		
		protected function get message() : TextField
		{
			return _skin[_message];
		}
		
		protected function get title() : TextField
		{
			return _skin[_title];
		}
		
		protected function get slots() : MovieClip
		{
			return _skin[_slots];
		}
		
		protected function get upButt() : MovieClip
		{
			return _skin[_upButt];
		}
		
		protected function get downButt() : MovieClip
		{
			return _skin[_downButt];
		}
		
		protected function get buyCoinsButt() : MovieClip
		{
			return _skin[_buyCoinsButt];
		}
		
		protected function get buyGoldButt() : MovieClip
		{
			return _skin[_buyGoldButt];
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt];
		}
	}
}