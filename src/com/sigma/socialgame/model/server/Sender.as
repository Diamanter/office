package com.sigma.socialgame.model.server
{
	import com.api.forticom.SignUtil;
	import com.sigma.socialgame.common.Address;
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.model.common.SenderEvent;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.socialid.SocialIdentifier;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.server.command.Command;
	import com.sigma.socialgame.model.server.command.CommandFactory;
	import com.sigma.socialgame.model.server.command.CommandTypes;
	import com.sigma.socialgame.model.server.packet.Packet;
	import com.sigma.socialgame.model.server.packet.PacketFactory;
	import com.sigma.socialgame.model.server.packet.PacketTypes;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.model.social.SocialNetwork;
	import com.sigma.socialgame.model.social.objects.FriendSocialData;
	import com.sigma.socialgame.view.game.MyOfficeGame;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	
	public class Sender extends EventDispatcher
	{
		public static const TAG : String = "Sender";
		
		public var _server : Boolean = MyOfficeGame.instance.serverPath != "false"// && false;
		
/*		public static var _pversion : String = "1.0";
		public static var _puser : String;
		public static var _psession : String;
*/		
		private var _version : String = "1.0";
		private var _user : String;
		private var _session : String;
		
		private var _sendTimer : Timer;
		private var _sendDelay : int = 6;
		
		private var _pool : Vector.<Command>;
		
		public function Sender()
		{
			super();
			
			_pool = new Vector.<Command>();
			
			if (_server) { 
				_sendTimer = new Timer(_sendDelay * 1000);
				_sendTimer.addEventListener(TimerEvent.TIMER, onSendTimer);
				_sendTimer.start();
			}
		}
		
		public function sendStartCommand(socId_ : SocialIdentifier) : void
		{
			if (MyOfficeGame.instance.loaded) return;
			Logger.message("Sending Start command.", TAG, LogLevel.Debug, LogModule.Model);
			
			//pushCommand(CommandFactory.createCommand(CommandTypes.Start, socId_));
			
			var command:Command = CommandFactory.createCommand(CommandTypes.Start, socId_);
			sendXML(CommandFactory.createSingleCommandXML(command, _version, _user, _session, SignUtil.sessionKey, SignUtil.secretSessionKey));
		}
		
		public function sendSyncCommand(socId_ : String = null) : void
		{
			Logger.message("Sending Sync command.", TAG, LogLevel.Debug, LogModule.Model);
			
			var command : Command;
			
			if (socId_ != null)
				command = CommandFactory.createCommand(CommandTypes.Sync, socId_);
			else
				command = CommandFactory.createCommand(CommandTypes.Sync);
			
			//pushCommand(command);
		}
		
		public function sendParamCommand(id_ : String, value_ : String) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Param, id_, value_));
		}
		
		public function sendAuthCommand(socId_ : SocialIdentifier) : void
		{
			Logger.message("Sending Auth command.", TAG, LogLevel.Debug, LogModule.Model);

			pushCommand(CommandFactory.createCommand(CommandTypes.Auth, socId_));
		}
		
		public function sendFinishCommand() : void
		{
			Logger.message("Sending Finish command.", TAG, LogLevel.Debug, LogModule.Model);
			
			pushCommand(CommandFactory.createCommand(CommandTypes.Finish));
		}
		
		public function sendQuestCommand(id_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Quests, id_));
		}
		
		public function sendMoveCellCommand(storeId_ : StoreIdentifier, x_ : int, y_ : int) : void
		{
			Logger.message("Sending Move Cell command.", TAG, LogLevel.Debug, LogModule.Model);
			
			pushCommand(CommandFactory.createCommand(CommandTypes.Move, storeId_, x_, y_));
		}
		
		public function sendMoveWallCommand(storeId_ : StoreIdentifier, x_ : int, wall_ : int) : void
		{
			Logger.message("Sending Move Wall command.", TAG, LogLevel.Debug, LogModule.Model);
			
			pushCommand(CommandFactory.createCommand(CommandTypes.Move, storeId_, x_, wall_== 0 ? "NW" : "NE"));
		}
		
		public function sendTaskCommand(job_ : int, worker_ : int, backId_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Task, job_, worker_, backId_));
		}
		
		public function sendRotateCommand(storeId_ : StoreIdentifier, rot_ : int) : void
		{
			Logger.message("Sending Rotate command.", TAG, LogLevel.Debug, LogModule.Model);
	
			pushCommand(CommandFactory.createCommand(CommandTypes.Rotate, storeId_, rot_));
		}
		
		public function sendFriendCommand(id_ : String) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Friend, id_));
		}
		
		public function sendUnFriendCommand(id_ : String) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.UnFriend, id_));
		}
		
		public function sendSellCommand(storeId_ : StoreIdentifier, curr_ : String) : void
		{
			Logger.message("Sending Sell command.", TAG, LogLevel.Debug, LogModule.Model);
			
			pushCommand(CommandFactory.createCommand(CommandTypes.Sell, storeId_, curr_));
		}
		
		public function sendBuyMoveCellCommand(objId_ : ObjectIdentifier, curr_ : String, backId_ : int, x : int, y : int, skill : int = 0) : void
		{
			//true
			pushCommand(CommandFactory.createCommand(CommandTypes.BuyMove, objId_, curr_, backId_, x, y, skill));
			
			onSendTimer(null);
		}
		
		public function sendBuyMoveWallCommand(objId_ : ObjectIdentifier, curr_ : String, backId_ : int, x : int, wall : int) : void
		{
			//true
			pushCommand(CommandFactory.createCommand(CommandTypes.BuyMove, objId_, curr_, backId_, x, wall== 0 ? "NW" : "NE"));
			
			onSendTimer(null);
		}
		
		public function sendConvertCommand(id_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Convert, id_));
		}
		
		public function sendBuyCommand(objId_ : ObjectIdentifier, curr_ : String, backId_ : int, skill : int = 0) : void
		{
			Logger.message("Sending Buy command.", TAG, LogLevel.Debug, LogModule.Model);
			
			//true
			pushCommand(CommandFactory.createCommand(CommandTypes.Buy, objId_, curr_, backId_, skill));
			
			onSendTimer(null);
		}
		
		public function sendExpandCommand(expId : int, curr_ : String) : void
		{
			//true
			pushCommand(CommandFactory.createCommand(CommandTypes.Expand, expId, curr_));
			
			onSendTimer(null);
		}
		
		public function sendUnlockCommand(currency_ : String, job_ : int, expand_ : int, price_ : String, skill_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Unlock, currency_, job_, expand_, price_, skill_));
		}

		public function sendFertilizerCommand(job_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Fertilizer, job_));
			
			onSendTimer(null);
		}

		public function sendConfirmCommand(job_ : int, gift_ : int, quest_ : int, backid_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Confirm, job_, gift_, quest_, backid_));
		}
		
		public function sendAvatarCommand(partId_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Avatar, partId_));
		}
		
		public function sendCancelCommand(currTaskId_ : int) : void
		{
			pushCommand(CommandFactory.createCommand(CommandTypes.Cancel, currTaskId_));
		}
		
		public function sendGiftCommand(socId_ : String, objId_ : ObjectIdentifier, curr_ : String = "") : void
		{
			//true
			pushCommand(CommandFactory.createCommand(CommandTypes.Gift, socId_, objId_, curr_));
		}
		
		protected function pushCommand(command_ : Command) : void
		{
			/*if (!_server)
				if (command_.type != CommandTypes.Start)
					return;
			*/
			
			_pool.push(command_);
			
			//if (_server) sendXML(CommandFactory.createSingleCommandXML(command_, _version, _user, _session, SignUtil.sessionKey, SignUtil.secretSessionKey));
		}
		
		protected function sendXML(xml : XML) : void
		{
			var urlreq : URLRequest;
			
			if (!_server) {
				urlreq = new URLRequest(Address.InitPacket);
				trace(Address.InitPacket);
			}
			else
			{
				CONFIG::odnoklassniki
				{
					urlreq = new URLRequest("http://tomcat.java-dev.rwsib.ru/office/server");
				}
				CONFIG::development
				{
					urlreq = new URLRequest(MyOfficeGame.instance.serverPath==null ? "http://tomcat.java-dev.rwsib.ru/office/server" : MyOfficeGame.instance.serverPath);
				}
				
				urlreq.method = URLRequestMethod.POST;
				trace("send XML:");
				trace(xml);
			}
			
			urlreq.data = xml.toString();
			
			var urlloader : URLLoader = new URLLoader();
			
			urlloader.addEventListener(Event.COMPLETE, onComplete);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onIOError);
			
			try {
				urlloader.load(urlreq);
			} catch (error:Error) {
				trace(error);
			}
		}
		
		protected function onComplete(e : Event) : void
		{
			trace("got XML:\n", e.target.data.toString()/*.substr(0,2000)*/+"...")
			try {
				var newPacket : Packet = PacketFactory.createPacket(XML(e.target.data));
			} catch (error:Error) {
				Logger.message("XML format broken", TAG, LogLevel.Error, LogModule.Model);
				return;
			}

			Logger.message("Recieved packet.", TAG, LogLevel.Debug, LogModule.Model);
			
			if (newPacket.type == PacketTypes.Init)
			{
				_user = newPacket.user;
//				_puser = _user;
				
				_session = newPacket.session;
//				_psession = _session;
			}
			
			if (newPacket.version != _version)
			{
				Logger.message("Invalid Packet version.", TAG, LogLevel.Error, LogModule.Model);
			}
			
			Logger.message(newPacket.toString(), "", LogLevel.Debug, LogModule.Model);

			var newSendEvent : SenderEvent = new SenderEvent(SenderEvent.PacketRecieved);
			newSendEvent.packet = newPacket;
			
			dispatchEvent(newSendEvent);
		}
		
		protected function onSendTimer(e : TimerEvent, wait_ : Boolean = true) : void
		{
			if (_pool.length == 0)
				return;
			
			if (_server) sendXML(CommandFactory.createXML(_pool, _version, _user, _session, SignUtil.sessionKey, SignUtil.secretSessionKey));
			
			_pool = new Vector.<Command>();
		}
		
		protected function onIOError(e : Object) : void
		{
			
//			navigateToURL(new URLRequest("javascript:window.location.reload();"));
			
			MyOfficeGame.instance.serverError();
			
			Logger.message("Could not connect to server.", TAG, LogLevel.Fatal, LogModule.Model);
			Logger.message(e.text, "", LogLevel.Error, LogModule.Model);
		}
	}
}