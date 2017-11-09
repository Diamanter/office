package com.sigma.socialgame.view.console
{
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.LogEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	
//	import flashx.textLayout.conversion.TextConverter;
	
//	import org.osmf.metadata.KeyValueFacet;
	
	public class Console extends Sprite
	{
		private var _textField : TextField;
		private var _textFormat : TextFormat;
		
		protected const _modules : Array = [0x777777, 0x7f7fff, 0x00d9ff];
			
		protected const _levels : Array = ["Debug", "Info", "Warning", "Error", "Fatal"];
		
		protected const _colors : Array = [0x000000, 0x000000, 0xffbf00, 0xff0000, 0xff0000];
		protected const _bolds : Array = [true, false, false, false, true];
		
		protected const _defaultColor : uint = 0x222222;
		protected const _defaultBold : Boolean = false;
		
		protected const _senderColor : uint = 0x25009e;
		protected const _senderBold : Boolean = true;
		
		protected const _backColor : uint = 0x9999CC;
		
		public function Console()
		{
			super();
		
			visible = false;
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_textFormat = new TextFormat();
			
			_textField = new TextField();
			
			addChild(_textField);

			_textField.width = 810;
			_textField.height = 300;
			_textField.background = true;
			_textField.backgroundColor = _backColor;
			_textField.multiline = true;
			
			Logger.addEventListener(LogEvent.Message, onMessage);
		}
		
		protected function onAddedToStage(e : Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeydown);
		}
		
		protected function onKeydown(e : KeyboardEvent) : void
		{
			if (e.keyCode == 192)
			{
				visible = !visible;
				
				if (visible)
				{
//					parent.swapChildren(this, parent.getChildAt(parent.numChildren - 1));
					
					var par : DisplayObjectContainer = parent;
					parent.removeChild(this);
					
					par.addChildAt(this, par.numChildren);
				}
			}
		}
		
		protected function onMessage(e : LogEvent) : void
		{
			var startInd : int;
			var endInd : int;
			var str : String;

// Log module string
			
			str = String.fromCharCode(9608);

			_textFormat.bold = false;
			_textFormat.color = _modules[e.message.module];
			
			startInd = _textField.text.length;
			endInd = str.length + startInd;
			
			_textField.appendText(str);
			
			_textField.setTextFormat(_textFormat, startInd, endInd);

// Log level string			
			
			str = String.fromCharCode(9608) + _levels[e.message.level] + ": ";
			
			_textFormat.bold = _bolds[e.message.level];
			_textFormat.color = _colors[e.message.level];
			
			startInd = _textField.text.length;
			endInd = str.length + startInd;
			
			_textField.appendText(str);
			
			_textField.setTextFormat(_textFormat, startInd, endInd);
			
// Sneder string
			
			str = e.message.sender + ": ";
			
			_textFormat.bold = _senderBold;
			_textFormat.color = _senderColor;
			
			startInd = _textField.text.length;
			endInd = str.length + startInd;
			
			_textField.appendText(str);
			
			_textField.setTextFormat(_textFormat, startInd, endInd);
			
// Message string			
			
			str = e.message.message + "\n";
			
			_textFormat.bold = _defaultBold;
			_textFormat.color = _defaultColor;

			startInd = _textField.text.length;
			endInd = str.length + startInd;
			
			_textField.appendText(str);
			
			_textField.setTextFormat(_textFormat, startInd, endInd);
			
			_textField.scrollV = _textField.maxScrollV;
		}
		
		protected function onMouseWheel(e : MouseEvent) : void
		{
			_textField.scrollV += e.delta / Math.abs(e.delta);
		}
		
		public override function set width(value:Number):void
		{
			_textField.width = value;
		}
		
		public override function get width():Number
		{
			return _textField.width;
		}
		
		public override function set height(value:Number):void
		{
			_textField.height = value;
		}
		
		public override function get height():Number
		{
			return _textField.height;
		}
	}
}