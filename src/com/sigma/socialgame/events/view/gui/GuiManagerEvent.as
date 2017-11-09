package com.sigma.socialgame.events.view.gui
{
	import com.sigma.socialgame.view.gui.components.Button;
	
	import flash.events.Event;

	public class GuiManagerEvent extends Event
	{
		public static const Inited : String = "gmInited";
		
		public static const ButtonClicked : String = "gmButtonClicked";
		
		public static const TaskInfoShowed : String = "gmTaskInfoShowed";
		public static const TaskInfoClosed : String = "gmTaskInfoClosed";
		
		public static const EntityMenuShowed : String = "gmDecorMenuShowed";
		public static const EntityMenuClosed : String = "gmDecorMenuClosed";
		
		public static const EntityMenuNoSellShowed : String = "gmDecorMenuNoSellShowed";
		public static const EntityMenuNoSellClosed : String = "gmDecorMenuNoSellClosed";
		
		public static const EntityMenuRotateShowed : String = "gmDecorMenuRotateShowed";
		public static const EntityMenuRotateClosed : String = "gmDecorMenuRotateClosed";
		
		public static const TaskChoiceShowed : String = "gmTaskChoiceShowed";
		public static const TaskChoiceClosed : String = "gmTaskChoiceClosed";
		
		private var _button : Button;
		
		public function GuiManagerEvent(type : String)
		{
			super(type);
		}

		public function get button():Button
		{
			return _button;
		}

		public function set button(value:Button):void
		{
			_button = value;
		}

	}
}