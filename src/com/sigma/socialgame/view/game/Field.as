package com.sigma.socialgame.view.game
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.view.FieldEvent;
	import com.sigma.socialgame.events.view.gui.GuiManagerEvent;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Image;
	import flash.events.FullScreenEvent;
	
	public class Field extends Sprite
	{
		public static const TAG : String = "Field";
		
		private static var _instance : Field;
		
		private var _map : Map;
		
		private var _mouseMode : String;
		
		public function Field()
		{
			super();
			
			_instance = this;
			
			_map = new Map();
		}
		
		public function init() : void
		{
			Logger.message("Initing Field.", TAG, LogLevel.Info, LogModule.View);

			_mouseMode = MouseModes.Select;
			
			dispatchEvent(new FieldEvent(FieldEvent.MouseModeChanged));
			
			addChild(_map);
			
			_map.init();
			
			//GuiManager.instance.eventDisp.addEventListener(GuiManagerEvent.ButtonClicked, onGuiManagerEvent);
			
			Logger.message("Field inited.", TAG, LogLevel.Info, LogModule.View);
		}
		
		public function reload() : void
		{
			_map.reload();
		}
		
		/*protected function onGuiManagerEvent(e : GuiManagerEvent) : void
		{
			switch (e.type)
			{
				case GuiManagerEvent.ButtonClicked:
					
					switch (e.button.id)
					{
						case GuiIds.SelectButton:
							_mouseMode = MouseModes.Select;
							break;
						
						case GuiIds.MoveButton:
							_mouseMode = MouseModes.Move;
							break;
						
						case GuiIds.RotateButton:
							_mouseMode = MouseModes.Rotate;
							break;
						
						case GuiIds.SellButton:
							_mouseMode = MouseModes.Sell;
							break;
					}
					
					break;
			}
			
			dispatchEvent(new FieldEvent(FieldEvent.MouseModeChanged));
		}*/
		
		public function get mouseMode():String
		{
			return _mouseMode;
		}
		
		public function set mouseMode(val_ : String) : void
		{
			_mouseMode = val_;
			
			dispatchEvent(new FieldEvent(FieldEvent.MouseModeChanged));
		}
		
		public static function get instance() : Field
		{
			return _instance;
		}
	}
}