package com.sigma.socialgame.view.gui.string
{
	import com.sigma.socialgame.common.Address;
	import com.sigma.socialgame.events.view.gui.StringManagerEvent;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;

	public class StringManager extends EventDispatcher
	{
		private var _map : Object;
		
		private static var _instance : StringManager;
		public var language:String = Capabilities.language;
		private var languageTextsXML:XML;
		private var languageTextsEnXML:XML;
		
		public function StringManager()
		{
			super();
			
			_instance = this;
			
			_map = new Object();

		}
		
		public function init(lang:String) : void
		{
			changeLanguage(lang);
			/*var urlreq : URLRequest = new URLRequest(Address.Strings);
			
			var urlloader : URLLoader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, onLoaded);
			urlloader.load(urlreq);*/
		}
		
		protected function onLoaded(e : Event = null) : void
		{
			var data : XML = languageTextsXML;
			
			_map[StringTypes.BuyOkWindow] = new StringCase(data.BuyOkWindowTitle, data.BuyOkWindowMessage);
			_map[StringTypes.CannotMove] = new StringCase(data.CannotMoveTitle, data.CannotMoveMessage);
			_map[StringTypes.NoMoneyWindow] = new StringCase(data.NoMoneyWindowTitle, data.NoMoneyWindowMessage);
			_map[StringTypes.TransferWindow] = new StringCase(data.TransferWindowTitle, data.TransferWindowMessage);
			_map[StringTypes.FireWorker] = new StringCase(data.FireWorkerTitle, data.FireWorkerMessage);
			_map[StringTypes.CancelTask] = new StringCase(data.CancelTaskTitle, data.CancelTaskMessage);
			_map[StringTypes.ConfirmGiftWindow] = new StringCase(data.ConfirmGiftWindowTitle, data.ConfirmGiftWindowMessage);
			_map[StringTypes.CannotExpandTooBig] = new StringCase(data.CannotExpandTooBigTitle, data.CannotExpandTooBigMessage);
			_map[StringTypes.CannotExpandTooSmall] = new StringCase(data.CannotExpandTooSmallTitle, data.CannotExpandTooSmallMessage);
			_map[StringTypes.LevelUp] = new StringCase(data.LevelUpTitle, data.LevelUpMessage);
			_map[StringTypes.WorkerLimit] = new StringCase(data.WorkerLimitTitle, data.WorkerLimitMessage);
			_map[StringTypes.ManureAlert] = new StringCase(data.ManureAlertTitle, data.ManureAlertMessage);
			_map[StringTypes.ErrorAlert] = new StringCase(data.ErrorAlertTitle, data.ErrorAlertMessage);
			_map[StringTypes.GiftAlert] = new StringCase(data.GiftAlertTitle, data.GiftAlertMessage);
			
			_map[StringTypes.NoFriends] = new StringCase(data.NoFriendsTitle, data.NoFriendsMessage);
			_map[StringTypes.NotThisFriend] = new StringCase(data.NotThisFriendTitle, data.NotThisFriendMessage);
			
			_map[StringTypes.ManureLimit] = new StringCase(data.ManureLimitTitle, data.ManureLimitMessage);
			
			_map[StringTypes.QuestPublish] = new StringCase(data.QuestPublishTitle, data.QuestPublishMessage, data.QuestPublish.ImageMessage);
			_map[StringTypes.ManurePublish] = new StringCase(data.ManurePublishTitle, data.ManurePublishMessage, data.ManurePublish.ImageMessage);
			_map[StringTypes.GiftPublish] = new StringCase(data.GiftPublishTitle, data.GiftPublishMessage, data.GiftPublish.ImageMessage);
			
			//dispatchEvent(new StringManagerEvent(StringManagerEvent.Loaded));
		}
		
		public function getCase(type_ : String) : StringCase
		{
			return _map[type_];
		}
		
		public function changeLanguage(lang:String) {
			var l:String = lang==null ? "en" : lang.split("_")[0];
			if (l=="ru") language = "ru_RU";
			else if (l=="fr") language = "fr_FR";
			else if (l=="tr") language = "tr_TR";
			else if (l=="de") language = "de_DE";
			else if (l=="es") language = "es_ES";
			else if (l=="it") language = "it_IT";
			else language = "en_US";
			var texts:XML = SkinManager.instance.getXML(language);
			if (texts!=null) {
				languageTextsXML = texts;
				languageTextsEnXML = SkinManager.instance.getXML("en_US");
			}
			onLoaded();
		}
		
		public function getText(key : String) : String
		{
			if (!languageTextsXML) return "";
			var result:String = languageTextsXML[key].toString();
			if (result.length==0) {
				result = languageTextsEnXML[key].toString();
			}
			return result;
		}
		
		public static function get instance() : StringManager
		{
			return _instance;
		}
	}
}