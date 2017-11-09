package com.sigma.socialgame.view.gui.components.money
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.controller.wallet.objects.MoneyObject;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.BaseTab;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BuyOkWindow extends SomeMoneyWindow
	{
		private var _mainTab : BaseTab;
		
		public function BuyOkWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.BuyOkWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);

				title.text = StringManager.instance.getCase(StringTypes.BuyOkWindow).title;
				
				buyGoldButt.visible = false;
				buyCoinsButt.visible = false;
				message.visible = false;
				
				buyCoinsButt.gotoAndStop(1);
				buyGoldButt.gotoAndStop(1);
				
				var buttons : Array = 
					[
						closeButt,
						downButt,
						upButt
					];
				
				var clickHanlder : Array =
					[
						onCloseButtonMouseEvent,
						onDown,
						onUp
					];
				
				for (var i : int = 0; i < buttons.length; i++)
				{
					buttons[i].gotoAndStop(1);
					
					buttons[i].addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseEvent);
					buttons[i].addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseEvent);
					
					if (clickHanlder[i] != null)
						buttons[i].addEventListener(MouseEvent.CLICK, clickHanlder[i]);
				}
				
				init();
				checkArr();
			}
		}
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
				GuiManager.instance.windowOpened(this);
			else 
				GuiManager.instance.windowClosed(this);
		}
		
		protected function checkArr() : void
		{
			if (_mainTab.canLeft)
				upButt.gotoAndStop(1);
			else
				upButt.gotoAndStop(3);
			
			if (_mainTab.canRight)
				downButt.gotoAndStop(1);
			else
				downButt.gotoAndStop(3);
		}
		
		protected function onDown(e : MouseEvent) : void
		{
			_mainTab.gotoRight();
			
			checkArr();
		}
		
		protected function onUp(e : MouseEvent) : void
		{
			_mainTab.gotoLeft();
			
			checkArr();
		}
		
		protected function init() : void
		{
			_mainTab = new BaseTab(1, 3);
			
			slots.addChild(_mainTab);
			
			var money : MoneyObject;
			var newSlot : MoneySlot;
			
/*			newSlot = new MoneySlot();
			
			newSlot.money = 100;
			newSlot.gold = 1;
			newSlot.id = 1;
			
			_mainTab.addItem(newSlot);
*/			
			for each (money in walletContoller.moneys)
			{
				newSlot = new MoneySlot();
				
				newSlot.money = money.moneyData.amount.amount;
				newSlot.gold = money.moneyData.gold;
				newSlot.id = money.moneyData.id;
				newSlot.desc = money.moneyData.desc;
				
				_mainTab.addItem(newSlot);
			}
		}
		
		protected function onButtonMouseEvent(e : MouseEvent) : void
		{
			if (e.currentTarget == downButt)
				if (!_mainTab.canRight)
					return;
			
			if (e.currentTarget == upButt)
				if (!_mainTab.canLeft)
					return;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					e.currentTarget.gotoAndStop(2);
					
					break;
			
				case MouseEvent.MOUSE_OUT:
					
					e.currentTarget.gotoAndStop(1);
					
					break;
			}
		}
		
		protected function onCloseButtonMouseEvent(e : MouseEvent) : void
		{
			visible = !visible;
		}
		
		protected function get walletContoller() : WalletController
		{
			return ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
		}
	}
}