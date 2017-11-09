package com.sigma.socialgame.view.gui.components.shop
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.shop.ShopController;
	import com.sigma.socialgame.controller.shop.clients.ExpandShopClient;
	import com.sigma.socialgame.controller.shop.objects.ExpandShopObject;
	import com.sigma.socialgame.controller.shop.objects.ShopObject;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.help.HelpCaseType;
	import com.sigma.socialgame.view.gui.components.help.HelpManager;
	import com.sigma.socialgame.view.gui.components.quest.QuestBar;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.core.Starling;
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import flash.geom.Rectangle;
	
	public class Shop extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _mask : Sprite;
		private var _currShop : Sprite;
		private var _shops : Vector.<Sprite>;
		private var _shopScreens : Vector.<int>;
		private var _currShopScreen : Vector.<int>;
		
		private var _selTab : ShopTab;
		
		private var _tabs : Vector.<ShopTab>;
		
		private const _tabCount : int = 6; 
		
		private var _shopStart : int;
		private var _shopEnd : int;
		private var _shopWidth : int;
		
		//private var _shopMasks : Vector.<Shape>;
		
		private var itemWidth:int = 142;
		private var itemX:int = 42;
			
		private var _onScreenItems : int = 5;
		private var _moveWidth : int = itemWidth*_onScreenItems;
		
		private var _canLeft : Boolean = true;
		private var _canRight : Boolean = true;
		
		private var _moving : Boolean;
		private var _start : int;
		private var _needMove : int;
		private var _moved : int;
		private var _delta : int;
		
		private var _speed : int = 75;
		
		private static var _instance : Shop;
		private var help:Button;
		private var leftButton:Button;
		private var rightButton:Button;
		
		public function Shop()
		{
			super();
			
			_instance = this;
			visible = false;
			
			var bg:Image = new Image(SkinManager.instance.getSkinTexture("shopBack"));
			addChild(bg);
			
			var bg2:Image = new Image(SkinManager.instance.getSkinTexture("shopBack2"));
			bg2.y = -bg2.height;
			bg2.width = bg.width;
			addChild(bg2);
			
			//var clazz : Class = SkinManager.instance.getSkin(GuiIds.Shop);
			
			//if (clazz != null)
			//{
				//_skin = new clazz();
				
				_shopStart = 40;
				_shopEnd = width - _shopStart;
				_shopWidth = _shopEnd - _shopStart;
				
				initShop();
			//}
		}
		
		protected function onHelp(e : Object) : void
		{
			HelpManager.instance.showHelpCase(HelpCaseType.ShopHelp);
		}
		
		protected function initShop() : void
		{
			var i : int = 0;
			
			leftButton = new Button(SkinManager.instance.getSkinTexture("shopLeftButton0001"), "", SkinManager.instance.getSkinTexture("shopLeftButton0002"), null, SkinManager.instance.getSkinTexture("shopLeftButton0003"));
			leftButton.pivotX = leftButton.width/2;
			leftButton.pivotY = leftButton.height/2;
			leftButton.x = 20;
			leftButton.y = 80;
			leftButton.scaleWhenDown = 0.9;
			addChild(leftButton);
			
			rightButton = new Button(SkinManager.instance.getSkinTexture("shopLeftButton0001"), "", SkinManager.instance.getSkinTexture("shopLeftButton0002"), null, SkinManager.instance.getSkinTexture("shopLeftButton0003"));
			rightButton.pivotX = rightButton.width/2;
			rightButton.pivotY = rightButton.height/2;
			rightButton.scaleX = -1;
			rightButton.x = width - 20;
			rightButton.y = 80;
			rightButton.scaleWhenDown = 0.9;
			addChild(rightButton);
			
			leftButton.addEventListener(Event.TRIGGERED, onLeftMouseEvent);
			rightButton.addEventListener(Event.TRIGGERED, onRightMouseEvent);
			
			/*_shopMasks = new Vector.<Shape>();
			
			for (i = 0; i < _tabCount; i++)
			{
				_shopMasks[i] = new Shape();
				
				var gr : Graphics = _shopMasks[i].graphics;
				
				gr.beginFill(0xFFFFFF, 0.0);
				gr.drawRect(_shopStart, 0, _shopWidth, _skin.width);
				gr.endFill();
				
				addChild(_shopMasks[i]);
			}*/
			
			var sCon : ShopController = ControllerManager.instance.getController(ControllerNames.ShopController) as ShopController;
			var newSI : ShopItem;
			
			_tabs = new Vector.<ShopTab>();
			
			var names : Array = ["tab_jobs", "tab_employees", "tab_room_decor", "tab_wall_decor", "tab_trim", "tab_office_extension"];
			var nextX : Number = 0;
			
			for (i = 0; i < _tabCount; i++)
			{
				_tabs[i] = new ShopTab(names[i]);
				
				addChild(_tabs[i]);
				
				_tabs[i].y = -_tabs[i].height;
				_tabs[i].x = nextX;
				
				nextX += _tabs[i].width;
				
				_tabs[i].addEventListener(Event.TRIGGERED, onTabMouseEvent);
			}
			
			_tabs[0].selected(true);
			_selTab = _tabs[0];
			
			_shops = new Vector.<Sprite>();
			_mask = new Sprite();
			_mask.clipRect = new Rectangle(40,-10,725,170);
			addChild(_mask);
				
			for (i = 0; i < _tabCount; i++)
			{
				_shops[i] = new Sprite();
				
				_mask.addChild(_shops[i]);
				
				_shops[i].visible = false;
				
				//_shops[i].x = _shopStart;
				
				//_shops[i].mask = _shopMasks[i];
				
				_shops[i].addEventListener(Event.TRIGGERED, onShopEvent);
			}
			
			_currShop = _shops[0];
			_shops[0].visible = true;
			
			var tabs : Vector.<int> = new Vector.<int>();
			
			for (i = 0; i < _tabCount; i++)
				tabs[i] = 0;
			
			for each (var so : ShopObject in sCon.shop)
			{
				newSI = new ShopItem();
				newSI.shopClient = sCon.getShopObjectClient(so);
				
				switch (newSI.shopClient.shopObject.object.type)
				{
					case ObjectTypes.Worker:
						
						_shops[1].addChild(newSI);
						
						newSI.x = itemX + (tabs[1]++) * itemWidth;
						
						break;
					
					case ObjectTypes.Workspace:
						
						_shops[0].addChild(newSI);
						
						newSI.x = itemX + (tabs[0]++) * itemWidth;
						
						break;
					
					case ObjectTypes.Decor:
						
						switch (newSI.shopClient.shopObject.object.place)
						{
							case ObjectPlaces.Cell:
								
								_shops[2].addChild(newSI);
								
								newSI.x = itemX + (tabs[2]++) * itemWidth;
								
								break;
							
							case ObjectPlaces.Wall:
								
								_shops[3].addChild(newSI);
								
								newSI.x = itemX + (tabs[3]++) * itemWidth;
								
								break;
						}
						
						break;
					
					case ObjectTypes.Trim:
						
						_shops[4].addChild(newSI);
						
						newSI.x = itemX + (tabs[4]++) * itemWidth;
						
						break;
				}
			}
			
			var newEI : ExpandShopItem;
			var client : ExpandShopClient;
			
			for each (var exp : ExpandShopObject in sCon.expand)
			{
				client = sCon.getExpandObjectClient(exp);
				
				if (!client.canExpand)
				{
					//continue;
				}
			
				newEI = new ExpandShopItem();
				newEI.expClient = client;
				
				_shops[5].addChild(newEI);
				newEI.x = itemX + (tabs[5]++) * itemWidth;
			}
			
			_currShopScreen = new Vector.<int>();
			_shopScreens = new Vector.<int>();
			
			for (i = 0; i < _tabCount; i++)
			{
				var bias : int = (tabs[i] % _onScreenItems == 0 ? 0 : 1);
				
				_shopScreens[i] = tabs[i] / _onScreenItems + bias;
				_currShopScreen[i] = 1;
			}
			
			checkButtons();
			showItems(-_currShop.x, -_currShop.x + _moveWidth);
		}
		
		protected function checkButtons() : void
		{
			var ind : int = _shops.indexOf(_currShop);
			
			if (_currShopScreen[ind] == _shopScreens[ind])
			{
				_canRight = false;
				
				rightButton.enabled = false;
			}
			else
			{
				_canRight = true;
				
				rightButton.enabled = true;
			}
			
			if (_currShopScreen[ind] == 1)
			{
				_canLeft = false;
				
				leftButton.enabled = false;
			}
			else
			{
				_canLeft = true;
				
				leftButton.enabled = true;
			}
		}
		
		protected function onShopEvent(e : Object) : void
		{
			if (_moving)
				e.stopPropagation();
		}
		
		protected function onRightMouseEvent(e : Object) : void
		{
			var ind : int = _shops.indexOf(_currShop);
			
			if (!_moving)
				if (_currShopScreen[ind] < _shopScreens[ind])
				{
					_currShopScreen[ind]++;
					moveShop(-_moveWidth);
					showItems(-_currShop.x, -_currShop.x + _moveWidth + _moveWidth);
					
					checkButtons();
				}
		}
		
		protected function onLeftMouseEvent(e : Object) : void
		{
			if (!_moving)
				if (_currShopScreen[_shops.indexOf(_currShop)] > 1)
				{
					_currShopScreen[_shops.indexOf(_currShop)]--;
					moveShop(_moveWidth);
					showItems(-_currShop.x - _moveWidth, -_currShop.x + _moveWidth);
					
					checkButtons();
				}
		}
		
		protected function endMove() : void
		{
			if (_moving)
			{
				//_currShop.x = _start + _needMove;
				
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				showItems(-_currShop.x, -_currShop.x + _moveWidth);
				
				_moving = false;
			}
		}
		
		protected function showItems(x1 : int, x2 : int) : void
		{
			for (var i:int=0; i<_currShop.numChildren; i++) {
				var item:Object = _currShop.getChildAt(i) as Object;
				item.visible = item.x>=x1 && item.x<=x2;
			}
		}
		
		protected function moveShop(len_ : int) : void
		{
			_start = _currShop.x;
			_needMove = len_;
			_moved = 0;
			
			_delta = _needMove / Math.abs(_needMove) * _speed;
			
			_moving = true;
			
			Starling.juggler.tween(_currShop, 0.5, {delay:0, transition:Transitions.EASE_IN_OUT, x:_currShop.x + len_, onComplete:endMove});
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(e : Event) : void
		{
			_currShop.x += _delta;
			
			_moved += _delta;
			
			if (Math.abs(_moved) >= Math.abs(_needMove))
			{
				endMove();
			}
		}
		
		private var _tabLocked : Boolean = false;
		
		public function lockTabs() : void
		{
			_tabLocked = true;
		}
		
		public function unlockTabs() : void
		{
			_tabLocked = false;
		}
		
		public function selectWorkspace() : void
		{
//			var names : Array = [GuiIds.WorkspaceTab, GuiIds.WorkerTab, GuiIds.DecorCellTab, GuiIds.DecorWallTab, GuiIds.TrimTab, GuiIds.SizeTab];
			
			for each (var tab : ShopTab in _tabs)
			{
				if (tab.imageName == GuiIds.WorkspaceTab)
				{
					tab.dispatchEvent(new Event(Event.TRIGGERED));
					
					return;
				}
			}
		}
		
		public function selectWorker() : void
		{
			for each (var tab : ShopTab in _tabs)
			{
				if (tab.imageName == GuiIds.WorkerTab)
				{
					tab.dispatchEvent(new Event(Event.TRIGGERED));
					
					return;
				}
			}
		}
		
		protected function onTabMouseEvent(e : Object) : void
		{
			/*if (_tabLocked)
			{
				QuestBar.instance.showFirstWindow();
				
				return;
			}*/
			
			endMove();
			
			var ind : int = _tabs.indexOf(e.currentTarget);
			
			_selTab.selected(false);
			
			_selTab = e.currentTarget as ShopTab;
			_selTab.selected(true);
			
			_currShop.visible = false;
			_shops[ind].visible = true;
			_currShop = _shops[ind];
			
			checkButtons();
			showItems(-_currShop.x, -_currShop.x + _moveWidth);
		}
		
		public override function set visible(value:Boolean):void
		{
			if (value == visible)
				return;
			
			super.visible = value;
			
			if (visible == false)
				Map.instance.cancelBuy();
		}
		
		public static function get instance() : Shop
		{
			return _instance;
		}
		
		/*protected function get help() : MovieClip
		{
			return _skin[_help];
		}
		
		protected function get leftButton() : MovieClip
		{
			return _skin[_leftButton];
		}
		
		protected function get rightButton() : MovieClip
		{
			return _skin[_rightButton];
		}*/
	}
}