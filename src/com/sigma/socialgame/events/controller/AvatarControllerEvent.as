package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class AvatarControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "acInited";
		public static const Started : String = "acStarted";
		public static const Synced : String = "acSynced";
		
		public static const StartFitting : String = "acStartFitting";
		public static const CancelFitting : String = "acCancelFitting";
		public static const AvatarChanged : String = "acApplyFitting";
		
		public static const FitPartChanged : String = "acFitPartChanged";
		
		public static const AmountChanged: String = "acAmountChanged";
		
		private var _part : AvatarPartObject;
		
		public function AvatarControllerEvent(type:String)
		{
			super(type, ControllerNames.AvatarController);
		}

		public function get part():AvatarPartObject
		{
			return _part;
		}

		public function set part(value:AvatarPartObject):void
		{
			_part = value;
		}
	}
}