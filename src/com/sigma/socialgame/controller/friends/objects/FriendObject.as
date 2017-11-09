package com.sigma.socialgame.controller.friends.objects
{
	import com.sigma.socialgame.model.objects.sync.friend.FriendData;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;

	public class FriendObject
	{
		private var _friend : FriendData;
		private var _socFriend : FriendSocialData;
		
		public function FriendObject()
		{
		}

		public function get friend():FriendData
		{
			if (_friend==null) {
				_friend = new FriendData();
                                _friend.level = 47;
			}
			return _friend;
		}

		public function set friend(value:FriendData):void
		{
			_friend = value;
		}

		public function get socFriend():FriendSocialData
		{
			return _socFriend;
		}

		public function set socFriend(value:FriendSocialData):void
		{
			_socFriend = value;
		}


	}
}