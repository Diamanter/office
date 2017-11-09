package com.sigma.socialgame.controller.friends
{
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.clients.AbstractFriendClient;
	import com.sigma.socialgame.controller.friends.clients.AppFriendClient;
	import com.sigma.socialgame.controller.friends.clients.FriendClient;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	import com.sigma.socialgame.events.controller.FriendsControllerEvent;
	import com.sigma.socialgame.model.ResourceFactory;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.sync.friend.FriendData;
	import com.sigma.socialgame.model.social.SocialNetwork;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	
	import flash.utils.Dictionary;
	
	public class FriendsContoller extends Controller
	{
		private var _me : FriendObject;
		
		private var _appFriends : Vector.<FriendObject>;
		
		private var _selected : Vector.<FriendObject>;
		
		private var _clientToObject : Dictionary;
		
		public function FriendsContoller()
		{
			super(ControllerNames.FriendsController);
		}
		
		public override function init():void
		{
			_appFriends = new Vector.<FriendObject>();
			
			_selected = new Vector.<FriendObject>();
			
			_clientToObject = new Dictionary();
			
			dispatchEvent(new FriendsControllerEvent(FriendsControllerEvent.Inited));	
		}
		
		public override function start():void
		{
			_me = FriendsFactory.createMe(SocialNetwork.instance.me);
			
			var found : Boolean;
			
			var fdata : FriendData;
			var fsdata : FriendSocialData;
			var fodata : FriendObject;
			
/*			for each (fsdata in SocialNetwork.instance.friends)
			{
				_friends.push(FriendsFactory.createFriendObject(null, fsdata));
				
				found = false;
				
				for each (var afsdata : FriendSocialData in SocialNetwork.instance.appFriends)
				{
					if (fsdata.uid == afsdata.uid)
					{
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					_notAppFriends.push(_friends[_friends.length - 1]);
				}
			}
*/			
			for each (fsdata in SocialNetwork.instance.appFriends)
			{
				_appFriends.push(FriendsFactory.createFriendObject(null, fsdata));
				
/*				found = false;
				
				for each (fodata in _friends)
				{
					if (fsdata.uid == fodata.socFriend.uid)
					{
						_appFriends.push(fodata);
				
						found = true;
						
						break;
					}
				}
*/			}
			
			for each (fodata in _appFriends)
			{
				for each (fdata in ResourceManager.instance.friends)
				{
					if (fodata.socFriend.uid == fdata.sociId.id)
					{
						fodata.friend = fdata;
						
						break;
					}
				}
			}
			
			dispatchEvent(new FriendsControllerEvent(FriendsControllerEvent.Started));	
		}

		public function manure() : void
		{
			var id : String = ResourceManager.instance.officeId;
			
			for each (var friend : FriendObject in _appFriends)
			{
				if (friend.socFriend.uid == id)
					friend.friend.manured++;
			}
		}
		
		public function get currFriendManureNum() : int
		{
			var id : String = ResourceManager.instance.officeId;
			
			for each (var friend : FriendObject in _appFriends)
			{
				if (friend.socFriend.uid == id)
					return friend.friend.manured;
			}
			
			return 0;
		}
		
		public function clearSelected() : void
		{
			_selected = new Vector.<FriendObject>();
			dispatchEvent(new FriendsControllerEvent(FriendsControllerEvent.Unselected));
		}
		
		public function select(fo_ : FriendObject) : void
		{
			if (fo_ == null) return;
			
			_selected.push(fo_);
			
			var event : FriendsControllerEvent = new FriendsControllerEvent(FriendsControllerEvent.Selected);
			event.object = fo_;
			dispatchEvent(event);
		}
		
		public function unselect(fo_ : FriendObject) : void
		{
			var ind : int = _selected.indexOf(fo_);
			
			if (ind != -1)
			{
				var deleted : Vector.<FriendObject> = _selected.splice(ind, 1);
				
				var fcEvent : FriendsControllerEvent = new FriendsControllerEvent(FriendsControllerEvent.Unselected);
				fcEvent.object = deleted[0];
				dispatchEvent(fcEvent);
			}
		}
		
		public function getFriendClient(fo_ : FriendObject) : FriendClient
		{
			if (_clientToObject[fo_] != null)
				return null;
			
			var newFC : FriendClient = FriendsClientFactory.createFriendClient(fo_);
			
			_clientToObject[fo_] = newFC;
			
			return newFC;
		}
		
		public function getAppFriendClient(fo_ : FriendObject) : AppFriendClient
		{
			if (_clientToObject[fo_] != null)
				return null;
			
			var newAFC : AppFriendClient = FriendsClientFactory.createAppFriendClient(fo_);
			
			_clientToObject[fo_] = newAFC;
			
			return newAFC;
		}
		
		public function gotoOffice(fo_ : FriendObject) : void
		{
			ResourceManager.instance.gotoOffice(fo_.socFriend.uid);
		}
		
		public function removeClient(fo_ : FriendObject) : void
		{
			_clientToObject[fo_] = null;
		}
		
		public function get me() : FriendObject
		{
			return _me;
		}
		
		public function get appFriends() : Vector.<FriendObject>
		{
			return _appFriends;
		}
		
		public function get selected():Vector.<FriendObject>
		{
			return _selected;
		}

	}
}