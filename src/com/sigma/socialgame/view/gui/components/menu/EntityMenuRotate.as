package com.sigma.socialgame.view.gui.components.menu
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class EntityMenuRotate extends EntityMenu
	{
		public function EntityMenuRotate()
		{
			super();
			
			removeChild(_skin);
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.EntityMenuRotate);
			
			if (clazz != null)
			{
				_skin = new clazz();
		
				addChild(_skin);
				
				var buttons : Array = 
					[
						moveButton, sellButton, invButton, rotateButton
					];
				
				for each (var butt : MovieClip in buttons)
				{
					butt.gotoAndStop(1);
					
					butt.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					butt.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				}
				
				rotateButton.addEventListener(MouseEvent.CLICK, onRotateButtonEvent);
				moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonEvent);
				sellButton.addEventListener(MouseEvent.CLICK, onSellButtonEvent);
				invButton.addEventListener(MouseEvent.CLICK, onInvButtonEvent);
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
		
		protected function onRotateButtonEvent(e : MouseEvent) : void
		{
			gameEntity.rotate();
			
			close();
		}
		
		protected override function close():void
		{
			GuiManager.instance.closeEntityMenuRotate();
		}
		
		private const _rotateButton : String = "rotateButton";
		
		protected function get rotateButton() : MovieClip
		{
			return _skin[_rotateButton];
		}
	}
}