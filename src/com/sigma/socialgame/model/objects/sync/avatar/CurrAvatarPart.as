package com.sigma.socialgame.model.objects.sync.avatar
{
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;

	public class CurrAvatarPart
	{
		private var _part : AvatarPart; 
		
		public function CurrAvatarPart()
		{
		}

		public function get part():AvatarPart
		{
			return _part;
		}

		public function set part(value:AvatarPart):void
		{
			_part = value;
		}

	}
}