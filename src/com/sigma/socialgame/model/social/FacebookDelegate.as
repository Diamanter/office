package com.sigma.socialgame.model.social
{
	import com.facebook.graph.*;
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.model.social.SocialNetworkDelegateEvent;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.api.forticom.SignUtil;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.external.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.system.*;
	import flash.external.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.StageDisplayState;
	import flash.display.PNGEncoderOptions;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.*;
	import starling.filters.*;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	public class FacebookDelegate extends EventDispatcher implements ISocialNetworkDelegate
	{
		private var APP_ID : String = "243747225816232";
		private var _gameUrl : String = "https://apps.facebook.com/officelifetest";
		private var _me : FriendSocialData;
		private var _friends : Vector.<FriendSocialData>;
		private var _appFriends : Vector.<FriendSocialData>;
		
		private var _userId : String;
		private var _accessToken : String;
		
		private var _stage : Stage;
		
		private var _thirdPartyId:String;
		
		public function FacebookDelegate(stage_ : Stage)
		{
			super();
			
			_stage = stage_;
			
			Logger.message("init", "FbDelegate:Init", LogLevel.Info, LogModule.Model);
			
			Facebook.init(APP_ID, onInit, {status:true, xfbml:true, version:"v2.3", channelUrl:"//officelife.yamsonline.ru/static/officelife/channel.html"});
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
		
		public function publish(quest : String, str : String, imgStr : String) : void
		{
			workerCall = ["feed", {picture: "https://sushi.yamsonline.ru/static/sushi/images/level_cleared_post_dialog_200x200.png?", caption: str, link: _gameUrl}];
			showSnapshot();
		}
		
		public function invite(arr : Array) : void
		{
			var ids:String = arr.join(",");
			workerCall = ["apprequests", {method: 'apprequests', to:ids, message: "inviteMessage", title: "inviteTitle"}, onInvite];
			showSnapshot();
		}
		
		public function onInvite(e:Object){		  
		}
		
		public function getMe() : void
		{

//			trace("---");
//			trace(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:_userId, fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'}));
//			trace(ObjectUtil.toString(SignUtil.signRequest({method:'users.getInfo', emptyPictures: 'false', uids:_userId, fields:'uid,first_name,last_name,name,gender,birthday,locale,location,current_location,current_status,pic_1,pic_2,pic_3,pic_4,url_profile,url_profile_mobile,url_chat,url_chat_mobile'})));
//			trace("---");
			
		}
		
		public function getFriends() : void {
		}
	
		public function getAppFriends() : void {
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
		
        public function onInit(response:Object, fail:Object) : void {
		Security.loadPolicyFile('https://fbcdn-profile-a.akamaihd.net/crossdomain.xml');
            if (response) {
				Logger.message(response.uid, "FbDelegate:onInit", LogLevel.Info, LogModule.Model);
				_accessToken = response.accessToken;
				getUserInfo(response.uid);
            } else {
				Logger.message("doLogin", "FbDelegate:onInit", LogLevel.Info, LogModule.Model);
				doLogin();
            }
        }

        public function doLogin() : void {
			Logger.message("Login", "FbDelegate:doLogin", LogLevel.Info, LogModule.Model);
            Facebook.login(onLogin, {scope: "public_profile, user_friends"});
        }

        protected function onLogin(response:Object, fail:Object) : void {
			Logger.message(response.toString(), "FbDelegate:onLogin", LogLevel.Info, LogModule.Model);
            if (response) {
				_accessToken = response.accessToken;
				getUserInfo(response.uid);
            } else {
				setTimeout( checkForSession, 100);
            }
        }
		
		private var checkForSessionN:int = 0;
		protected function checkForSession():void {
			checkForSessionN++;
			var response:Object = Facebook.getAuthResponse();
			if (response==null || checkForSessionN>20) {
				//isOffline=true;
				//startLocal();
				return;
			}
			Logger.message(response.toString(), "FbDelegate:checkForSession", LogLevel.Info, LogModule.Model);
			if (response==null) {
				return;
			}
			if ( response.uid != null ) {
				_accessToken = response.accessToken;
				getUserInfo(response.uid);
			} else {
				setTimeout( checkForSession, 100);
			}
		}

        protected function onLogout(param1:Boolean) : void {
			Logger.message(param1.toString(), "FbDelegate:onLogout", LogLevel.Info, LogModule.Model);
			_accessToken = null;
        }

        protected function getUserInfo(id:String) {
			//Logger.message(id, "FbDelegate:getUserInfo", LogLevel.Info, LogModule.Model);
            Facebook.api("/me", onGetUserInfo, null, "GET");
        }

        public function onGetUserInfo(response:Object, fail:Object) : void {
            if (response) {
				Logger.message(response.first_name+":"+response.locale, "FbDelegate:onGetUserInfo", LogLevel.Info, LogModule.Model);
				_me = new FriendSocialData();
				_me.uid = response.id;
				_me.lastName = response.last_name;
				_me.firstName = response.first_name;
				_me.name = _me.firstName;
				_me.language = response.locale;
				_me.pic = Facebook.getImageUrl(_me.uid, "normal");
				SignUtil.sessionKey = _accessToken;
				trace("onGetUserInfo", _me.uid, _accessToken);
				dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.MeLoaded));
				getOfficeFriends();
				//app.avatarUrl = Facebook.getImageUrl(app.fb_id, "square");
            } else {
				Logger.message("ERROR", "FbDelegate:onGetUserInfo", LogLevel.Info, LogModule.Model);
            }
        }
		
        protected function getOfficeFriends() {
            Facebook.api("/me/friends", onOfficeFriends, null, "GET");
        }
		
        public function onOfficeFriends(response:Object, fail:Object) {
            if (response) {
				Logger.message(response.length, "FbDelegate:onOfficeFriends", LogLevel.Info, LogModule.Model);
				_appFriends = readFriends(response);
				getInvitableFriends();
			} else {
				Logger.message("ERROR", "FbDelegate:onOfficeFriends", LogLevel.Info, LogModule.Model);
			}
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.AppFriendsLoaded));
		}
		
        protected function getInvitableFriends() {
			Logger.message(_me.uid, "FbDelegate:getInvitableFriends", LogLevel.Info, LogModule.Model);
            Facebook.api("/me/invitable_friends", onInvitableFriends, null, "GET");
        }

        public function onInvitableFriends(response:Object, fail:Object) {
            if (response) {
				Logger.message(response.length, "FbDelegate:onInvitableFriends", LogLevel.Info, LogModule.Model);
				_friends = readFriends(response);
			} else {
				Logger.message("ERROR", "FbDelegate:onInvitableFriends", LogLevel.Info, LogModule.Model);
			}
			dispatchEvent(new SocialNetworkDelegateEvent(SocialNetworkDelegateEvent.FriendsLoaded));
		}
		
		private function onThirdPartyID(response:Object, fail:Object) {
			_thirdPartyId = response.third_party_id;
		}
		
		protected function readFriends(data : Object) : Vector.<FriendSocialData>
		{
			var friends : Vector.<FriendSocialData> = new Vector.<FriendSocialData>();
			
			var newFriends : FriendSocialData;
			
			for each (var friend : Object in data)
			{
				newFriends = new FriendSocialData();
				
				newFriends.uid = friend.id;
				//newFriends.lastName = friend.last_name;
				//newFriends.firstName = friend.first_name;
				newFriends.name = friend.name;
				newFriends.pic = friend.picture;
				
				friends.push(newFriends);
			}
			
			return friends;
		}
		
		private var mainToWorker:MessageChannel;
		private var workerToMain:MessageChannel;
		private var worker:Worker;
		private var workerWidth:int = 0;
		private var workerHeight:int = 0;
		private var workerBytes:ByteArray;
		public var workerCall:Array;
		public var workerBusy:Boolean=false;
		private function onWorkerToMain(event:Object) {
			trace("[Worker] " + workerToMain.receive());
			workerBytes.position = 0;
			var screenshotBase64:String = workerBytes.readUTFBytes(workerBytes.length);
			if (workerCall && ExternalInterface.available) ExternalInterface.call("function(){if(navigator.appName.indexOf('Microsoft')!=-1||navigator.appName.indexOf('Netscape')!=-1)document.getElementById('wrap').focus();}");
			if (ExternalInterface.available) ExternalInterface.call("function(){var img=document.getElementById('ImageContent');img.src='data:image/png;base64,' + '"+screenshotBase64+"';}");
			if (workerCall && ExternalInterface.available) Facebook.ui.apply(this, workerCall);
			workerCall = null;
			workerBusy = false;
		}
		public function showSnapshot(filter:Boolean=true) {
			if (workerBusy || Starling.current.nativeStage.displayState!=StageDisplayState.NORMAL) return;
			if (worker==null) {
				worker = WorkerDomain.current.createWorker(SkinManager.instance.getByteArray("snapshot"));
				mainToWorker = Worker.current.createMessageChannel(worker);
				workerToMain = worker.createMessageChannel(Worker.current);
				worker.setSharedProperty("mainToWorker", mainToWorker);
				worker.setSharedProperty("workerToMain", workerToMain);
				worker.setSharedProperty("width", Starling.current.stage.stageWidth);
				worker.setSharedProperty("height", Starling.current.stage.stageHeight);
				workerToMain.addEventListener("channelMessage", onWorkerToMain);
				workerBytes = new ByteArray();
				workerBytes.shareable = true;
				worker.setSharedProperty("workerBytes", workerBytes);
				//trace(worker.state)
				worker.start();
			}
			var support:RenderSupport = new RenderSupport();
			RenderSupport.clear(Starling.current.stage.color, 1.0);
			support.setProjectionMatrix(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			//var sceneFilter:FragmentFilter = app.currentScene.filter;
			//app.currentScene.filter = null;
			Starling.current.stage.render(support, 1.0);
			support.finishQuadBatch();
			var result:BitmapData = new BitmapData(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, false);
			Starling.context.drawToBitmapData(result);
			if (filter) result.applyFilter(result, result.rect, new Point(), new flash.filters.ColorMatrixFilter([0.3930000066757202,0.7689999938011169,0.1889999955892563,0,0,0.3490000069141388,0.6859999895095825,0.1679999977350235,0,0,0.2720000147819519,0.5339999794960022,0.1309999972581863,0,0,0,0,0,1,0]));
			workerBytes.length = 0;
			result.copyPixelsToByteArray(result.rect, workerBytes);
			mainToWorker.send("HELLO");
			workerBusy = true;
			//app.currentScene.filter = sceneFilter;
		}
		
	}
}