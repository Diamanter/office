package com.sigma.socialgame.view.gui.components.help
{
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class HelpWindow extends Sprite
	{
		private var _skin : MovieClip;
		
		public function HelpWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.HelpWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				var buttons : Array = 
					[
						{Button: okButt, Click: onClick},
						{Button: closeButt, Click: onClick}
					];
				
				for each (var butt : Object in buttons)
				{
					butt.Button.gotoAndStop(1);
					
					butt.Button.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
					butt.Button.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					
					if (butt.Click != null)
						butt.Button.addEventListener(MouseEvent.CLICK, butt.Click);
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
		
		public function showHelp(title_ : String, message_ : String, image_ : String) : void
		{
			visible = true;
			
			title.text = title_;
			message.text = message_;
			
			image.addChild(new (SkinManager.instance.getSkin(image_))());
		}
		
		protected function onClick(e : MouseEvent) : void
		{
			visible = false;
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
		
		private const _title : String = "Title";
		private const _image : String = "image";
		private const _message : String = "Message_Text";
		private const _closeButt : String = "Close";
		private const _okButt : String = "Ok";
		
		protected function get okButt() : MovieClip
		{
			return _skin[_okButt];
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt];
		}
		
		protected function get message() : TextField
		{
			return _skin[_message];
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image];
		}
		
		protected function get title() : TextField
		{
			return _skin[_title];
		}
		
	}
}