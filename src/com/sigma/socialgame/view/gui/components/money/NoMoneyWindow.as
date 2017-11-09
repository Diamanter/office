package com.sigma.socialgame.view.gui.components.money
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
//	import flashx.textLayout.factory.StringTextLineFactory;
	
	public class NoMoneyWindow extends SomeMoneyWindow
	{
		public function NoMoneyWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.NoMoneyWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				upButt.visible = false;
				downButt.visible = false;
				slots.visible = false;
				
				upButt.gotoAndStop(1);
				downButt.gotoAndStop(1);

				var stringCase : StringCase = StringManager.instance.getCase(StringTypes.NoMoneyWindow);
				
				title.text = stringCase.title;
				message.text = stringCase.message;
				
				var buttons : Array = 
					[
						closeButt,
						buyGoldButt,
						buyCoinsButt
					];
				
				var clickHanlder : Array =
					[
						onCloseButtonMouseEvent,
						onBuyGoldButtonMouseEvent,
						onBuyCoinsButtonMouseEvent
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
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
				GuiManager.instance.windowOpened(this);
			else 
				GuiManager.instance.windowClosed(this);
		}
		
		protected function onBuyGoldButtonMouseEvent(e : MouseEvent) : void
		{
			visible = !visible;
			
			GuiManager.instance.buyOkWindow.visible = true;
		}
		
		protected function onBuyCoinsButtonMouseEvent(e : MouseEvent) : void
		{
			visible = !visible;
			
			GuiManager.instance.transferWindow.visible = true;
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
	}
}