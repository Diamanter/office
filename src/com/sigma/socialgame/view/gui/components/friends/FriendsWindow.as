package com.sigma.socialgame.view.gui.components.friends
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.events.controller.FriendsControllerEvent;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.BaseTab;
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
	
	public class FriendsWindow extends Sprite
	{
		public static var ScreenDim : Array;
		
		private var _skin : MovieClip;
		private var _mainTab : BaseTab;
		
		private var _canSend : Boolean = false;
		
		private static var _instance : FriendsWindow;
		
		public function FriendsWindow()
		{
			super();
			
			_instance = this;
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.FriendsWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				ScreenDim = [GuiPlaces.FriendsWindowPlace.dim.x, GuiPlaces.FriendsWindowPlace.dim.y];
				
				addChild(_skin);
				
				chooseButt.gotoAndStop(1);
				
				applyButt.visible = false;
				
				var widgets : Array =
				[
					{ Widget: closeButt, Function: onCloseButtonClick },
					{ Widget: applyButt, Function: onApplyButtonClick },
					{ Widget: leftButt, Function: onLeftButtonClick },
					{ Widget: rightButt, Function: onRightButtonClick },
					{ Widget: help, Function: onHelp },
					{ Widget: backButt, Function: onBackButtonClick }
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
				
				applyButt.gotoAndStop(3);
				
				friendsController.addEventListener(FriendsControllerEvent.Selected, onFrConEvent);
				friendsController.addEventListener(FriendsControllerEvent.Unselected, onFrConEvent);
				
				init();
			}
		}
		
		public static function get instance() : FriendsWindow
		{
			return _instance;
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
		
		protected function onHelp(e : MouseEvent) : void
		{
			HelpManager.instance.showHelpCase(HelpCaseType.FriendsHelp);
		}
		
		protected function onFrConEvent(e : FriendsControllerEvent) : void
		{
			switch (e.type)
			{
				case FriendsControllerEvent.Selected:
					
					_canSend = true;
					
					applyButt.gotoAndStop(1);
					
					break;
				
				case FriendsControllerEvent.Unselected:
					
					if (friendsController.selected.length == 0)
					{
						_canSend = false;
						
						applyButt.gotoAndStop(3);
					}
					
					break;
			}
		}
		
		protected function init() : Boolean
		{
			_mainTab = new BaseTab(FriendsWindow.ScreenDim[0], FriendsWindow.ScreenDim[1]);
			
			stickers.addChild(_mainTab);
			
			var appFriends : Vector.<FriendObject> = friendsController.appFriends;
			
			var length : int = appFriends.length;

			var exist : Boolean = false;
			
			for (var i : int = 0; i < length; ++i)
			{
				if (appFriends[i].friend.gifts >= ParamManager.instance.getConfigParam(ParamType.GiftNum))
					continue;
				
				exist = true;
				
				var newItem : FriendItem = new FriendItem();
				newItem.appFriend = appFriends[i];
				_mainTab.addItem(newItem);
			}
			
			titleTextField.text = "Выбор друга";
			chooseButt.visible = false;
			
			checkLeftRight();
			
			return exist;
		}
		
		protected function onBackButtonClick(e : Event) : void
		{
			giftController.unselect();
			friendsController.clearSelected();
			visible = !visible;
			
			GuiManager.instance.giftsWindow.visible = true;
		}
		
		protected function onApplyButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
		
			if (!_canSend)
				return;
			
			giftController.sendGift();
			giftController.unselect();
			friendsController.clearSelected();
			visible = !visible;
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
			
			friendsController.clearSelected();
			giftController.unselect();
			visible = !visible;
		}
		
		protected function onMouseEvent(e : Event) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			if (mc == applyButt)
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
				GuiManager.instance.windowOpened(this);
				
				friendsController.clearSelected();
				
				_canSend = false;
				
				applyButt.gotoAndStop(3);
				
				stickers.removeChild(_mainTab);
				
				if (!init())
				{
					var sCase : StringCase = StringManager.instance.getCase(StringTypes.NoFriends);
					
					GuiManager.instance.showAlert(sCase.title, sCase.message);
					
					visible = false;
				}
			}
			else
				GuiManager.instance.windowClosed(this);
		}		
		
		protected function get friendsController() : FriendsContoller
		{
			return ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
		}
		
		protected function get giftController() : GiftController
		{
			return ControllerManager.instance.getController(ControllerNames.GiftController) as GiftController;
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
		
		protected function get help() : MovieClip
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