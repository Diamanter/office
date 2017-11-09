package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;

	public class SellControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "sellconInited";
		public static const Started : String = "sellconStarted";
		public static const Synced : String = "sellconSynced";
		
		public function SellControllerEvent(type:String)
		{
			super(type, ControllerNames.SellController);
		}
	}
}