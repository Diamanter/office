package com.sigma.socialgame.view.gui.components.xmltest
{
	import com.api.forticom.SignUtil;
	import com.sigma.socialgame.model.server.Sender;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class XmlTestWindow extends Sprite
	{
		private var _textField : TextField;
		private var _sendButton : Sprite;
		private var _closeButton : Sprite;
		private var _resetButton : Sprite;
	
		private var _tf : TextFormat;
		
		private var _sender : XmlTestSender;
		
		public function XmlTestWindow()
		{
			super();

			_tf = new TextFormat();
			
			_tf.size = 15;
			_tf.font = "Lucida Console";
			
			_textField = new TextField();
			
			addChild(_textField);
			
			_textField.width = 700;
			_textField.height = 600;
			_textField.background = true;
			_textField.backgroundColor = 0x9999CC;
			_textField.multiline = true;
			_textField.type = TextFieldType.INPUT;
			
			_textField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			
			onResetMouseEvent(null);

			var gr : Graphics;
			var shape : Shape;
			
			_sendButton = new Sprite();
			
			_sendButton.addEventListener(MouseEvent.CLICK, onSendMouseEvent);
			
			addChild(_sendButton);
			
			_sendButton.x = 700 - 100;
			_sendButton.y = 600;
			
			shape = new Shape();
			
			_sendButton.addChild(shape);
			
			gr = shape.graphics;
			
			gr.beginFill(0xFF0000);
			gr.drawRect(0, 0, 100, 20);
			gr.endFill();
			
			_closeButton = new Sprite();
			
			addChild(_closeButton);

			_closeButton.addEventListener(MouseEvent.CLICK, onCloseMouseEvent);
			
			_closeButton.x = 700;
			_closeButton.y = 0;

			shape = new Shape();

			_closeButton.addChild(shape);
			
			gr = shape.graphics;
			
			gr.beginFill(0xFF0000);
			gr.drawRect(0, 0, 30, 30);
			gr.endFill();
			
			_resetButton = new Sprite();
			
			addChild(_resetButton);
			
			_resetButton.addEventListener(MouseEvent.CLICK, onResetMouseEvent);
			
			_resetButton.x = 0;
			_resetButton.y = 600;
			
			shape = new Shape();
			
			_resetButton.addChild(shape);
			
			gr = shape.graphics;
			
			gr.beginFill(0x0000FF);
			gr.drawRect(0, 0, 100, 20);
			gr.endFill();
			
			_sender = new XmlTestSender();
			
			_sender.addEventListener(XmlTestSenderEvent.Packet, onPacket);
		}
		
		protected function onPacket(e : XmlTestSenderEvent) : void
		{
			_textField.text = e.text;
			
			_textField.setTextFormat(_tf);
		}
		
		protected function onResetMouseEvent(e : MouseEvent) : void
		{
/*			_textField.text = 
				"<packet>\n" +
				"<version>" + Sender._pversion + "</version>\n" +
				"<type>CMD</type>\n" +
				"<session>" + Sender._psession + "</session>\n" +
				"<user>" + Sender._puser + "</user>\n" +
				"<session_key>" + SignUtil.sessionKey + "</session_key>\n" +
				"<session_secret_key>" + SignUtil.secretSessionKey + "</session_secret_key>" +
				"<commands>\n\n\n" +
				"</commands>\n" +
				"</packet>";
			
			_textField.setTextFormat(_tf);
*/			
		}
		
		protected function onTextInput(e : TextEvent) : void
		{
			_textField.setTextFormat(_tf);
		}
		
		protected function onSendMouseEvent(e : MouseEvent) : void
		{
			_sender.send(_textField.text);
		}
		
		protected function onCloseMouseEvent(e : MouseEvent) : void
		{
			parent.removeChild(this);
		}
	}
}