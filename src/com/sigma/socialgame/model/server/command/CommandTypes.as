package com.sigma.socialgame.model.server.command
{
	public class CommandTypes
	{
		public static const Start : String = "start";
		public static const Auth : String = "auth";
		public static const Sync : String = "sync";
		public static const Finish : String = "finish";
		public static const Move : String = "move"; 
		public static const Rotate : String = "rotate";
		public static const Sell : String = "sell";
		public static const Buy : String = "buy";
		public static const BuyMove : String = "buymove";
		public static const Expand : String = "expand";
		public static const Unlock : String = "unlock";
		public static const Task : String = "task";
		public static const Cancel : String = "cancel";
		public static const Confirm : String = "confirm";
		public static const Fertilizer : String = "fertilizer";
		public static const Friend : String = "friend";
		public static const UnFriend : String = "unfriend";
		public static const Avatar : String = "avatar";
		public static const Gift : String = "gift";
		public static const Quests : String = "quests";
		public static const Convert : String = "convert";
		public static const Param : String = "param";
	}
	
	/*
	* Args:
	* -Start:  0 - SocId;
	* -Auth:   0 - SocId;
	* -Sync:   [0 - SocId];
	* -Finish: -
	* -Move:   0 - StoreId; 1 - x; 2 - y; (y - <wall(0;1)/y>)
	* -Rotate: 0 - StoreId; 1 - rot;
	* -Sell:   0 - StoreId; 1- curr;
	* -Buy:    0 - ObjId; 1 - curr; 2 - backId; 3 - skill
	* -BuyMove:0 - ObjId; 1 - curr; 2 - backId; 3 - x, 4 - y, 5 - skill
	* -Expand: 0 - ExpandId; 1 - curr
	* -Unlock: 0 - Currency; 1 - Job; 2 - Expand; 3 - Price; 4 - skill
	* -Task: 0 - Job; 1 - Worker; 2 - BackId;
	* -Cancel: 0 - Job;
	* -Confirm: 0 - Job; 1 - Gift; 2 - Quest; 3 - backId
	* -Fertilizer: 0 - Job;
	* -Friend: 0 - SocId;
	* -UnFriend: 0 - SocId;
	* -Avatar: 0 - PartId;
	* -Gift: 0 - SocId; 1 - ObjId; 2- Currency
	* -Quest: 0 - QuestId;
	* -Convert: 0 - ConvId;
	* -Param: 0 - ParamId; 1 - ParamValue
	*/
}