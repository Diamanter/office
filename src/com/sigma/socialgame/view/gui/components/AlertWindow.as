package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class AlertWindow extends Sprite
	{
		private var _skin : MovieClip;
		
		public function AlertWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.AlertWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);

				leftButt.visible = false;
				rightButt.visible = false;
				share.visible = false;
				
				leftButt.gotoAndStop(1);
				rightButt.gotoAndStop(1);
				
				gifts.visible = false;
				items.visible = false;
				
				var widgets : Array =
					[
						{ Widget: closeButt, Function: onCloseButtonClick },
						{ Widget: okButt, Function: onOkButtonClick },
					];
				
				for each (var obj : Object in widgets)
				{
					obj.Widget.gotoAndStop(1);
					
					if (obj.Function != null)
					{
						obj.Widget.addEventListener(MouseEvent.CLICK, obj.Function);
					}
					
					obj.Widget.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					obj.Widget.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);					
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
		
		protected function onMouseEvent(e : MouseEvent) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					mc.gotoAndStop(2);
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					mc.gotoAndStop(1);
					
					break;
			}
		}
		
		protected function onCloseButtonClick(e : MouseEvent) : void
		{
			visible = false;
		}
		
		protected function onOkButtonClick(e : MouseEvent) : void
		{
			visible = false;
		}
		
		public function showAlert(title_ : String, text_ : String, canClose_ : Boolean = true) : void
		{
			if (canClose_)
			{
				closeButt.visible = true;
				okButt.visible = true;
			}
			else
			{
				closeButt.visible = false;
				okButt.visible = false;
			}
			
			title.text = title_;
			message.text = text_;
			
			visible = true;
		}
		
		private const _closeButt : String = "Close";
		private const _okButt : String = "Ok";
		private const _title : String = "Title";
		private const _message : String = "Message_Text";
		
		private const _items : String = "ItemSlot";
		private const _leftButt : String = "Left";
		private const _rightButt : String = "Right";
		private const _gifts : String = "Gifts";
		
		private const _share : String = "to_wall";
		
		protected function get share() : MovieClip
		{
			return _skin[_share];
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