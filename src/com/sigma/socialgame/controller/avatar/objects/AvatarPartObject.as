package com.sigma.socialgame.controller.avatar.objects
{
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;

	public class AvatarPartObject
	{
		private var _part : AvatarPart;
		
		public function AvatarPartObject()
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