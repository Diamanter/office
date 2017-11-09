package com.sigma.socialgame.view.gui.components.quest
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.quest.QuestController;
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.social.SocialNetwork;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.BaseTab;
	import com.sigma.socialgame.view.gui.components.CheckBox;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ConfirmQuestWindow extends Sprite
	{
		public static var ScreenDim : Array;
		
		private var _skin : MovieClip;
		private var _mainTab : BaseTab;
		
		private var _confirmQuest : QuestObject;
		
		private var _check : CheckBox;
		
		public function ConfirmQuestWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.ConfirmQuestWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				okButt.Title1.text = "Рассказать друзьям";
				
				ScreenDim = [GuiPlaces.ConfirmQuestWindowPlace.dim.x, GuiPlaces.ConfirmQuestWindowPlace.dim.y];
				
				addChild(_skin);
				
				var widgets : Array =
					[
						{ Widget: closeButt, Function: onCloseButtonClick },
						{ Widget: okButt, Function: onOkButtonClick },
						{ Widget: leftButt, Function: onLeftButtonClick },
						{ Widget: rightButt, Function: onRightButtonClick },
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
				
				_check = new CheckBox();
				
				_check.skin = share;
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
		
		protected function onLeftButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoLeft();
		}
		
		protected function onRightButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoRight();
		}
		
		protected function onMouseEvent(e : Event) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					mc.gotoAndStop(2);
					
					okButt.Title1.text = "Рассказать друзьям";
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					mc.gotoAndStop(1);
					
					okButt.Title1.text = "Рассказать друзьям";
					
					break;
			}
		}
		
		protected function onOkButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).confirmQuest(_confirmQuest);
			
			visible = !visible;
			
			var stringCase : StringCase = StringManager.instance.getCase(StringTypes.QuestPublish);
			
			SocialNetwork.instance.publish(stringCase.title, stringCase.message, stringCase.imageMessage);
		}
		
		protected function onCloseButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).confirmQuest(_confirmQuest);
			
			visible = !visible;
		}
		
		protected function apply() : void
		{
			if (_mainTab != null)
				reward.removeChild(_mainTab);
			
			message.text = _confirmQuest.questData.data.success;
			if (message.text.indexOf("_")!=-1) message.text = StringManager.instance.getText(message.text);
			
			_mainTab = new BaseTab(4, 1);
			
			reward.addChild(_mainTab);
			
			for each (var give : GiveData in _confirmQuest.questData.data.gives)
			{
				switch (give.currency.type)
				{
					case CurrencyType.Coin:
						
						_mainTab.addItem(new ConfirmQuestItem(GuiIds.CoinsImage, give.amount));
						
						break;
					
					case CurrencyType.Gold:
						
						_mainTab.addItem(new ConfirmQuestItem(GuiIds.GoldImage, give.amount));
							
						break;
					
					case CurrencyType.Experience:
						
						_mainTab.addItem(new ConfirmQuestItem(GuiIds.ExpImage, give.amount));
							
						break;
				}
			}
		}
		
		private const _closeButt : String = "Close";
		private const _okButt : String = "Ok";
		private const _title : String = "Title";
		private const _message : String = "Message_Text";
		
		private const _items : String = "ItemSlot";
		private const _leftButt : String = "Left";
		private const _rightButt : String = "Right";
		private const _reward : String = "Gifts";
		
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
		
		protected function get reward() : MovieClip
		{
			return items[_reward] as MovieClip;
		}

		public function get confirmQuest():QuestObject
		{
			return _confirmQuest;
		}

		public function set confirmQuest(value:QuestObject):void
		{
			_confirmQuest = value;
			
			apply();
		}
	}
}