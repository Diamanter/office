package com.sigma.socialgame.view.gui.components.help
{
	import com.sigma.socialgame.common.Address;
	import com.sigma.socialgame.events.view.gui.HelpManagerEvent;
	import com.sigma.socialgame.view.gui.GuiManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class HelpManager extends EventDispatcher
	{
		private static var _instance : HelpManager;
		
		private var _map : Object;
		
		public function HelpManager() : void
		{
			_instance = this;
			
			_map = new Object();
			
		}
		
		public function init() : void
		{
			var urlreq : URLRequest = new URLRequest(Address.Help);
			
			var urlloader : URLLoader = new URLLoader();
			urlloader.addEventListener(Event.COMPLETE, onLoaded);
			urlloader.load(urlreq);
		}
		
		protected function onLoaded(e : Event) : void
		{
			var data : XML = XML(e.target.data);
			
			_map[HelpCaseType.TaskChoiseHelp] = new HelpCase(data.TaskChoise.title, data.TaskChoise.message, data.TaskChoise.@image);
			_map[HelpCaseType.ShopHelp] = new HelpCase(data.Shop.title, data.Shop.message, data.Shop.@image);
			_map[HelpCaseType.CustomizeHelp] = new HelpCase(data.Customize.title, data.Customize.message, data.Customize.@image);
			_map[HelpCaseType.FriendsHelp] = new HelpCase(data.Friends.title, data.Friends.message,data.Friends.@image);
			_map[HelpCaseType.GiftsHelp] = new HelpCase(data.Gifts.title, data.Gifts.message, data.Gifts.@image);
			_map[HelpCaseType.QuestsHelp] = new HelpCase(data.Quests.title, data.Quests.message, data.Quests.@image);
			_map[HelpCaseType.Inventory] = new HelpCase(data.Inventory.title, data.Inventory.message, data.Inventory.@image);
			
			dispatchEvent(new HelpManagerEvent(HelpManagerEvent.Inited));
		}
		
		public function showHelpCase(helpCase_ : int) : void
		{
			GuiManager.instance.showHelp(_map[helpCase_].title, _map[helpCase_].message, _map[helpCase_].image);
		}
		
		public static function get instance() : HelpManager
		{
			return _instance;
		}
	}
}