package com.sigma.socialgame.controller.avatar
{
	import com.sigma.socialgame.controller.avatar.clients.AvatarPartClient;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;

	public class AvatarFactory
	{
		public static function createAvatarPartObject(part_ : AvatarPart) : AvatarPartObject
		{
			var newPart : AvatarPartObject = new AvatarPartObject();
			
			newPart.part = part_;
			
			return newPart;
		}
		
		public static function createAvatarPartClient(part_ : AvatarPartObject) : AvatarPartClient
		{
			var newClient : AvatarPartClient = new AvatarPartClient();
			
			newClient.part = part_;
			
			return newClient;
		}
	}
}