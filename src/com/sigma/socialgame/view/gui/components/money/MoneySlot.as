package com.sigma.socialgame.view.gui.components.money
{
	import com.api.forticom.ForticomAPI;
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.model.social.OdnoklassnikiFAPI;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MoneySlot extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _money : int;
		private var _gold : int;
		private var _id : int;
		private var _desc : String;
		
		public function MoneySlot()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.MoneySlot);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				buyButt.gotoAndStop(1);
				
				buyButt.addEventListener(MouseEvent.CLICK, onClick);
				buyButt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOut);
				buyButt.addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
				
				addChild(_skin);
			}
		}
		
		protected function onClick(e : MouseEvent) : void
		{
			OdnoklassnikiFAPI.showPayment(_desc, "Игровая валюта", String(_id), _gold, null, null, "ok", "false");
//			ForticomAPI.showPayment(_desc, "Игровая валюта", String(_id), _gold, null, null, "ok", "false");
			
			
//			ForticomAPI.showPayment("Gold", "Игровая валюта", "1", 1, null, null, "ok", "false");
		}
		
		protected function onMouseOverOut(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					buyButt.gotoAndStop(2);
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					buyButt.gotoAndStop(1);
					
					break;
			}
		}
		
		private const _moneyTF : String = "Maney";
		private const _goldTF : String = "Gold";
		private const _buy : String = "Buy";
		
		protected function get moneyTF() : TextField
		{
			return _skin[_moneyTF];
		}
		
		protected function get goldTF() : TextField
		{
			return _skin[_goldTF];
		}
		
		protected function get buyButt() : MovieClip
		{
			return _skin[_buy];
		}

		public function get money():int
		{
			return _money;
		}

		public function set money(value:int):void
		{
			_money = value;
			
			moneyTF.text = String(_money);
		}

		public function get gold():int
		{
			return _gold;
		}

		public function set gold(value:int):void
		{
			_gold = value;
			
			goldTF.text = String(_gold);
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}


	}
}