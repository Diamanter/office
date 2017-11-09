package com.sigma.socialgame.model.common.id.serverid
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.Logger;

	public class ServerIdFactory
	{
		public static function createServerId(id_ : String) : IServerIdentifier
		{
			Logger.message("Create server identifier.", "ServerIdFactory", LogLevel.Debug, LogModule.Model);
			
			var newServId : ServerIdentifier = new ServerIdentifier();
			
			newServId.id = id_;
			
			Logger.message(newServId.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return newServId;
		}
	}
}