package com.sigma.socialgame.model.common.id.socialid
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;

	public class SocialIdFactory
	{
		public static function createSocialId(id_ : String) : SocialIdentifier
		{
			Logger.message("Create social identifier.", "SocialIdFactory", LogLevel.Debug, LogModule.Model);
			
			var newSocId : SocialIdentifier = new SocialIdentifier();
			
			newSocId.id = id_;
			
			Logger.message(newSocId.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return newSocId;
		}
	}
}