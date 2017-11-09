package com.sigma.socialgame.view.gui
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.quest.QuestController;
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.QuestControllerEvent;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.events.view.FieldEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.events.view.gui.GuiManagerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	import com.sigma.socialgame.sound.SoundEvents;
	import com.sigma.socialgame.sound.SoundManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.GameEntity;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;
	import com.sigma.socialgame.view.gui.components.AlertWindow;
	//import com.sigma.socialgame.view.gui.components.Button;
	import com.sigma.socialgame.view.gui.components.ConfirmWindow;
	import com.sigma.socialgame.view.gui.components.ErrorAlert;
	import com.sigma.socialgame.view.gui.components.GiftAlert;
	import com.sigma.socialgame.view.gui.components.InfoBar;
	import com.sigma.socialgame.view.gui.components.ManureAlert;
	import com.sigma.socialgame.view.gui.components.ToolTip;
	import com.sigma.socialgame.view.gui.components.bubble.Bubble;
	import com.sigma.socialgame.view.gui.components.bubble.BubbleType;
	import com.sigma.socialgame.view.gui.components.customize.CustomizeWindow;
	import com.sigma.socialgame.view.gui.components.friends.FriendsWindow;
	import com.sigma.socialgame.view.gui.components.friends.bar.FriendBar;
	import com.sigma.socialgame.view.gui.components.gifts.ConfirmGiftsWindow;
	import com.sigma.socialgame.view.gui.components.gifts.GiftsWindow;
	import com.sigma.socialgame.view.gui.components.help.HelpWindow;
	import com.sigma.socialgame.view.gui.components.inventory.InventoryWindow;
	import com.sigma.socialgame.view.gui.components.menu.EntityMenu;
	import com.sigma.socialgame.view.gui.components.menu.EntityMenuNoSell;
	import com.sigma.socialgame.view.gui.components.menu.EntityMenuRotate;
	import com.sigma.socialgame.view.gui.components.money.BuyOkWindow;
	import com.sigma.socialgame.view.gui.components.money.NoMoneyWindow;
	import com.sigma.socialgame.view.gui.components.money.TransferWindow;
	import com.sigma.socialgame.view.gui.components.quest.ConfirmQuestWindow;
	import com.sigma.socialgame.view.gui.components.quest.QuestBar;
	import com.sigma.socialgame.view.gui.components.quest.QuestWindow;
	import com.sigma.socialgame.view.gui.components.shop.Shop;
	import com.sigma.socialgame.view.gui.components.task.TaskChoice;
	import com.sigma.socialgame.view.gui.components.task.TaskInfo;
	import com.sigma.socialgame.view.gui.place.Align;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	import com.sigma.socialgame.view.gui.place.Place;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	import com.sigma.socialgame.view.game.MyOfficeGame;
	import com.sigma.socialgame.view.game.StarlingRoot;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.Event;
	
//	import mx.managers.CursorManager;
	
	public class GuiManager extends Sprite
	{
		private var _eventDisp : EventDispatcher;
		
		private static var _instance : GuiManager;
		
		//private var _darker : MovieClip;
		
		private var _taskInfo : TaskInfo;
		private var _taskChoice : TaskChoice;
		
		private var _entityMenu : EntityMenu;
		private var _entityMenuNoSell : EntityMenuNoSell; 
		private var _entityMenuRotate : EntityMenuRotate;
		
		private var _infoBar : InfoBar;
		private var _toolTip : ToolTip;
		
		private var _shop : Shop;
		private var _friends : FriendBar;

		private var _transferWindow : TransferWindow;
		private var _noMoneyWindow : NoMoneyWindow;
		private var _buyOkWindow : BuyOkWindow;
		
		private var _confirmWindow : ConfirmWindow;
		
		private var _questBar : QuestBar;
		
		private var _questWindow : QuestWindow;
		private var _giftsWindow : GiftsWindow;
		private var _friendsWindow : FriendsWindow;
		private var _customWindow : CustomizeWindow;
		private var _confirmGiftsWindow : ConfirmGiftsWindow;
		
		private var _manureWindow : ManureAlert;
		private var _giftWindow : GiftAlert;
		private var _errorWindow : ErrorAlert;
		
		private var _alertWindow : AlertWindow;
		
		private var _invWindow : InventoryWindow;
		
		private var _cancelBuyButton : Button;
		
		private var _confirmQuestWindow : ConfirmQuestWindow;
		
		private var _helpWindow : HelpWindow;
		
		private var _selectButt : Button;
		private var _friendButt : Button; 
		private var _moveButt : Button;
		private var _rotateButt : Button;
		private var _sellButt : Button;
		
		private var _shopButt : Button;
		private var _giftButt : Button;
		private var _custButt : Button;
		private var _invButt : Button;
//		private var _questButt : Button;
		private var _homeButt : Button;
		
		private var _selectCur : Class;
		private var _moveCur : Class;
		private var _rotateCur : Class;
		private var _sellCur : Class;
		
		private var _selectCurInd : int;
		private var _moveCurInd : int;
		private var _rotateCurInd : int;
		private var _sellCurInd : int;
		
		private var _inited : Boolean = false;
		
		private var _menusLocked : Boolean = false;
		private var _buttonsLocked : Boolean = false;
		private var _buttonUnselectedScale : Number = 0.6;
		private var _buttonSelectedScale : Number = 0.8;
		private var _taskChoiseLocked : Boolean = false;
		
		public function GuiManager()
		{
			super();
			
			_instance = this;
			
			_eventDisp = new EventDispatcher();
		}
		
		public function get friendsWindow() : FriendsWindow
		{
			return _friendsWindow;
		}
		
		public function get giftsWindow() : GiftsWindow
		{
			return _giftsWindow;
		}
		
		public function init() : void
		{
			GuiPlaces.init(initAll);
		}
			
		protected function initAll() : void
		{
			_taskInfo = new TaskInfo();
			_entityMenu = new EntityMenu();
			_entityMenuNoSell = new EntityMenuNoSell();
			_entityMenuRotate = new EntityMenuRotate();
			
			//_darker = new (SkinManager.instance.getSkin(GuiIds.Darker))();
			
//			addChild(_darker);
			
//			_darker.visible = false;
			
			addChild(_taskInfo);
			
			_taskInfo.visible = false;
			
			addChild(_entityMenu);
			addChild(_entityMenuNoSell);
			addChild(_entityMenuRotate);
			
			_entityMenu.visible = false;
			_entityMenuNoSell.visible = false;
			_entityMenuRotate.visible = false;
			
			_entityMenu.x = 400;
			_entityMenu.y = 400;
			_entityMenuNoSell.x = 400;
			_entityMenuNoSell.y = 400;
			_entityMenuRotate.x = 400;
			_entityMenuRotate.y = 400;
			
			_toolTip = new ToolTip();
			
			addChild(_toolTip);
			
			_toolTip.visible = false;

//---------------

			var indBias : int = 4;
			
//			_selectButt = new Button(GuiIds.SelectButton);
//			_moveButt = new Button(GuiIds.MoveButton);
//			_rotateButt = new Button(GuiIds.RotateButton);
//			_sellButt = new Button(GuiIds.SellButton);
			_shopButt = new Button(SkinManager.instance.getSkinTexture("buttonShop"));
			_giftButt = new Button(SkinManager.instance.getSkinTexture("buttonGifts"));
			_custButt = new Button(SkinManager.instance.getSkinTexture("buttonCust"));
			_invButt = new Button(SkinManager.instance.getSkinTexture("buttonInventory"));
//			_questButt = new Button(GuiIds.QuestButton);
			_friendButt = new Button(SkinManager.instance.getSkinTexture("buttonFriends"));
			_homeButt = new Button(SkinManager.instance.getSkinTexture("buttonHome"));
			_cancelBuyButton = new Button(SkinManager.instance.getSkinTexture("buttonCancel"));
			
			var buttons : Array = 
				[
//					{Button: _selectButt, 		Place: GuiPlaces.SelectButtonPlace, 	GuiId: GuiIds.SelectButton},
//					{Button: _moveButt, 		Place: GuiPlaces.MoveButtonPlace, 		GuiId: GuiIds.MoveButton},
//					{Button: _rotateButt, 		Place: GuiPlaces.RotateButtonPlace, 	GuiId: GuiIds.RotateButton},
//					{Button: _sellButt, 		Place: GuiPlaces.SellButtonPlace, 		GuiId: GuiIds.SellButton},
					{Button: _shopButt, 		Place: GuiPlaces.ShopButtonPlace, 		GuiId: GuiIds.ShopButton},
					{Button: _giftButt, 		Place: GuiPlaces.GiftButtonPlace, 		GuiId: GuiIds.GiftsButton},
					{Button: _custButt, 		Place: GuiPlaces.CustButtonPlace, 		GuiId: GuiIds.CustomizeButton},
					{Button: _invButt, 			Place: GuiPlaces.InventoryButtonPlace, 	GuiId: GuiIds.InventoryButton},
//					{Button: _questButt, 		Place: GuiPlaces.QuestButtonPlace, 		GuiId: GuiIds.QuestButton},
					{Button: _friendButt, 		Place: GuiPlaces.FriendButtonPlace, 	GuiId: GuiIds.FriendButton},
					{Button: _homeButt, 		Place: GuiPlaces.HomeButtonPlace, 		GuiId: GuiIds.HomeButton},
					{Button: _cancelBuyButton, 	Place: GuiPlaces.CancelBuyButton, 		GuiId: GuiIds.CancelBuyButton},
				];
			
			var button : Object;
			
			for each (button in buttons)
			{
				button.Button.pivotX = button.Button.width/2;
				button.Button.pivotY = button.Button.height*0.8;
				button.Button.scaleWhenDown = 0.9;
				(Starling.current.root as StarlingRoot).addChild(button.Button);
				
				if (button.GuiId == GuiIds.SelectButton || button.GuiId == GuiIds.FriendButton)
					button.Button.scaleX = button.Button.scaleY = _buttonSelectedScale;
				else 
					button.Button.scaleX = button.Button.scaleY = _buttonUnselectedScale;
				
				if (button.GuiId == GuiIds.HomeButton || 
					button.GuiId == GuiIds.CancelBuyButton
					)
					button.Button.visible = false;
				
				button.Button.addEventListener(Event.TRIGGERED, onButtonClick);
			}
			
//---------------------
			
			_taskChoice = new TaskChoice();
			_infoBar = new InfoBar();
			_shop = new Shop();
			_friends = new FriendBar();
			_questWindow = new QuestWindow();
			_transferWindow = new TransferWindow();
			_buyOkWindow = new BuyOkWindow();
			_noMoneyWindow = new NoMoneyWindow();
			_confirmWindow = new ConfirmWindow();
			_giftsWindow = new GiftsWindow();
			_confirmGiftsWindow = new ConfirmGiftsWindow();
			_friendsWindow = new FriendsWindow();
			_customWindow = new CustomizeWindow();
			_alertWindow = new AlertWindow();
			_helpWindow = new HelpWindow();
			_invWindow = new InventoryWindow();
			_questBar = new QuestBar();
			_confirmQuestWindow = new ConfirmQuestWindow();
			_manureWindow = new ManureAlert();
			_errorWindow = new ErrorAlert();
			_giftWindow = new GiftAlert();
			
			(Starling.current.root as StarlingRoot).addChild(_friends);
			(Starling.current.root as StarlingRoot).addChild(_shop);
			(Starling.current.root as StarlingRoot).addChild(_infoBar);
			(Starling.current.root as StarlingRoot).addChild(_questBar);
			
			var windows : Array =
				[
					{Window: _taskChoice, 			Place: GuiPlaces.TaskChoicePlace, 			GuiId: GuiIds.TaskChoice},
//					{Window: _infoBar, 				Place: GuiPlaces.InfoBarPlace, 				GuiId: GuiIds.InfoBar},
//					{Window: _shop, 				Place: GuiPlaces.ShopPlace, 				GuiId: GuiIds.Shop},
//					{Window: _friends, 				Place: GuiPlaces.FriendsPlace,	 			GuiId: GuiIds.FriendBar},
					{Window: _questWindow, 			Place: GuiPlaces.QuestWindowPlace,	 		GuiId: GuiIds.QuestWindow},
					{Window: _transferWindow, 		Place: GuiPlaces.TransferWindowPlace, 		GuiId: GuiIds.TransferWindow},
					{Window: _buyOkWindow, 			Place: GuiPlaces.BuyOkWindowPlace, 			GuiId: GuiIds.BuyOkWindow},
					{Window: _noMoneyWindow, 		Place: GuiPlaces.NoMoneyWindowPlace, 		GuiId: GuiIds.NoMoneyWindow},
					{Window: _confirmWindow, 		Place: GuiPlaces.ConfirmWindowPlace, 		GuiId: GuiIds.ConfirmWindow},
					{Window: _giftsWindow, 			Place: GuiPlaces.GiftsWindowPlace, 			GuiId: GuiIds.GiftsWindow},
					{Window: _confirmGiftsWindow, 	Place: GuiPlaces.ConfirmGiftsWindowPlace, 	GuiId: GuiIds.ConfirmGiftsWindow},
					{Window: _friendsWindow, 		Place: GuiPlaces.FriendsWindowPlace, 		GuiId: GuiIds.FriendsWindow},
					{Window: _customWindow, 		Place: GuiPlaces.CustomizeWindowPlace, 		GuiId: GuiIds.CustomizeWindow},
					{Window: _alertWindow,	 		Place: GuiPlaces.AlertWindowPlace, 			GuiId: GuiIds.AlertWindow},
					{Window: _invWindow,	 		Place: GuiPlaces.InventoryWindowPlace, 		GuiId: GuiIds.InventoryWindow},
					{Window: _helpWindow,	 		Place: GuiPlaces.HelpWindowPlace, 			GuiId: GuiIds.HelpWindow},
//					{Window: _questBar,	 			Place: GuiPlaces.QuestBarPlace, 			GuiId: ""},
					{Window: _confirmQuestWindow,	Place: GuiPlaces.ConfirmQuestWindowPlace, 	GuiId: GuiIds.ConfirmQuestWindow},
					{Window: _manureWindow,			Place: GuiPlaces.ManureAlertPlace, 			GuiId: GuiIds.AlertWindow},
					{Window: _errorWindow,			Place: GuiPlaces.ErrorAlertPlace, 			GuiId: GuiIds.AlertWindow},
					{Window: _giftWindow,			Place: GuiPlaces.GiftAlertPlace, 			GuiId: GuiIds.AlertWindow},
				];
			
			var window : Object;
			
			for each (window in windows)
			{
				addChild(window.Window);

				if (window.GuiId == GuiIds.TaskChoice ||
					window.GuiId == GuiIds.Shop ||
					window.GuiId == GuiIds.QuestWindow ||
					window.GuiId == GuiIds.TransferWindow ||
					window.GuiId == GuiIds.BuyOkWindow ||
					window.GuiId == GuiIds.NoMoneyWindow ||
					window.GuiId == GuiIds.ConfirmWindow ||
					window.GuiId == GuiIds.GiftsWindow ||
					window.GuiId == GuiIds.ConfirmGiftsWindow ||
					window.GuiId == GuiIds.FriendsWindow ||
					window.GuiId == GuiIds.CustomizeWindow ||
					window.GuiId == GuiIds.AlertWindow ||
					window.GuiId == GuiIds.InventoryWindow ||
					window.GuiId == GuiIds.HelpWindow
					)
					window.Window.visible = false;
			}
			place(stage.displayState == StageDisplayState.FULL_SCREEN);
			
			/*for each (button in buttons)
			{
				setChildIndex(button.Button, Math.min(button.Place.place.z + indBias, numChildren-1));
			}*/
			
			for each (window in windows)
			{
				setChildIndex(window.Window, Math.min(window.Place.place.z + indBias, numChildren-1));
			}
			
			//-------
			
			_selectCur = SkinManager.instance.getSkin(GuiIds.SelectCursor);
			_moveCur = SkinManager.instance.getSkin(GuiIds.MoveCursor);
			_rotateCur = SkinManager.instance.getSkin(GuiIds.RotateCursor);
			_sellCur = SkinManager.instance.getSkin(GuiIds.SellCursor);

			Field.instance.addEventListener(FieldEvent.MouseModeChanged, onFieldEvent);
			
			//stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			
			(ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController).addEventListener(WalletControllerEvent.AmountChanged, onAmountAdded);
			(ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController).addEventListener(QuestControllerEvent.QuetsDone, onQuestDone);
			
			_inited = true;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.Inited));
		}
		
		public function errorWindow() : void
		{
			var sCase : StringCase = StringManager.instance.getCase(StringTypes.ErrorAlert);
			
			_errorWindow.showAlert(sCase.title, sCase.message, false);
		}
		
		public function manureWindow(title_ : String, message_ : String) : void
		{
			_manureWindow.showAlert(title_, message_);
		}
		
		public function giftWindow(title_ : String, message_ : String) : void
		{
			_giftWindow.showAlert(title_, message_);
		}
		
		public function windowClosed(window_ : Sprite) : void
		{
			MyOfficeGame.instance.fade = null;
		}
		
		public function windowOpened(window_ : Sprite) : void
		{
			//window_.addChildAt(_darker, 0);
			
			var point : Point = window_.globalToLocal(new Point(0, 0));
			
			MyOfficeGame.instance.fade = MyOfficeGame.instance.fadeFilter;
			
			/*_darker.x = point.x;
			_darker.y = point.y;
			
			_darker.width = MyOfficeGame.instance.dim.x;
			_darker.height = MyOfficeGame.instance.dim.y;*/
		}
		
		public function set waiting(waiting_ : Boolean) : void
		{
			if (waiting_)
			{
				MyOfficeGame.instance.fade = MyOfficeGame.instance.fadeFilter;
				/*addChild(_darker);
				
				_darker.x = 0;
				_darker.y = 0;
				
				_darker.width = MyOfficeGame.instance.dim.x;
				_darker.height = MyOfficeGame.instance.dim.y;*/
			}
			else
			{
				MyOfficeGame.instance.fade = null;
				//removeChild(_darker);
			}
		}
		
		protected function onQuestDone(e : QuestControllerEvent) : void
		{
			_confirmQuestWindow.visible = true;
			_confirmQuestWindow.confirmQuest = e.quest;
		}
		
		protected function onAmountAdded(e : WalletControllerEvent) : void
		{
			if (Map.instance.playerAvatar.parent == null)
				return;
			
			var newBubble : Bubble;
			
			if (e.delta == null)
				return;
			
			var yDelta : Number;
			
			switch (e.delta.currency.type)
			{
				case CurrencyType.Coin:
					newBubble = new Bubble(BubbleType.Coins, e.delta.amount);
					yDelta = 0;
					break;
				
				case CurrencyType.Experience:
					newBubble = new Bubble(BubbleType.Experience, e.delta.amount);
					yDelta = newBubble.height;
					break;
				
				case CurrencyType.Gold:
					newBubble = new Bubble(BubbleType.Gold, e.delta.amount);
					yDelta = newBubble.height * 2;
					break;
			}
			
			addChild(newBubble);
	
			var avatarCoords : Point = new Point(Map.instance.playerAvatar.x, Map.instance.playerAvatar.y);
			
			var coords : Point = Map.instance.playerAvatar.parent.localToGlobal(avatarCoords);

			coords = this.globalToLocal(coords);
			
			newBubble.x = coords.x;
			newBubble.y = coords.y - 150 - yDelta;
			
			newBubble.bubble();
		}
		
		/*protected function onFullScreen(e : FullScreenEvent) : void
		{
			place(e.fullScreen);
		}*/
		
		protected function place(fullscreen : Boolean) : void
		{
			/*var buttons : Array = 
				[
//					{Button: _selectButt, 		Place: GuiPlaces.SelectButtonPlace},
//					{Button: _moveButt, 		Place: GuiPlaces.MoveButtonPlace},
//					{Button: _rotateButt, 		Place: GuiPlaces.RotateButtonPlace},
//					{Button: _sellButt, 		Place: GuiPlaces.SellButtonPlace},
					{Button: _shopButt, 		Place: GuiPlaces.ShopButtonPlace},
					{Button: _giftButt, 		Place: GuiPlaces.GiftButtonPlace},
					{Button: _custButt, 		Place: GuiPlaces.CustButtonPlace},
					{Button: _invButt, 			Place: GuiPlaces.InventoryButtonPlace},
//					{Button: _questButt, 		Place: GuiPlaces.QuestButtonPlace},
					{Button: _friendButt, 		Place: GuiPlaces.FriendButtonPlace},
					{Button: _homeButt, 		Place: GuiPlaces.HomeButtonPlace},
					{Button: _cancelBuyButton, 	Place: GuiPlaces.CancelBuyButton},
				];
			
			var button : Object;
			
			for each (button in buttons)
			{
				if (fullscreen)
				{
					placeFull(button.Button, button.Place);
				}
				else
				{
					button.Button.x = button.Place.place.x;
					button.Button.y = button.Place.place.y;
				}
			}*/
			
			var windows : Array =
				[
					{Window: _taskChoice, 			Place: GuiPlaces.TaskChoicePlace},
//					{Window: _infoBar, 				Place: GuiPlaces.InfoBarPlace},
//					{Window: _shop, 				Place: GuiPlaces.ShopPlace},
//					{Window: _friends, 				Place: GuiPlaces.FriendsPlace},
					{Window: _questWindow, 			Place: GuiPlaces.QuestWindowPlace},
					{Window: _transferWindow, 		Place: GuiPlaces.TransferWindowPlace},
					{Window: _buyOkWindow, 			Place: GuiPlaces.BuyOkWindowPlace},
					{Window: _noMoneyWindow, 		Place: GuiPlaces.NoMoneyWindowPlace},
					{Window: _confirmWindow, 		Place: GuiPlaces.ConfirmWindowPlace},
					{Window: _giftsWindow, 			Place: GuiPlaces.GiftsWindowPlace},
					{Window: _confirmGiftsWindow, 	Place: GuiPlaces.ConfirmGiftsWindowPlace},
					{Window: _friendsWindow, 		Place: GuiPlaces.FriendsWindowPlace},
					{Window: _customWindow, 		Place: GuiPlaces.CustomizeWindowPlace},
					{Window: _alertWindow,	 		Place: GuiPlaces.AlertWindowPlace},
					{Window: _invWindow,	 		Place: GuiPlaces.InventoryWindowPlace},
					{Window: _helpWindow,	 		Place: GuiPlaces.HelpWindowPlace},
//					{Window: _questBar,	 			Place: GuiPlaces.QuestBarPlace},
					{Window: _confirmQuestWindow,	Place: GuiPlaces.ConfirmQuestWindowPlace},
				];
			
			var window : Object;
			
			for each (window in windows)
			{
				if (fullscreen)
				{
					placeFull(window.Window, window.Place);
				}
				else
				{
					window.Window.x = window.Place.place.x;
					window.Window.y = window.Place.place.y;
				}
			}
		}
		
		public function onResize() {
			_infoBar.x = Starling.current.stage.stageWidth/2 - 807/2;
			_shop.x = Starling.current.stage.stageWidth/2 - 807/2;
			_shop.y = Starling.current.stage.stageHeight - 159;
			_friends.x = _shop.x;
			_friends.y = _shop.y;
			_questBar.x = _infoBar.x + 65;
			_questBar.y = _infoBar.y + 180;
			var dx:int = 50;
			var dy:int = 50;
			_friendButt.x = _shop.x + dx;
			_friendButt.y = _shop.y - dy;
			dx += (_friendButt.upState.width + _shopButt.upState.width + 10)/3;
			_shopButt.x = _shop.x + dx;
			_shopButt.y = _shop.y - dy;
			dx += (_shopButt.upState.width + _custButt.upState.width + 10)/3;
			_custButt.x = _shop.x + dx;
			_custButt.y = _shop.y - dy;
			dx += (_custButt.upState.width + _giftButt.upState.width + 10)/3;
			_giftButt.x = _shop.x + dx;
			_giftButt.y = _shop.y - dy;
			dx += (_giftButt.upState.width + _invButt.upState.width + 10)/3;
			_invButt.x = _shop.x + dx;
			_invButt.y = _shop.y - dy;
			_cancelBuyButton.x = _shop.x + _shop.width - 50;
			_cancelBuyButton.y = _shop.y - dy;
		}
		
		protected function placeFull(obj : Sprite, place_ : Place) : void
		{
			var align : Point;
			
 			switch (place_.fullScrrenAlign)
			{
				case Align.MiddleTop:
					
					align = new Point(MyOfficeGame.instance.dim.x / 2, 0);
					
					break;
				
				case Align.MiddleBottom:
					
					align = new Point(MyOfficeGame.instance.dim.x / 2, MyOfficeGame.instance.dim.y);
					
					break;
			}

			obj.x = align.x + place_.fullScreenPlace.x;
			obj.y = align.y + place_.fullScreenPlace.y;
		}
		
		public function showHelp(title_ : String, message_ : String, image_ : String) : void
		{
			_helpWindow.showHelp(title_, message_, image_);
		}
		
		public function showAlert(title_ : String, text_ : String) : void
		{
			_alertWindow.showAlert(title_, text_);
		}
		
		public function showConfirm(title_ : String, text_ : String, callback_ : Function) : void
		{
			_confirmWindow.show(title_, text_, callback_);
		}
		
		public function checkGifts() : void
		{
			if (_confirmGiftsWindow.checkGifts())
				_confirmGiftsWindow.visible = true;
		}
		
		public function myOffice(val_ : Boolean) : void
		{
			if (val_)
			{
				_shopButt.visible = true;
				_custButt.visible = true;
				_invButt.visible = true;
				_giftButt.visible = true;
				_friendButt.visible = true;
				
				_homeButt.visible = false;
			}
			else
			{
				_shopButt.visible = false;
				_custButt.visible = false;
				_invButt.visible = false;
				_giftButt.visible = false;
				_friendButt.visible = false;
				
				_homeButt.visible = true;
				
				_shop.visible = false;
			}
		}
		
		public function selectFriends() : void
		{
			trace("select friends")
			_friendButt.dispatchEvent(new Event(Event.TRIGGERED));
		}
		
		public function selectShop() : void
		{
			trace("select shop")
			_shopButt.dispatchEvent(new Event(Event.TRIGGERED));
		}
		
		public function lockTaskChoise() : void
		{
			_taskChoiseLocked = true;
		}
		
		public function unlockTaskChoise() : void
		{
			_taskChoiseLocked = false;
		}
		
		public function lockMenus() : void
		{
			_menusLocked = true;
		}
		
		public function unlockMenus() : void
		{
			_menusLocked = false;
		}
		
		public function lockButtons() : void
		{
			_buttonsLocked = true;
			/*_friendButt.locked = true;
			_shopButt.locked = true;
			_custButt.locked = true;
			_invButt.locked = true;
			_giftButt.locked = true;*/
			
			//_selectButt.locked = true;
			//_rotateButt.locked = true;
			//_moveButt.locked = true;
			//_sellButt.locked = true;
		}
		
		public function unlockButtons() : void
		{
			_buttonsLocked = false;
			/*_friendButt.locked = false;
			_shopButt.locked = false;
			_custButt.locked = false;
			_invButt.locked = false;
			_giftButt.locked = false;*/
			
			//_selectButt.locked = false;
			//_rotateButt.locked = false;
			//_moveButt.locked = false;
			//_sellButt.locked = false;
		}
		
		public function onFieldEvent(e : FieldEvent) : void
		{
			/*//CursorManager.removeAllCursors();

			var types : Array = 
				[
					MouseModes.Select,
					MouseModes.Move,
					MouseModes.Rotate,
					MouseModes.Sell,
				];
			
			var butt : Object = new Object();
			
			butt[MouseModes.Select] = _selectButt;
			butt[MouseModes.Move] =  _moveButt;
			butt[MouseModes.Rotate] = _rotateButt;
			butt[MouseModes.Sell] = _sellButt;
			
			for each (var type : String in types)
			{
				butt[type].selected = false;
			}
			
			butt[Field.instance.mouseMode].selected = true;
			
			switch (Field.instance.mouseMode)
			{
				case MouseModes.Select:
					
					//CursorManager.setCursor(_selectCur);

					break;
				
				case MouseModes.Move:
					
					//CursorManager.setCursor(_moveCur);
					
					break;
				
				case MouseModes.Rotate:
					
					//CursorManager.setCursor(_rotateCur);
					
					break;
				
				case MouseModes.Sell:
					
					//CursorManager.setCursor(_sellCur);
					
					break;
			}
			
			Map.instance.cancelBuy();*/
		}
		
		public function showQuestWindow(qo_ : QuestObject) : void
		{
			_questWindow.visible = !_questWindow.visible;
			
			_questWindow.questObject = qo_;
			
			SoundManager.instance.playEvent(SoundEvents.Window);
		}
		
		public function onButtonClick(e : Object) : void
		{
			SoundManager.instance.playEvent(SoundEvents.Click);
			if (_buttonsLocked && e.target!=_cancelBuyButton) {
				QuestBar.instance.showFirstWindow();
				return;
			}
				if (e.target==_shopButt) {
					
					if (!_shop.visible)
					{
						_shop.visible = true;
						_friends.visible = false;
					
						_shopButt.scaleX = _shopButt.scaleY = _buttonSelectedScale;
						_friendButt.scaleX = _friendButt.scaleY = _buttonUnselectedScale;
					}
					
				} else if (e.target==_giftButt) {
				
					_giftsWindow.visible = !_giftsWindow.visible;
					
					SoundManager.instance.playEvent(SoundEvents.Window);
					
				} else if (e.target==_custButt) {
					
					_customWindow.visible = !_customWindow.visible;
					
					SoundManager.instance.playEvent(SoundEvents.Window);
					
				} else if (e.target==_invButt) {
					
					_invWindow.visible = true;
					
				} else if (e.target==_homeButt) {
					
					ResourceManager.instance.returnToOffice();
					
				} else if (e.target==_cancelBuyButton) {
					
					Map.instance.cancelBuy();
					
				} else if (e.target==_friendButt) {
					
					if (_shop.visible)
					{
						_shop.visible = false;
						_friends.visible = true;
						
						_shopButt.scaleX = _shopButt.scaleY = _buttonUnselectedScale;
						_friendButt.scaleX = _friendButt.scaleY = _buttonSelectedScale;
					}
				}
					
		}
		
		public function showCancelBuyButton() : void
		{
			_cancelBuyButton.visible = true;
		}
		
		public function hideCancelBuyButton() : void
		{
			_cancelBuyButton.visible = false;
		}
		
		public function showToolTip(x : int, y : int, text : String) : void
		{
			_toolTip.x = x;
			_toolTip.y = y;
			_toolTip.textField.text = text;	
			
			_toolTip.visible = true;
		}
		
		public function hideToolTip() : void
		{
			_toolTip.visible = false;
		}
		
		public function showTaskInfo(workerEntity_ : WorkerEntity, task_ : CurrTaskData, job_ : JobData) : void
		{
			if (_taskInfo.visible)
				closeTaskInfo();
			
			_taskInfo.workerEntity = workerEntity_;
			_taskInfo.task = task_;
			_taskInfo.job = job_;
			
			_taskInfo.visible = true;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.TaskInfoShowed));
		}
		
		public function showTaskChoice(workerEntity_ : WorkerEntity) : void
		{
			if (_taskChoiseLocked)
				return;
			
			if (_taskChoice.visible)
				closeTaskChoise();
			
			_taskChoice.workerEntity = workerEntity_;
			
			_taskChoice.visible = true;
			
			SoundManager.instance.playEvent(SoundEvents.Window);
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.TaskChoiceShowed));
		}
		
		public function moveTaskInfo(coords_ :Point) : void
		{
			_taskInfo.x = coords_.x;
			_taskInfo.y = coords_.y;
		}
		
		public function showEntityMenu(gameEntity_ : GameEntity) : void
		{
			if (_menusLocked)
				return;
			
			closeMenus();
			
			_entityMenu.gameEntity = gameEntity_;
			_entityMenu.visible = true;
			
			var newX : Number = mouseX;
			var newY : Number = mouseY;
			
			if (newX + _entityMenu.width > MyOfficeGame.instance.dim.x)
				newX -= newX + _entityMenu.width - MyOfficeGame.instance.dim.x;
			
			if (newY + _entityMenu.height > MyOfficeGame.instance.dim.y)
				newY -= newY + _entityMenu.height - MyOfficeGame.instance.dim.y;
			
			moveEntityMenu(new Point(newX, newY));
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.EntityMenuShowed));
		}
		
		public function moveEntityMenu(coords_ : Point) : void
		{
			_entityMenu.x = coords_.x;
			_entityMenu.y = coords_.y;
		}
		
		public function closeEntityMenu() : void
		{
			_entityMenu.visible = false;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.EntityMenuClosed));
		}
		
		public function showEntityMenuNoSell(gameEntity_ : GameEntity) : void
		{
			if (_menusLocked)
				return;
			
			closeMenus();
			
			_entityMenuNoSell.gameEntity = gameEntity_;
			_entityMenuNoSell.visible = true;
			
			var newX : Number = mouseX;
			var newY : Number = mouseY;
			
			if (newX + _entityMenuNoSell.width > MyOfficeGame.instance.dim.x)
				newX -= newX + _entityMenuNoSell.width - MyOfficeGame.instance.dim.x;
			
			if (newY + _entityMenuNoSell.height > MyOfficeGame.instance.dim.y)
				newY -= newY + _entityMenuNoSell.height - MyOfficeGame.instance.dim.y;
			
			moveEntityMenuNoSell(new Point(newX, newY));
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.EntityMenuNoSellShowed));
		}
		
		public function moveEntityMenuNoSell(coors_ : Point) : void
		{
			_entityMenuNoSell.x = coors_.x;
			_entityMenuNoSell.y = coors_.y;
		}
		
		public function closeEntityMenuNoSell() : void
		{
			_entityMenuNoSell.visible = false;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.EntityMenuNoSellClosed));
		}
		
		public function showEntityMenuRotate(gameEntity_ : GameEntity) : void
		{
			if (_menusLocked)
				return;
			
			closeMenus();
			
			_entityMenuRotate.gameEntity = gameEntity_;
			_entityMenuRotate.visible = true;
			
			var newX : Number = mouseX;
			var newY : Number = mouseY;
			
			if (newX + _entityMenuRotate.width > MyOfficeGame.instance.dim.x)
				newX -= newX + _entityMenuRotate.width - MyOfficeGame.instance.dim.x;
			
			if (newY + _entityMenuRotate.height > MyOfficeGame.instance.dim.y)
				newY -= newY + _entityMenuRotate.height - MyOfficeGame.instance.dim.y;
			
			moveEntityMenuRotate(new Point(newX, newY));
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.EntityMenuRotateShowed));
		}
		
		public function moveEntityMenuRotate(coords_ : Point) : void
		{
			_entityMenuRotate.x = coords_.x;
			_entityMenuRotate.y = coords_.y;
		}
		
		public function closeEntityMenuRotate() : void
		{
			_entityMenuRotate.visible = false;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.EntityMenuRotateClosed));
		}
		
		public function closeMenus() : void
		{
			if (_entityMenu.visible)
				closeEntityMenu();
			
			if (_entityMenuNoSell.visible)
				closeEntityMenuNoSell();
			
			if (_entityMenuRotate.visible)
				closeEntityMenuRotate();
		}
		
		public function closeTaskChoise() : void
		{
			_taskChoice.visible = false;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.TaskChoiceClosed));
		}
		
		public function closeTaskInfo() : void
		{
			_taskInfo.visible = false;
			
			dispatchEvent(new GuiManagerEvent(GuiManagerEvent.TaskInfoClosed));
		}
		
		public function mapInited() : void
		{
			Map.instance.addEventListener(MapEvent.MapMoved, onMapMouseEvent);
			Map.instance.addEventListener(MapEvent.MapZoomed, onMapMouseEvent);
			Map.instance.addEventListener(MapEvent.MapClicked, onMapMouseEvent);
		}
		
		protected function onMapMouseEvent(e : MapEvent) : void
		{
			switch (e.type)
			{
				
				case MapEvent.MapClicked:
				case MapEvent.MapZoomed:
				case MapEvent.MapMoved:
					
					GuiManager.instance.closeMenus();
				
					break;
			}
		}
		
		public static function get instance() : GuiManager
		{
			return _instance;
		}

		public function get buyOkWindow():BuyOkWindow
		{
			return _buyOkWindow;
		}

		public function get noMoneyWindow():NoMoneyWindow
		{
			return _noMoneyWindow;
		}

		public function get transferWindow():TransferWindow
		{
			return _transferWindow;
		}

		public function get inited():Boolean
		{
			return _inited;
		}


	}
}