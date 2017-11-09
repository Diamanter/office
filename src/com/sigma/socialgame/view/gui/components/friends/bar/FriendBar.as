package com.sigma.socialgame.view.gui.components.friends.bar
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.friends.clients.AppFriendClient;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	import com.sigma.socialgame.controller.shop.ShopController;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
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
	
	public class FriendBar extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _mask : Sprite;
		private var _friendsScreens : int;
		private var _currFriendsScreen : int;
		
		private var _friends : Sprite;
		private var _friendsStart : int;
		private var _friendsEnd : int;
		private var _friendsWidth : int;

		private var _friendsMasks : Sprite;
		
		private var itemWidth:int = 120;
		private var itemX:int = 24;
			
		private var _onScreenItems : int = 6;
		private var _moveWidth : int = itemWidth*_onScreenItems;
		
		private var _moving : Boolean;
		private var _start : int;
		private var _needMove : int;
		private var _moved : int;
		private var _delta : int;
		
		private var _speed : int = 75;
		
		private var _canLeft : Boolean = true;
		private var _canRight : Boolean = true;
		private var help:Button;
		private var leftButton:Button;
		private var rightButton:Button;
		
		public function FriendBar()
		{
			super();
			
			//var clazz : Class = SkinManager.instance.getSkin(GuiIds.FriendBar);
			
			var bg:Image = new Image(SkinManager.instance.getSkinTexture("shopBack"));
			addChild(bg);
			
			var bg2:Image = new Image(SkinManager.instance.getSkinTexture("shopBack2"));
			bg2.y = -bg2.height;
			bg2.width = bg.width;
			addChild(bg2);
			
			initFriends();
		}
		
		protected function initFriends() : void
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
			
			_mask = new Sprite();
			_mask.clipRect = new Rectangle(40,0,725,160);
			addChild(_mask);
			
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			var newFI : FriendBarItem;
			var newFAI : AddFriendBarItem;
			
			_friends = new Sprite();
			
			_mask.addChild(_friends);
			
			_friends.x = _friendsStart;
			
			_friends.mask = _friendsMasks;
			
			_friends.addEventListener(Event.TRIGGERED, onFriendEvent);
			
			var tabs : int;
			
			var onScreenFriend : int = _onScreenItems - 1;
			var screens : int = fCon.appFriends.length / onScreenFriend + (fCon.appFriends.length % onScreenFriend == 0 ? 0 : 1);
			
			var items : Vector.<Boolean> = new Vector.<Boolean>();

			var j : int;
			var k : int = 0;
			var left : int = 0;
			
			if (screens == 0)
			{
				for (i = 0; i < _onScreenItems; i++)
				{
					items.push(false);
				}
			}
			
			for (i = 0; i < screens; i++)
			{
				for (j = 0; j < onScreenFriend; j++)
				{
					if (k < fCon.appFriends.length)
					{
						items.push(true);
						k++;
					}
					else
					{
						left = _onScreenItems - j;
						break;
					}
				}
				
				if (left == 0)
					items.push(false);
				else
				{
					for (j = 0; j < left; j++)
						items.push(false);
					
					break;
				}
			}
			
/*			var onScreenFriend : int = 5;
			var last : int = fCon.appFriends.length % onScreenFriend;
			var lastAdd : int = _onScreenItems - last;
			var screens : int = fCon.appFriends.length / onScreenFriend + (last == 0 ? 0 : 1);
			
			var items : Vector.<Boolean> = new Vector.<Boolean>();
			
			for (i = 0; i < _onScreenItems; i++)
			{
				if (i < lastAdd)
					items[i] = false;
				else
					items[i] = true;
			}
			
			for (i = 1; i < screens; i++)
			{
				for (j = 0; j < _onScreenItems; j++)
				{
					if (j == 0)
						items[i * _onScreenItems + j] = false;
					else
						items[i * _onScreenItems + j] = true;
				}
			}
*/	
			i = 0;
			
			for each (var friend : Boolean in items)
			{
				if (friend)
				{
					newFI = new FriendBarItem();
					
					newFI.friendClient = fCon.getAppFriendClient(fCon.appFriends[i++]);
					
					_friends.addChild(newFI);
					
					newFI.x = itemX + (tabs++) * itemWidth;
					
					_moveWidth = newFI.width * _onScreenItems;
				}
				else
				{
					newFAI = new AddFriendBarItem();
					
					_friends.addChild(newFAI);
					
					newFAI.x = itemX + (tabs++) * itemWidth;
					
					_moveWidth = newFAI.width * _onScreenItems;
				}
			}
			
			_friendsScreens = screens;
			_currFriendsScreen = 1;
//			_currFriendsScreen = _friendsScreens;
			
//			_friends.x += (-_moveWidth * (_friendsScreens - 1));
			
			checkButtons();
			showItems(-_friends.x, -_friends.x + _moveWidth);
		}
		
		protected function checkButtons() : void
		{
			if (_currFriendsScreen == _friendsScreens)
			{
				_canRight = false;
				
				rightButton.enabled = false;
			}
			else
			{
				_canRight = true;
				
				rightButton.enabled = true;
			}
			
			if (_currFriendsScreen == 1)
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
		
		protected function onRightMouseEvent(e : Object) : void
		{
			if (!_moving)
				if (_currFriendsScreen < _friendsScreens)
				{
					_currFriendsScreen++;
					moveShop(-_moveWidth);
					showItems(-_friends.x, -_friends.x + _moveWidth + _moveWidth);
					
					checkButtons();
				}
		}
		
		protected function onLeftMouseEvent(e : Object) : void
		{
			if (!_moving)
				if (_currFriendsScreen > 1)
				{
					_currFriendsScreen--;
					moveShop(_moveWidth);
					showItems(-_friends.x - _moveWidth, -_friends.x + _moveWidth);
					
					checkButtons();
				}
		}
		
		protected function onFriendEvent(e : Object) : void
		{
			if (_moving)
				e.stopPropagation();
		}
		
		protected function endMove() : void
		{
			if (_moving)
			{
				//_friends.x = _start + _needMove;
				
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				showItems(-_friends.x, -_friends.x + _moveWidth);
				_moving = false;
			}
		}
		
		protected function showItems(x1 : int, x2 : int) : void
		{
			for (var i:int=0; i<_friends.numChildren; i++) {
				var item:Sprite = _friends.getChildAt(i) as Sprite;
				item.visible = item.x>=x1 && item.x<=x2;
			}
		}
		
		protected function moveShop(len_ : int) : void
		{
			_start = _friends.x;
			_needMove = len_;
			_moved = 0;
			
			_delta = _needMove / Math.abs(_needMove) * _speed;
			
			_moving = true;
			
			Starling.juggler.tween(_friends, 0.5, {delay:0, transition:Transitions.EASE_IN_OUT, x:_friends.x + len_, onComplete:endMove});
		}
		
		protected function onEnterFrame(e : Event) : void
		{
			_friends.x += _delta;
			
			_moved += _delta;
			
			if (Math.abs(_moved) >= Math.abs(_needMove))
			{
				endMove();
			}
		}
		
		/*protected function get leftButton() : MovieClip
		{
			return _skin[_leftButton];
		}
		
		protected function get rightButton() : MovieClip
		{
			return _skin[_rightButton];
		}*/
	}
}