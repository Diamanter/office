package com.sigma.socialgame.controller.friends
{
	import com.sigma.socialgame.controller.friends.clients.AbstractFriendClient;
	import com.sigma.socialgame.controller.friends.clients.AppFriendClient;
	import com.sigma.socialgame.controller.friends.clients.FriendClient;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;

	public class FriendsClientFactory
	{
		public static function createAppFriendClient(fo_ : FriendObject) : AppFriendClient
		{
			var newFriendClient : AppFriendClient = new AppFriendClient();
			
			newFriendClient.friendObject = fo_;
			
			return newFriendClient;
		}
		
		public static function createFriendClient(fo_ : FriendObject) : FriendClient
		{
			var newFriendClient : FriendClient = new FriendClient();
			
			newFriendClient.friendObject = fo_;
			
			return newFriendClient;
		}
	}
}