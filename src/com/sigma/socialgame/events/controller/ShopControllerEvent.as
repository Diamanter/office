package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;

	public class ShopControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "shopcInited";
		public static const Started : String = "shopcStarted";
		public static const Synced : String = "shopcSynced";
		
		public function ShopControllerEvent(type:String)
		{
			super(type, ControllerNames.ShopController);
		}
	}
}