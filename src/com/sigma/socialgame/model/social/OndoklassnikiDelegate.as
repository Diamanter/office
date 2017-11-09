package com.sigma.socialgame.model.social
{
	import com.api.forticom.ApiCallbackEvent;
	import com.api.forticom.ForticomAPI;
	import com.api.forticom.SignUtil;
	import com.serialization.json.JSON;
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.model.social.SocialNetworkDelegateEvent;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	public class OndoklassnikiDelegate extends EventDispatcher implements ISocialNetworkDelegate
	{
		private var _me : FriendSocialData;
		private var _friends : Vector.<FriendSocialData>;
		private var _appFriends : Vector.<FriendSocialData>;
		
		private var _userId : String;
		private var _apiURL : String;
		
		private var _stage : Stage;
		
		private var _infoMeService : HTTPService;
		
		private var _streamPublish : HTTPService;
		
		private var _friendsService : HTTPService;
		private var _infoFriendsService : HTTPService;
		
		private var _appFriendsService : HTTPService;
		private var _infoAppFriendsService : HTTPService;
		
		public function OndoklassnikiDelegate(stage_ : Stage)
		{
			super();
			
			_stage = stage_;
			
			_userId = _stage.loaderInfo.parameters["logged_user_id"];
			
			_apiURL = _stage.loaderInfo.parameters["api_server"] ? _stage.loaderInfo.parameters["api_server"]+'fb.do' : '/fb.do?';
			_apiURL = checkURL(_apiURL);
			
			SignUtil.applicationKey = _stage.loaderInfo.parameters["application_key"];
			SignUtil.secretSessionKey = _stage.loaderInfo.parameters["session_secret_key"];
			
			CONFIG::odnoklassniki
			{
				SignUtil.secretKey = "B17C3B590E2EB78EDF0B99ED";
			}
			
			CONFIG::development
			{
				SignUtil.secretKey = "9D4D242D010E51D170A7095C";
			}
			
			SignUtil.sessionKey = _stage.loaderInfo.parameters["session_key"];
			
//			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, onApiCallback);
//			ForticomAPI.addEventListener(ForticomAPI.CONNECTED, onApiConnect);
			
//			ForticomAPI.connection = _stage.loaderInfo.parameters['apiconnection'];
			
			trace(_userId);
			trace(_apiURL);
			trace(SignUtil.applicationKey);
			trace(SignUtil.secretSessionKey);
			trace(SignUtil.secretKey);
			trace(SignUtil.sessionKey);
			
			_streamPublish = new HTTPService();
			_streamPublish.url = _apiURL;	
			_streamPublish.method ="GET";
			_streamPublish.resultFormat = "e4x";
			_streamPublish.addEventListener(ResultEvent.RESULT, onStreamPublish);
			
			_friendsService = new HTTPService();
			_friendsService.url = _apiURL;	
			_friendsService.method ="GET";
			_friendsService.resultFormat = "e4x";
			_friendsService.addEventListener(ResultEvent.RESULT, onFriendsResult);
			
			_infoFriendsService = new HTTPService();
			_infoFriendsService.url = _apiURL;
			_infoFriendsService.method ="GET";
			_infoFriendsService.resultFormat = "e4x";
			_infoFriendsService.addEventListener(ResultEvent.RESULT, onInfoFriendsResult);
			
			_infoMeService = new HTTPService();
			_infoMeService.url = _apiURL;
			_infoMeService.method ="GET";
			_infoMeService.resultFormat = "e4x";
			_infoMeService.addEventListener(ResultEvent.RESULT, onInfoMeResult);
			
			_appFriendsService = new HTTPService();
			_appFriendsService.url = _apiURL;
			_appFriendsService.method ="GET";
			_appFriendsService.resultFormat = "e4x";
			_appFriendsService.addEventListener(ResultEvent.RESULT, onAppFriendsResult);
			
			_infoAppFriendsService = new HTTPService();
			_infoAppFriendsService.url = _apiURL;
			_infoAppFriendsService.method ="GET";
			_infoAppFriendsService.resultFormat = "e4x";
			_infoAppFriendsService.addEventListener(ResultEvent.RESULT, onInfoAppFriendsResult);
			
			ExternalInterface.addCallback("apiCallBack", apiCallBack);
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
		
		private var request : Object; 
		
		protected function apiCallBack(method : String, result : String, data : String) : void
		{
			trace("onApiCallback");
			
			if (result == "ok")
			{
				request["resig"] = data;
				
				_streamPublish.send(request);
			}
		}
		
		protected function onStreamPublish(e : Event) : void
		{
			trace("OnStreamPublish");
			
			trace(_streamPublish.lastResult);
		}
		
		public function publish(quest : String, str : String, imgStr : String) : void
		{
/*			{"caption":"Test", "media":[{"src":"icon18.png","type":"image"}]}	
*/			
//			var attach : String = JSON.serialize({caption:"Test", media:{src:"icon18.png", type:"image"}});
			
			request = {method : "stream.publish", message : str, attachment:"{\"caption\":\"" + imgStr + "\",\"media\":[{\"src\":\"icon128.png\",\"type\":\"image\"}]}"};
			
			request = SignUtil.signRequest(request, true);
			
//			ForticomAPI.showConfirmation("stream.publish", quest, request["sig"]);
			
			OdnoklassnikiFAPI.showConfirmation("stream.publish", quest, request["sig"]);
			
		}
		
		public function invite(arr : Array) : void
		{
			OdnoklassnikiFAPI.showInvite();
		}
		
		public function getMe() : void
		{
			trace("Loading me");

//			trace("---");
//			trace(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:_userId, fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
//			trace(ObjectUtil.toString(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:_userId, fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'})));
//			trace("---");
			
			Logger.message(ObjectUtil.toString(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:_userId, fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'})), "OdnDelegate", LogLevel.Info, LogModule.Model);
			
			_infoMeService.send(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:_userId, fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
		}
	
		public function getFriends() : void
		{
/*			_friends = new Vector.<FriendSocialData>();
			
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
			}
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.FriendsLoaded));
*/			
			_friendsService.send(SignUtil.signRequest({method:"friends.get"}));
		}
		
		public function getAppFriends() : void
		{
/*			_appFriends = new Vector.<FriendSocialData>();
			
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
				_appFriends[i].name = "name" + i;
			}
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.AppFriendsLoaded));
*/			
			_appFriendsService.send(SignUtil.signRequest({method:"friends.getAppUsers"}));
		}
		
		protected function onFriendsResult(e : Event) : void
		{
			var data : XML = XML(_friendsService.lastResult);
			
//			trace(data);
			
			Logger.message(data, "OdnDelegate:FrindsResult", LogLevel.Info, LogModule.Model);
			
			if (data.uid.length() == 0)
			{
				Logger.message("ERROR", "OdnDelegate:FriendsResult", LogLevel.Info, LogModule.Model);
				
				_friends = new Vector.<FriendSocialData>();
				
				dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.FriendsLoaded));
				
				return;
			}
			
			_infoFriendsService.send(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:getUIDs(data.uid), fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
		}
		
		protected function onAppFriendsResult(e : Event) : void
		{
			var data : XML = XML(_appFriendsService.lastResult);
			
//			trace(data);
			
			Logger.message(data, "OdnDelegate:AppFriendsResult", LogLevel.Info, LogModule.Model);
			
			if (data.uid.length() == 0)
			{
				Logger.message("ERROR", "OdnDelegate:AppFriendsResult", LogLevel.Info, LogModule.Model);
				
				_appFriends = new Vector.<FriendSocialData>();
					
				dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.AppFriendsLoaded));
				
				return;
			}
			
			_infoAppFriendsService.send(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:getUIDs(data.uid), fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
		}

		protected function onInfoMeResult(e : Event) : void
		{
			var data : XML = XML(_infoMeService.lastResult);
			
//			trace(data);
			
			Logger.message(data, "OdnDelegate:InfoMeResult", LogLevel.Info, LogModule.Model);
			
			_me = readFriends(data)[0];
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.MeLoaded));
		}
		
		protected function onInfoFriendsResult(e : Event) : void
		{
			var data : XML = XML(_infoFriendsService.lastResult);
			
//			trace(data);
			
			Logger.message(data, "OdnDelegate:onInfoFriendsResult", LogLevel.Info, LogModule.Model);
			
			_friends = readFriends(data);
			
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.FriendsLoaded));
		}
		
		protected function onInfoAppFriendsResult(e : Event) : void
		{
			var data : XML = XML(_infoAppFriendsService.lastResult);
			
//			trace(data);
			
			_appFriends = readFriends(data);

//			trace(_appFriends);
			
			Logger.message(data, "OdnDelegate:OnInfoAppFriendsResult", LogLevel.Info, LogModule.Model);
			
			for each (var friend : FriendSocialData in _appFriends)
			{
//				trace(friend);
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
				newFriends.pic = friend.pic_3;
				
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
	}
}