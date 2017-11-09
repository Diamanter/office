package com.sigma.socialgame.view.gui.components.quest
{
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.model.objects.config.quest.BuyTodo;
	import com.sigma.socialgame.model.objects.config.quest.CommandTodo;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.components.CheckBox;
	import com.sigma.socialgame.view.gui.components.help.HelpCaseType;
	import com.sigma.socialgame.view.gui.components.help.HelpManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class QuestWindow extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _questObject : QuestObject;
		
		private var _questImage : QuestGraphicLoader;
		
		public function QuestWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.QuestWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				_questImage = new QuestGraphicLoader();
				
				image.addChild(_questImage);
				
				var widgets : Array =
					[
						{ Widget: closeButt, Function: onCloseClick },
						{ Widget: okButt, Function: onCloseClick},
//						{ Widget: left, Function: null },
//						{ Widget: right, Function: null },
						{ Widget: help, Function: onHelp },
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
		
		protected function onHelp(e : MouseEvent) : void
		{
			HelpManager.instance.showHelpCase(HelpCaseType.QuestsHelp);
		}
		
		protected function onMouseEvent(e : Event) : void
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
		
		protected function onCloseClick(e : Event) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					visible = !visible;
					
					break;
				
			}
		}
		
		public function get questObject():QuestObject
		{
			return _questObject;
		}
		
		public function set questObject(value:QuestObject):void
		{
			_questObject = value;
			
			var text:String;
			
			text = _questObject.questData.data.title;
			if (text.indexOf("_")!=-1) text = StringManager.instance.getText(text);
			title.text = text;
			
			text = _questObject.questData.data.desc;
			if (text.indexOf("_")!=-1) text = StringManager.instance.getText(text);
			while (text.indexOf("\\n")!=-1) text = text.replace("\\n", "\n\n");
			while (text.indexOf("\\\"")!=-1) text = text.replace("\\\"", "\"");
			desc.text = text;			
			
			_questImage.setImage(_questObject.questData.data.image);

			var reqStr : String = "";
			
			for each (var bt : BuyTodo in _questObject.questData.buy)
			{
//				reqStr += "buy: " + bt.type + " " + bt.amount + "/";
				
				for each (var btneed : BuyTodo in _questObject.questData.data.buy)
				{
					if (btneed.type == bt.type)
					{
						text = btneed.desc;
						if (text.indexOf("_")!=-1) text = StringManager.instance.getText(btneed.desc);
						
						reqStr += text + " " + bt.amount + "/";
						reqStr += btneed.amount + "\n";
						
						break;
					}
				}
			}
			
			for each (var ct : CommandTodo in _questObject.questData.commands)
			{
//				reqStr += "command: " + ct.command.type + " " + ct.amount + "/";
				
				for each (var ctneed : CommandTodo in _questObject.questData.data.commands)
				{
					if (ctneed.command.type == ct.command.type)
					{
						reqStr += ctneed.desc + " " + ct.amount + "/";
						reqStr += ctneed.amount + "\n";
						
						break;
					}
				}
			}
			
			req.text = reqStr;
		}
		
		protected const _image : String = "Image";
		
		protected const _req : String = "Requirement";
		protected const _desc : String = "Discription";
		protected const _title : String = "Title";
		
		protected const _closeButt : String = "Close";
		
		protected const _help : String = "Help";
		
		protected const _itemSlot : String = "ItemSlot";
		
		protected const _left : String = "Left";
		
		protected const _okButt : String = "Ok";
		
		protected const _right : String = "Right";
		
		protected function get okButt() : MovieClip
		{
			return _skin[_okButt];
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image];
		}
		
		protected function get req() : TextField
		{
			return _skin[_req];
		}
		
		protected function get desc() : TextField
		{
			return _skin[_desc];
		}
		
		protected function get title() : TextField
		{
			return _skin[_title];
		}
		
/*		protected function get right() : MovieClip
		{
			return itemSlot[_right];
		}
		
		protected function get left() : MovieClip
		{
 			return itemSlot[_left];
		}
		
		protected function get itemSlot() : MovieClip
		{
			return _skin[_itemSlot];
		}
*/		
		protected function get help() : MovieClip
		{
			return _skin[_help];
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
	}
}