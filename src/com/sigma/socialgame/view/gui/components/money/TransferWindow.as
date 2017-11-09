package com.sigma.socialgame.view.gui.components.money
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TransferWindow extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _currConvert : int;
		
		public function TransferWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.TransferWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				title.text = StringManager.instance.getCase(StringTypes.TransferWindow).title;
				
				gold.text = "12";
				money.text= "120";
				
				var buttons : Array = 
					[
						closeButt,
						plusButt,
						minusButt,
						applyButt
					];
				
				var clickHanlder : Array =
					[
						onCloseButtonMouseEvent,
						onPlusClick,
						onMinusClick,
						onApplyClick
					];
				
				for (var i : int = 0; i < buttons.length; i++)
				{
					buttons[i].gotoAndStop(1);
					
					buttons[i].addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseEvent);
					buttons[i].addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseEvent);
					
					if (clickHanlder[i] != null)
						buttons[i].addEventListener(MouseEvent.CLICK, clickHanlder[i]);
				}
			}
		}
		
		protected function onPlusClick(e : MouseEvent) : void
		{
			if (_currConvert < walletController.converts.length - 1)
			{
				_currConvert++;
				
				setConvert();
			}
		}
		
		protected function onMinusClick(e : MouseEvent) : void
		{
			if (_currConvert > 0)
			{
				_currConvert--;
				
				setConvert();
			}
		}

		protected function onApplyClick(e : MouseEvent) : void
		{
			if (walletController.getAmount(CurrencyType.Gold).amountData.amount >= walletController.converts[_currConvert].convertData.fromCurr.amount)
			{
				visible = false;
				
				walletController.convert(walletController.converts[_currConvert]);
			}
		}
		
		protected function setConvert() : void
		{
			gold.text = walletController.converts[_currConvert].convertData.fromCurr.amount.toString();
			money.text = walletController.converts[_currConvert].convertData.toCurr.amount.toString();
		}
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
			{
				_currConvert = 0;
				
				setConvert();
				
				GuiManager.instance.windowOpened(this);
			}
			else
				GuiManager.instance.windowClosed(this);
		}
		
		protected function onButtonMouseEvent(e : MouseEvent) : void
		{
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
		
		protected function get walletController() : WalletController
		{
			return ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
		}
		
		private const _closeButt : String = "Close";
		private const _applyButt : String = "Ok";
		
		private const _plusButt : String = "Plus";
		private const _minusButt : String = "Minus";
		
		private const _gold : String = "Gold";
		private const _money : String = "Maney";
		private const _title : String = "Title";
		
		protected function get title() : TextField
		{
			return _skin[_title];
		}
		
		protected function get money() : TextField
		{
			return _skin[_money];
		}
		
		protected function get gold() : TextField
		{
			return _skin[_gold];
		}
		
		protected function get minusButt() : MovieClip
		{
			return _skin[_minusButt];
		}
		
		protected function get plusButt() : MovieClip
		{
			return _skin[_plusButt];
		}
		
		protected function get applyButt() : MovieClip
		{
			return _skin[_applyButt];
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt];
		}
	}
}