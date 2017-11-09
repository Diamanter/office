package com.sigma.socialgame.model.server.packet
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;

	public class PacketFactory
	{
		public static function createPacket(data_ : XML) : Packet
		{
			Logger.message("Creating Packet from XML.", "PacketFactory", LogLevel.Debug, LogModule.Model);
			
			var newPack : Packet = new Packet();
			
			newPack.data = data_;
			newPack.user = data_.user;
			newPack.session = data_.session;
			newPack.version = data_.version;
			
			switch (String(data_.type))
			{
				case PacketTypes.Info:
					newPack.type = PacketTypes.Info
					break;
				
				case PacketTypes.Init:
					newPack.type = PacketTypes.Init;
					break;
				
				case PacketTypes.Sync:
					newPack.type = PacketTypes.Sync;
					break;
				
				case PacketTypes.Auth:
					newPack.type = PacketTypes.Auth;
					break;
				
				case PacketTypes.Quest:
					newPack.type = PacketTypes.Quest
					break;
			}
			
			Logger.message(newPack.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return newPack;
		}
	}
}