package com.sigma.socialgame.events.model.social
{
	import flash.events.Event;
	
	public class SocialNetworkDelegateEvent extends Event
	{
		public static const MeLoaded : String = "SocnetDelMeLoaded";
		public static const FriendsLoaded : String = "SocnetDelFriendsLoaded";
		public static const AppFriendsLoaded : String = "SocnetDelAppFriendsLoaded";
		
		public function SocialNetworkDelegateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}