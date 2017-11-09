package com.sigma.socialgame.view.gui.components.bubble
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class Bubble extends Sprite
	{
		private var _skin : MovieClip;
		
		public function Bubble(type_ : String, amount_ : int)
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.Bubble);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				var types : Array = 
					[
						BubbleType.Coins, BubbleType.Experience, BubbleType.Gold
					];
				
				var imageMap : Object = new Object();
				
				imageMap[BubbleType.Coins] = coins;
				imageMap[BubbleType.Gold] = gold;
				imageMap[BubbleType.Experience] = exp;
				
				for each (var type : String in types)
				{
					if (type != type_)
						imageMap[type].visible = false;
				}
				
				amount.text = String(amount_);
			}
		}
		
		private const _fps : Number = 24;
		
		private const _time : Number = 1;
		private const _speed : Number = 3;
		
		private const _startBlendTime : Number = 0.8;
		private const _deltaAlpha : Number = 5.0 / 24;
		
		private var timer : Timer;
		
		public function bubble() : void
		{
			timer = new Timer(1000 / _fps, _fps * _time);
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			timer.start();
		}

		protected function onTimer(e : TimerEvent) : void
		{
			y -= _speed;
			
			if (timer.currentCount > _fps * _startBlendTime)
				alpha -= _deltaAlpha;
		}
		
		protected function onTimerComplete(e : TimerEvent) : void
		{
			timer.stop();
			
			parent.removeChild(this);
		}
		
		private const _amount : String = "Count";
		
		private const _coins : String = "Coins";
		private const _gold : String = "Gold";
		private const _exp : String = "Exp";

		protected function get exp() : MovieClip
		{
			return _skin[_exp];
		}
		
		protected function get gold() : MovieClip
		{
			return _skin[_gold];
		}
		
		protected function get coins() : MovieClip
		{
			return _skin[_coins];
		}
		
		protected function get amount() : TextField
		{
			return _skin[_amount];
		}
	}
}