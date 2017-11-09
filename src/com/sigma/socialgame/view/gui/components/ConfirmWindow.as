package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ConfirmWindow extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _callback : Function;
		
		public function ConfirmWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.ConfirmWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				items.visible = false;
				leftButt.visible = false;
				rightButt.visible = false;
				gifts.visible = false;
				
				leftButt.gotoAndStop(1);
				rightButt.gotoAndStop(1);

				var buttons : Array = 
					[
						closeButt,
						okButt,
						cancel
					];
				
				var clickHanlder : Array =
					[
						onCloseMouseClick,
						onOkMouseClick,
						onCancelMouseClick
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
		
		protected function onOkMouseClick(e : MouseEvent) : void
		{
			_callback(true);
			
			visible = false;
		}
		
		protected function onCancelMouseClick(e : MouseEvent) : void
		{
			_callback(false);
			
			visible = false;
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
		
		protected function onCloseMouseClick(e : MouseEvent) : void
		{
			visible = false;
		}
		
		public function show(title_ : String, text_ : String, callback_ : Function) : void
		{
			visible = true;
			
			title.text = title_;
			message.text = text_;
			
			_callback = callback_;
		}
		
		private const _closeButt : String = "Close";
		private const _okButt : String = "Ok";
		private const _title : String = "Title";
		private const _message : String = "Message_Text";
		
		private const _items : String = "ItemSlot";
		private const _leftButt : String = "Left";
		private const _rightButt : String = "Right";
		private const _gifts : String = "Gifts";
		
		private const _cancel : String = "Cancel";
		
		protected function get cancel() : MovieClip
		{
			return _skin[_cancel];
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
		
		protected function get okButt() : MovieClip
		{
			return _skin[_okButt] as MovieClip;
		}
		
		protected function get title() : TextField
		{
			return _skin[_title] as TextField;
		}
		
		protected function get message() : TextField
		{
			return _skin[_message] as TextField;
		}
		
		protected function get items() : MovieClip
		{
			return _skin[_items] as MovieClip;
		}
		
		protected function get leftButt() : MovieClip
		{
			return items[_leftButt] as MovieClip;
		}
		
		protected function get rightButt() : MovieClip
		{
			return items[_rightButt] as MovieClip;
		}
		
		protected function get gifts() : MovieClip
		{
			return items[_gifts] as MovieClip;
		}
	}
}