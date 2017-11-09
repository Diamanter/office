package com.sigma.socialgame.model.social
{
	import com.api.forticom.ApiCallbackEvent;
	import com.api.forticom.ForticomAPI;
	import com.api.forticom.SignUtil;
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.model.social.SocialNetworkDelegateEvent;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class NullDelegate extends EventDispatcher implements ISocialNetworkDelegate
	{
		private var _me : FriendSocialData;
		private var _friends : Vector.<FriendSocialData>;
		private var _appFriends : Vector.<FriendSocialData>;
		
		private var _userId : String;
		private var _apiURL : String;
		
		private var _stage : Stage;
		
		private var _infoMeService : HTTPService;
		
		private var _friendsService : HTTPService;
		private var _infoFriendsService : HTTPService;
		
		private var _appFriendsService : HTTPService;
		private var _infoAppFriendsService : HTTPService;
		
		public function NullDelegate(stage_ : Stage)
		{
			super();
		}
		
		public function publish(quest: String, str : String, imgStr : String) : void
		{
			
		}
		
		protected function checkURL(value : String) : String
		{
			if (value.search(/\?/) > 0)
			{
				if (value.search(/&$/) < 0)
				{
					value += "&";
				}
			}
			else
			{
				value += "?";
			}
			
			
			return value;
		}
		
		protected function onApiConnect(e : Event) : void
		{
			trace("onApiConnect");
		}
		
		protected function onApiCallback(e : ApiCallbackEvent) : void
		{
			trace("onApiCallback");
		}
		
		public function getMe() : void
		{
			trace("Loading me");
			
			_me = new FriendSocialData();
			_me.uid = "351370311727827";
			_me.uid = "970374532973926";
//			_me.uid = "7925811338553261312";
			_me.lastName = "MeLastName";
			_me.firstName = "MeFirstName";
			_me.name = "MeName";
			_me.language = "en_US";
			SignUtil.sessionKey = "CAADdr9LPTKgBAD6rhTM6aIIuQBMNAylmOAkvwYn84gVRWtJiSpkCXyWm3689a7l9AU1kWd97TNkuoynSfCVGlzcdbBsRGvQk5ZAFkmabvxrZBp1hXRqpVIWF3IAEhAnDWmyVnwyBv0ILQkJ1atZBoJ8XZABtUEfZAeqwgNsIUgjSM5iqIrJnX3qNmDWfexW12j9RxbZC1HQcpgqr1nq9V3b4mblDZAAvfIZD";
			SignUtil.sessionKey = "CAADdr9LPTKgBAIxvFYCVUslKZAfOec4lXaUl4R73DynffZAI69s7ZAMgwAZBJ4ZAMYWvIu2GR6ORb4JCtsdbXNekl0d4vpZBXtzqZB6HF4i4iXaD97ASIEd3oLbbcLlZC6xv3s1pmIgLnUfz5gpvRLv6fFs8FZCZC3rrYtyCmvP5QiwZCZBOIFXV8OsvGOlrZBT23VZAQZCNZAwl1gqQbQZDZD";
			_me.pic = "https://graph.facebook.com/"+_me.uid+"/picture?type=normal";
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.MeLoaded));
		}
	
		public function getFriends() : void
		{
			_friends = new Vector.<FriendSocialData>();
			
			var uids : Array = [
				
				"7925811338553261313",
				"7925811338553261314",
				"7925811338553261315",
				"7925811338553261316",
				"7925811338553261318",
				"7925811338553261319",
				"7925811338553261337",
				"7925811338553261336",
				
				"7925811338553261413",
				"7925811338553261414",
				"7925811338553261415",
				"7925811338553261416",
				"7925811338553261418",
				"7925811338553261419",
				"7925811338553261437",
				"7925811338553261436"
			];
			
			for (var i : int = 0; i < 16; i++)
			{
				_friends[i] = new FriendSocialData();
				_friends[i].uid = uids[i];
				_friends[i].lastName = "lastName" + i * i;
				_friends[i].firstName = "firstName" + i * i;
				_friends[i].name = "name" + i * i;
				_friends[i].pic = "https://graph.facebook.com/351370311727827/picture?type=normal";
			}
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.FriendsLoaded));
		}
		
		public function getAppFriends() : void
		{
			_appFriends = new Vector.<FriendSocialData>();
			
			var uids : Array = [
			
			"7925811338553261313",
			"7925811338553261314",
			"7925811338553261315",
			"7925811338553261316",
			"7925811338553261318",
			"7925811338553261319",
			"7925811338553261337",
			"7925811338553261336"

			];
			
			for (var i : int = 0; i < 8; i++)
			{
				_appFriends[i] = new FriendSocialData();
				_appFriends[i].uid = uids[i];
				_appFriends[i].lastName = "lastName" + i;
				_appFriends[i].firstName = "firstName" + i;
				_appFriends[i].name = "Имярёк " + i;
				_appFriends[i].pic = "https://graph.facebook.com/351370311727827/picture?type=normal";
			}
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.AppFriendsLoaded));
		}
		
		protected function onFriendsResult(e : Event) : void
		{
			var data : XML = XML(_friendsService.lastResult);
			
//			trace(data);
			
			_infoFriendsService.send(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:getUIDs(data.uid), fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
		}
		
		protected function onAppFriendsResult(e : Event) : void
		{
			var data : XML = XML(_appFriendsService.lastResult);
			
//			trace(data);
			
			_infoAppFriendsService.send(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:getUIDs(data.uid), fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
		}

		protected function onInfoMeResult(e : Event) : void
		{
			var data : XML = XML(_infoMeService.lastResult);
			
			trace(data);
			
			_me = readFriends(data)[0];
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.MeLoaded));
		}
		
		protected function onInfoFriendsResult(e : Event) : void
		{
			var data : XML = XML(_infoFriendsService.lastResult);
			
//			trace(data);
			
			_friends = readFriends(data);
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.FriendsLoaded));
		}
		
		protected function onInfoAppFriendsResult(e : Event) : void
		{
			var data : XML = XML(_infoAppFriendsService.lastResult);
			
//			trace(data);
			
			_appFriends = readFriends(data);

			trace(_appFriends);
			
			for each (var friend : FriendSocialData in _appFriends)
			{
				trace(friend);
			}
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.AppFriendsLoaded));
		}
		
		protected function readFriends(data : XML) : Vector.<FriendSocialData>
		{
			var friends : Vector.<FriendSocialData> = new Vector.<FriendSocialData>();
			
			var newFriends : FriendSocialData;
			
			for each (var friend : XML in data.user)
			{
				newFriends = new FriendSocialData();
				
				newFriends.uid = friend.uid;
				newFriends.lastName = friend.last_name;
				newFriends.firstName = friend.first_name;
				newFriends.name = friend.name;
				newFriends.pic = friend.pic_1;
				
				friends.push(newFriends);
			}
			
			return friends;
		}
		
		protected function getUIDs(list : XMLList) : String
		{
			var uids : Array = [];
			for each(var item : XML in list) uids.push(item);
			return uids.join(",");
		}
		
		public function get me() : FriendSocialData
		{
			return _me;
		}

		public function get friends() : Vector.<FriendSocialData>
		{
			return _friends;		
		}
		
		public function get appFriends() : Vector.<FriendSocialData>
		{
			return _appFriends;	
		}
		
		public function invite(arr : Array) : void
		{
			trace(arr);
		}
	}
}