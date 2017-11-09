package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;

	public class FriendsControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "frconInited";
		public static const Started : String = "frconStarted";
		public static const Synced : String = "frconSynced";
		
		public static const Selected : String = "frconSelected";
		public static const Unselected : String = "frconUnselected";
		
		public var object : FriendObject;
	
		public function FriendsControllerEvent(type:String)
		{
			super(type, ControllerNames.FriendsController);
		}
	}
}