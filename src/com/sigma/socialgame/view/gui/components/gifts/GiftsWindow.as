package com.sigma.socialgame.view.gui.components.gifts
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.controller.gift.objects.GiftObject;
	import com.sigma.socialgame.events.controller.GiftControllerEvent;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.BaseTab;
	import com.sigma.socialgame.view.gui.components.CheckBox;
	import com.sigma.socialgame.view.gui.components.help.HelpCaseType;
	import com.sigma.socialgame.view.gui.components.help.HelpManager;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GiftsWindow extends Sprite
	{
		public static var ScreenDim : Array;
		
		public var sendAfterConfirm : Boolean = false;
		
		private var _skin : MovieClip;
		private var _mainTab : BaseTab;

		private var _canSend : Boolean = false;
		
		public function GiftsWindow()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.GiftsWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				ScreenDim = [GuiPlaces.GiftsWindowPlace.dim.x, GuiPlaces.GiftsWindowPlace.dim.y];
				
				addChild(_skin);
				
				applyButt.gotoAndStop(1);
				backButt.gotoAndStop(1);
				
				var widgets : Array =
				[
					{ Widget: closeButt, Function: onCloseButtonClick },
					{ Widget: chooseButt, Function: onApplyButtonClick },
					{ Widget: leftButt, Function: onLeftButtonClick },
					{ Widget: help, Function: onHelp },
					{ Widget: rightButt, Function: onRightButtonClick }
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
				
				chooseButt.gotoAndStop(3);
				
				giftController.addEventListener(GiftControllerEvent.Selected, onItemSelected);
				
				init();
			}
		}
		
		protected function onHelp(e : MouseEvent) : void
		{
			HelpManager.instance.showHelpCase(HelpCaseType.GiftsHelp);
		}
		
		protected function onItemSelected(e : GiftControllerEvent) : void
		{
			_canSend = true;
			
			chooseButt.gotoAndStop(1);
		}
		
		protected function checkLeftRight() : void
		{
			if (_mainTab.canLeft)
				leftButt.gotoAndStop(1);
			else
				leftButt.gotoAndStop(3);
			
			if (_mainTab.canRight)
				rightButt.gotoAndStop(1);
			else
				rightButt.gotoAndStop(3);
		}			
		
		protected function init() : void
		{
			_mainTab = new BaseTab(GiftsWindow.ScreenDim[0], GiftsWindow.ScreenDim[1]);
			
			stickers.addChild(_mainTab);
			
			var giftable : Vector.<GiftObject> = giftController.giftable;

			var length : int = giftable.length;
			for (var i : int = 0; i < length; ++i)
			{
				var newItem : GiftItem = new GiftItem();
				newItem.client = giftController.getClient(giftable[i]);
				
				if (newItem.client.unlocked)
					_mainTab.addItem(newItem);
			}
			
			applyButt.visible = false;
			backButt.visible = false;
			
			checkLeftRight();
		}
		
		protected function onApplyButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			if (!_canSend)
				return;
			
			visible = !visible;
			
			if (!sendAfterConfirm)
				GuiManager.instance.friendsWindow.visible = true;
			else
			{
				giftController.sendGift();
				giftController.unselect();
				
				(ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller).clearSelected();
				
				var sCase : StringCase = StringManager.instance.getCase(StringTypes.GiftAlert);
				
				GuiManager.instance.giftWindow(sCase.title, sCase.message);
			}
			
			sendAfterConfirm = false;
		}
		
		protected function onLeftButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoLeft();
			
			checkLeftRight();
		}
		
		protected function onRightButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoRight();
			
			checkLeftRight();
		}
		
		protected function onCloseButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			sendAfterConfirm = false;
			giftController.unselect();
			visible = !visible;
		}
		
		protected function onMouseEvent(e : Event) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			if (e.currentTarget == chooseButt)
				if (!_canSend)
					return;
			
			if (e.currentTarget == leftButt && !_mainTab.canLeft)
				return;
			
			if (e.currentTarget == rightButt && !_mainTab.canRight)
				return;
			
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
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
			{
				if (sendAfterConfirm)
					chooseButt["Title1"].text = "подарить";
				else
					chooseButt["Title1"].text = "выбрать";
				
				chooseButt.gotoAndStop(3);
				_canSend = false;
				
				unselect();
				
				GuiManager.instance.windowOpened(this);
			}
			else
				GuiManager.instance.windowClosed(this);
		}		
		
		protected function unselect() : void
		{
			giftController.unselect();
		}
		
		protected const _closeButt : String = "Close";
		protected const _applyButt : String = "ApplyButton";
		protected const _chooseButt : String = "ChooseButton";		
		protected const _leftButt : String = "LeftButton";		
		protected const _rightButt: String = "RightButton";
		protected const _titleField : String = "Title";
		protected const _stickers : String = "Stickers";
		protected const _backButt : String = "BackButton";
		
		protected const _help : String = "Help";
		
		protected function get help() :  MovieClip
		{
			return _skin[_help];
		}
		
		protected function get chooseButt() : MovieClip
		{
			return _skin[_chooseButt] as MovieClip;
		}		
		
		protected function get backButt() : MovieClip
		{
			return _skin[_backButt] as MovieClip;
		}
		
		protected function get stickers() : MovieClip
		{
			return _skin[_stickers] as MovieClip;
		}
		
		protected function get giftController() : GiftController
		{
			return ControllerManager.instance.getController(ControllerNames.GiftController) as GiftController;
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
		
		protected function get applyButt() : MovieClip
		{
			return _skin[_applyButt] as MovieClip;
		}
		
		protected function get leftButt() : MovieClip
		{
			return _skin[_leftButt] as MovieClip;
		}
		
		protected function get rightButt() : MovieClip
		{
			return _skin[_rightButt] as MovieClip;
		}
		
		protected function get titleTextField() : TextField
		{
			return _skin[_titleField] as TextField;
		}
	}
	
	
}