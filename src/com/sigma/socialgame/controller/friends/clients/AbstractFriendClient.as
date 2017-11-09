package com.sigma.socialgame.controller.friends.clients
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.friends.objects.FriendObject;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractFriendClient extends EventDispatcher
	{
		private var _friendObject : FriendObject;
		
		public function AbstractFriendClient()
		{
			super();
		}

		public function get friendObject():FriendObject
		{
			return _friendObject;
		}

		public function set friendObject(value:FriendObject):void
		{
			_friendObject = value;
		}

		private var _frController : FriendsContoller;
		
		protected function get friendContoller() : FriendsContoller
		{
			if (_frController == null)
				_frController = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			return _frController;
		}
	}
}