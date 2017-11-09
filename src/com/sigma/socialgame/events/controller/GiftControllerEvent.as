package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.gift.objects.GiftObject;

	public class GiftControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "gcInited";
		public static const Started : String = "gcStarted";
		public static const Synced : String = "gcSynced";
		public static const Selected : String = "gcSelected";
		public static const Unselected : String = "gcUnselected";
		
		public var selected : GiftObject;
		
		public function GiftControllerEvent(type:String)
		{
			super(type, ControllerNames.GiftController);
		}
	}
}