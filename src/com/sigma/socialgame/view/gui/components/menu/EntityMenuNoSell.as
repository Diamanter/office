package com.sigma.socialgame.view.gui.components.menu
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class EntityMenuNoSell extends EntityMenuRotate
	{
		public function EntityMenuNoSell()
		{
			removeChild(_skin);
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.EntityMenuNoSell);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				var buttons : Array = 
					[
						moveButton, rotateButton
					];
				
				for each (var butt : MovieClip in buttons)
				{
					butt.gotoAndStop(1);
					
					butt.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					butt.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				}
				
				rotateButton.addEventListener(MouseEvent.CLICK, onRotateButtonEvent);
				moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonEvent);
			}
		}
		
		protected override function onMouseEvent(e : MouseEvent) : void
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
		
		protected override function onSellButtonEvent(e:MouseEvent):void
		{
			
		}
		
		protected override function close():void
		{
			GuiManager.instance.closeEntityMenuNoSell();
		}
	}
}