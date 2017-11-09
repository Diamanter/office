package com.sigma.socialgame.controller.friends
{
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	import com.sigma.socialgame.model.objects.sync.friend.FriendData;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;

	public class FriendsFactory
	{
		public static function createMe(socFData_ : FriendSocialData) : FriendObject
		{
			var newFO : FriendObject = new FriendObject();
			
			newFO.socFriend = socFData_;
			
			return newFO;
		}
		
		public static function createFriendObject(fdata_ : FriendData, socFData_ : FriendSocialData) : FriendObject
		{
			var newFO : FriendObject = new FriendObject();
			
			newFO.friend = fdata_;
			newFO.socFriend = socFData_;
			
			return newFO;
		}
	}
}