package com.sigma.socialgame.model.social
{
	
	import com.sigma.socialgame.events.model.social.SocialNetworkDelegateEvent;
	import com.sigma.socialgame.events.model.social.SocialNetworkEvent;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;

	public class SocialNetwork extends EventDispatcher
	{
		public static const Odnoklassniki : String = "Ondoklassniki";
		public static const Vkontakte : String = "Vkontakte"; 
		public static const Facebook : String = "Facebook"; 
		public static const Null : String = "Null";
		
		private var _socDelegate : ISocialNetworkDelegate;
		private var _stage : Stage;
		
		private static var _instance : SocialNetwork;
		
		public function SocialNetwork(stage_ : Stage, socNet_ : String)
		{
			_stage = stage_;
		
			_instance = this;
			
			switch (socNet_)
			{
				case Odnoklassniki:
					_socDelegate = new OndoklassnikiDelegate(_stage);
					break;
				
				case Vkontakte:
					break;
				
				case Facebook:
					_socDelegate = new FacebookDelegate(_stage);
					break;
				
				case Null:                                      					
					_socDelegate = new NullDelegate(_stage);					
					break;
			}
			
			_socDelegate.addEventListener(SocialNetworkDelegateEvent.FriendsLoaded, socDelegateEvent);
			_socDelegate.addEventListener(SocialNetworkDelegateEvent.AppFriendsLoaded, socDelegateEvent);
			_socDelegate.addEventListener(SocialNetworkDelegateEvent.MeLoaded, socDelegateEvent);
		}
		
		public function publish(quest : String, str : String, imgStr : String = "") : void
		{
			_socDelegate.publish(quest, str, imgStr);
		}
		
		public function invite(arr : Array) : void
		{
			_socDelegate.invite(arr);
		}
		
		public function loadMe() : void
		{
			_socDelegate.getMe();
		}
		
		public function loadFriends() : void
		{
			_socDelegate.getFriends();
		}
		
		public function loadAppFriends() : void
		{
			_socDelegate.getAppFriends();
		}
		
		public function get me() : FriendSocialData
		{
			return _socDelegate.me;
		}
		
		public function get friends() : Vector.<FriendSocialData>
		{
			return _socDelegate.friends;
		}
		
		public function get appFriends() : Vector.<FriendSocialData>
		{
			return _socDelegate.appFriends;
		}
		
		protected function socDelegateEvent(e : SocialNetworkDelegateEvent) : void
		{
			switch (e.type)
			{
				case SocialNetworkDelegateEvent.FriendsLoaded:
					dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.FriendsLoaded));
					break;
				
				case SocialNetworkDelegateEvent.AppFriendsLoaded:
					dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.AppFriendsLoaded));
					break;
				
				case SocialNetworkDelegateEvent.MeLoaded:
					dispatchEvent(new SocialNetworkEvent(SocialNetworkEvent.MeLoaded));
					break;
			}
		}
		
		public static function get instance() : SocialNetwork
		{
			return _instance;
		}
	}
}