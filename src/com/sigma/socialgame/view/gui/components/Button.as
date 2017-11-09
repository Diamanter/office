package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.events.view.gui.GuiManagerEvent;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.quest.QuestBar;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Button extends Sprite
	{
		private var _id : String;
		
		private var _selected : Boolean = false;
		
		private var _locked : Boolean = false;
		
		public function Button(id_ : String)
		{
			super();
			
			_id = id_;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			applySkin();
		}

		protected function onMouseEvent(e : MouseEvent) : void
		{
			if (_locked)
			{
				if (e.type == MouseEvent.CLICK)
					QuestBar.instance.showFirstWindow();				
				
				return;
			}
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					scaleX = GuiPlaces.ButtonOverScale;
					scaleY = GuiPlaces.ButtonOverScale;
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					if (!_selected)
					{
						scaleX = 1;
						scaleY = 1;
					}
					
					break;
				
				case MouseEvent.CLICK:
					var gmEvent : GuiManagerEvent = new GuiManagerEvent(GuiManagerEvent.ButtonClicked);
					gmEvent.button = this;
					//GuiManager.instance.eventDisp.dispatchEvent(gmEvent);
					
					break;
			}
		}
		
		protected function applySkin() : void
		{
			var clazz : Class = SkinManager.instance.getSkin(_id);
			
			if (clazz != null)
				addChild(new clazz());
		}
		
		public function get selected() : Boolean
		{
			return _selected;
		}
		
		public function set selected(val_ : Boolean) : void
		{
			_selected = val_;
			
			if (_selected)
			{
				scaleX = GuiPlaces.ButtonOverScale;
				scaleY = GuiPlaces.ButtonOverScale;
			}
			else
			{
				scaleX = 1.0;
				scaleY = 1.0;
			}				
		}
		
		public function get id():String
		{
			return _id;
		}

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set locked(value:Boolean):void
		{
			_locked = value;
		}

	}
}