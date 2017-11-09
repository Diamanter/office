package com.sigma.socialgame.model.objects.sync.friend
{
	import com.sigma.socialgame.model.common.id.socialid.SocialIdentifier;

	public class FriendData
	{
		private var _sociId : SocialIdentifier;
		private var _level : int;
		private var _gifts : int;
		private var _manured : int;
		
		public function FriendData()
		{
		}

		public function get sociId():SocialIdentifier
		{
			return _sociId;
		}

		public function set sociId(value:SocialIdentifier):void
		{
			_sociId = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
			
			if (_level < 1)
				_level = 1;
		}

		public function get gifts():int
		{
			return _gifts;
		}

		public function set gifts(value:int):void
		{
			_gifts = value;
		}

		public function get manured():int
		{
			return _manured;
		}

		public function set manured(value:int):void
		{
			_manured = value;
		}


	}
}