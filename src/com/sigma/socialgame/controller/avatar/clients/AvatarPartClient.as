package com.sigma.socialgame.controller.avatar.clients
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.AvatarController;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.model.objects.config.flags.FlagData;
	import com.sigma.socialgame.model.objects.config.flags.FlagType;

	public class AvatarPartClient
	{
		private var _part : AvatarPartObject;
		
		public function AvatarPartClient()
		{
		}

		public function get part():AvatarPartObject
		{
			return _part;
		}

		public function set part(value:AvatarPartObject):void
		{
			_part = value;
		}

		protected function checkFlag(type_ : String) : Boolean
		{
			for each (var flag : FlagData in _part.part.flags)
			{
				if (flag.type == type_)
					return true;
			}
			
			return false;
		}
		
		public function saleLabel() :  Boolean
		{
			return checkFlag(FlagType.Sale);
		}
		
		public function newLabel() : Boolean
		{
			return checkFlag(FlagType.New_);
		}
		
		public function wasBought() : Boolean
		{
			return avatarController.wasBought(_part);
		}		

		public function select() : void
		{
			avatarController.fitPart(_part);
		}
		
		private var _aCon : AvatarController;
		
		protected function get avatarController() : AvatarController
		{
			if (_aCon == null)
				_aCon = ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			return _aCon;
		}
	}
}