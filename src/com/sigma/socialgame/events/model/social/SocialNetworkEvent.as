package com.sigma.socialgame.events.model.social
{
	import flash.events.Event;
	
	public class SocialNetworkEvent extends Event
	{
		public static const MeLoaded : String = "socnetMeLoaded";
		public static const FriendsLoaded : String = "socnetFriendsLoaded";
		public static const AppFriendsLoaded : String = "socnetAppFriendsLoaded";
		
		public function SocialNetworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}