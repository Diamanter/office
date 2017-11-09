package com.sigma.socialgame.view.gui.components.menu
{
	import com.sigma.socialgame.controller.facade.MapEntityFacade;
	import com.sigma.socialgame.view.game.map.objects.GameEntity;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.game.map.Map;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class EntityMenu extends Sprite
	{
		protected var _skin : MovieClip;
		private var _gameEntity : GameEntity;
		
		public function EntityMenu()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.EntityMenu);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				var buttons : Array = 
					[
						moveButton, sellButton, invButton
					];
				
				for each (var butt : MovieClip in buttons)
				{
					butt.gotoAndStop(1);
					
					butt.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					butt.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				}
				
				moveButton.addEventListener(MouseEvent.CLICK, onMoveButtonEvent);
				sellButton.addEventListener(MouseEvent.CLICK, onSellButtonEvent);
				invButton.addEventListener(MouseEvent.CLICK, onInvButtonEvent);
			}
		}
		
		protected function onMouseEvent(e : MouseEvent) : void
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
		
		protected function onInvButtonEvent(e : MouseEvent) : void
		{
			MapEntityFacade.removeToStore(_gameEntity.mapClient.mapObject.storeObject.storeObject, true);
			
			close();
		}
		
		protected function onMoveButtonEvent(e : MouseEvent) : void
		{
			//gameEntity.toggleMove();
			Map.instance.startMove(gameEntity);
			close();
		}
		
		protected function onSellButtonEvent(e : MouseEvent) : void
		{
			gameEntity.sell();

			close();
		}
		
		protected function close() : void
		{
			GuiManager.instance.closeEntityMenu();
		}
		
		private const _moveButton : String = "moveButton";
		private const _sellButton : String = "sellButton";
		private const _invButton : String = "inventoryButton";
		
		public function get gameEntity():GameEntity
		{
			return _gameEntity;
		}

		public function set gameEntity(value:GameEntity):void
		{
			_gameEntity = value;
		}

		protected function get invButton() : MovieClip
		{
			return _skin[_invButton];
		}
		
		protected function get moveButton() : MovieClip
		{
			return _skin[_moveButton];
		}
		
		protected function get sellButton() : MovieClip
		{
			return _skin[_sellButton];
		}
	}
}