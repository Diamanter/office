package com.sigma.socialgame.model.server.command
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.socialid.SocialIdentifier;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.server.packet.PacketTypes;

	public class CommandFactory
	{
		public static const TAG : String = "CommandFactory";
		
		public static function createCommand(type : String, ... args) : Command
		{
			Logger.message("Creating command.", TAG, LogLevel.Debug, LogModule.Model);
			
			var newCmd : Command = new Command();
			
			newCmd.type = type;
			
			switch (type)
			{
				case CommandTypes.Start:
					newCmd.group = CommandGroups.Session;
					
					newCmd.props[0] = args[0];
					break;
				case CommandTypes.Sync:
					newCmd.group = CommandGroups.Session;
					
					if (args.length > 0)
					{
						newCmd.props[0] = args[0];
					}
					
					break;
				
				case CommandTypes.Convert:
					newCmd.group = CommandGroups.Gameplay;
					newCmd.props[0] = args[0];
					break;
				
				case CommandTypes.Param:
					
					newCmd.group = CommandGroups.Gameplay;
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];	
					break;
				
				case CommandTypes.Auth:
					newCmd.group = CommandGroups.Helper;
					
					newCmd.props[0] = args[0];
					break;
				
				case CommandTypes.Finish:
					newCmd.group = CommandGroups.Session;
					
					break;
				
				case CommandTypes.Gift:
					newCmd.group = CommandGroups.Gameplay;
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					break;
				
				case CommandTypes.Avatar:
					newCmd.group = CommandGroups.Gameplay;
					newCmd.props[0] = args[0];
					
					break;
				case CommandTypes.Fertilizer:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					
					break;
				
				case CommandTypes.Confirm:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					
					newCmd.props[3] = args[3];
					
					break;
				
				case CommandTypes.Move:
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					
					break;
				
				case CommandTypes.Rotate:
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					
					break;
				
				case CommandTypes.Sell:
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					
					break;
				
				case CommandTypes.Buy:
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					
					if (args.length > 3)
						newCmd.props[3] = args[3];
					else
						newCmd.props[3] = 0;
					
					break;
				
				case CommandTypes.Task:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					
					break;
				
				case CommandTypes.Cancel:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					
					break;
				
				case CommandTypes.BuyMove:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					newCmd.props[3] = args[3];
					newCmd.props[4] = args[4];
					
					if (args.length > 5)
						newCmd.props[5] = args[5];
					else
						newCmd.props[5] = 0;
					
					break;
				
				case CommandTypes.Expand:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					
					break;
				
				case CommandTypes.Unlock:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					newCmd.props[1] = args[1];
					newCmd.props[2] = args[2];
					newCmd.props[3] = args[3];
					newCmd.props[4] = args[4];
					
					break;
				
				case CommandTypes.Quests:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					
					break;
				
				case CommandTypes.Friend:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					
					break;

				case CommandTypes.UnFriend:
					
					newCmd.group = CommandGroups.Gameplay;
					
					newCmd.props[0] = args[0];
					
					break;
			}
			
			Logger.message(newCmd.toString(), "", LogLevel.Debug, LogModule.Model);
			
			return newCmd;
		}
		
		public static function createSingleCommandXML(command : Command, version_ : String, user_ : String = null, session_ : String = null, sessionKey_ : String = null, sessionSecretKey_ : String = null) : XML
		{
			var comms : Vector.<Command> = new Vector.<Command>();
			comms.push(command);
			
			return createXML(comms, version_, user_, session_, sessionKey_, sessionSecretKey_);
		}
		
		public static function createXML(commands : Vector.<Command>, version_ : String, user_ : String = null, session_ : String = null, sessionKey_ : String = null, sessionSecretKey_ : String = null) : XML
		{
			Logger.message("Creating commands XML.", TAG, LogLevel.Debug, LogModule.Model);
			
			var valid : Boolean = true;
			var reason : String;
			
/*			if (commands[0].group == CommandGroups.Session && commands.length > 1)
			{
				valid = false;
				reason = "Only one Session command is allowed in single Packet.";
			}
			
			for (var i : int = 1; i < commands.length; i++)
			{
				if (commands[0].group == CommandGroups.Helper)
				{
					if (commands[i].group != CommandGroups.Helper || commands[i].type != commands[0].type)
					{
						valid = false;
						reason = "Only equal type Helper command allowed in single Packet.";
						
						break;
					}	
				}
				else if (commands[0].group == CommandGroups.Gameplay)
				{
					if (commands[i].group != CommandGroups.Gameplay)
					{
						valid = false;
						reason = "Only Gameplay commands allowed in single Packet";
						
						break;
					}
				}
			}
*/			
			if (!valid)
			{
				Logger.message("Invalid commands: " + reason, TAG, LogLevel.Error, LogModule.Model);
				
				return null;
			}
			
			var newXML : XML = <packet/>;
			
			newXML.version = version_;
			
			newXML.appendChild(<session/>);
			newXML.appendChild(<user/>);
			
			newXML.session_key = sessionKey_;
			newXML.session_secret_key = sessionSecretKey_;
			
			if (commands[0].type != CommandTypes.Start)
			{
				newXML.session = session_;
				newXML.user = user_;
			}
		
			newXML.type = PacketTypes.Cmd;
			
			newXML.appendChild(<commands/>);
			
			for each (var comm : Command in commands)
			{
				newXML.commands.appendChild(createCommandXMLLine(comm));
			}
			
			Logger.message(newXML.toXMLString(), "", LogLevel.Debug, LogModule.Model);
			
			return newXML;
		}
		
		protected static function createCommandXMLLine(command : Command) : XML
		{
			var newComm : XML = <command/>;
				
			newComm.@type = command.type;
			
			switch (command.type)
			{
				case CommandTypes.Auth:
					newComm.@id = (command.props[0] as SocialIdentifier).id;
				break;
				
				case CommandTypes.Buy:
					newComm.@thing = (command.props[0] as ObjectIdentifier).id;
					newComm.@currency = command.props[1];
					newComm.@id = command.props[2];
					
					if (command.props[3] > 0)
						newComm.@skill = command.props[3];
					
				break;
				
				case CommandTypes.BuyMove:
					newComm.@thing = (command.props[0] as ObjectIdentifier).id;
					newComm.@currency = command.props[1];
					newComm.@id = command.props[2];
					newComm.@x = command.props[3];
					newComm.@y = command.props[4];
					
					if (command.props[5] > 0)
						newComm.@skill = command.props[5];
				break;
				
				case CommandTypes.Friend:
					
					newComm.@id = command.props[0];
					
				break;
				
				case CommandTypes.UnFriend:
					
					newComm.@id = command.props[0];
					
				break;
				
				case CommandTypes.Finish:
				break;
				
				case CommandTypes.Avatar:
					newComm.@id = command.props[0];
				break;
				
				case CommandTypes.Gift:
					newComm.@friend = String(command.props[0]);
					newComm.@thing = (command.props[1] as ObjectIdentifier).id;
					
					if (command.props[2] != "")
						newComm.@currency = String(command.props[2]);
					
				break;
				
				case CommandTypes.Move:
					newComm.@id = (command.props[0] as StoreIdentifier).storeId;
					
					if (command.props[1] >= 0)
					{
						newComm.@x = command.props[1];
						newComm.@y = command.props[2];
					}
				break;
				
				case CommandTypes.Rotate:
					newComm.@id = (command.props[0] as StoreIdentifier).storeId;
					newComm.@orient = orient(command.props[1]);
				break;
				
				case CommandTypes.Task:
					
					newComm.@job = command.props[0];
					newComm.@worker = command.props[1];
					newComm.@id = command.props[2];
					
				break;
				
				case CommandTypes.Cancel:
					
					newComm.@job = command.props[0];
					
				break;
				
				case CommandTypes.Sell:
					newComm.@id = (command.props[0] as StoreIdentifier).storeId;
					newComm.@currency = command.props[1];
				break;
				
				case CommandTypes.Sync:
					if (command.props.length > 0)
						newComm.@id = command.props[0];
				break;
				
				case CommandTypes.Start:
					newComm.@id = (command.props[0] as SocialIdentifier).id;
				break;
				
				case CommandTypes.Confirm:
					
					if (command.props[0] != -1)
						newComm.@job = command.props[0];
					else if (command.props[1] != -1)
					{
						newComm.@gift = command.props[1];
						newComm.@id = command.props[3];
					}
					else
						newComm.@quest = command.props[2];
					
				break;
				
				case CommandTypes.Fertilizer:
					
					newComm.@id = command.props[0];
					
				break;
				
				case CommandTypes.Expand:
					
					newComm.@id = (command.props[0]);
					newComm.@currency = command.props[1];
					
				break;
				
				case CommandTypes.Convert:
					
					newComm.@id = command.props[0];
					
					break;
				
				case CommandTypes.Quests:
					
					newComm.@id = command.props[0];
					
					break;
				
				case CommandTypes.Param:
					
					newComm.@id = command.props[0];
					newComm.@value = command.props[1];
					
					break;
				
				case CommandTypes.Unlock:
					
					newComm.@currency = command.props[0];
					
					if (command.props[1] >= 0)
						newComm.@job = command.props[1];
					else if (command.props[2] >= 0)
						newComm.@expand = command.props[2];
					else if (command.props[3] != null)
					{
						newComm.@price = command.props[3];
						newComm.@skill = command.props[4];
					}
					
				break;
			}
			
			return newComm;
		}
		
		protected static function orient(rot_ : int) : String
		{
			switch (rot_)
			{
				case MapRotation.NorthWest:
					return "NW";
					break;
				
				case MapRotation.NorthEast:
					return "NE";
					break;
				
				case MapRotation.SouthEast:
					return "SE";
					break;
				
				case MapRotation.SouthWest:
					return "SW";
					break;
			}
			
			return "Unknown Rotation";
		}
	}
}