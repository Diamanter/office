package com.sigma.socialgame.events.controller
{
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;

	public class QuestControllerEvent extends ControllerEvent
	{
		public static const Inited : String = "qcInited";
		public static const Started : String = "qcStarted";
		public static const Synced : String = "qcSynced";
		
		public static const QuestAdded : String = "qcQuestAdded";
		public static const QuetsDone : String = "qcQuestDone";
		public static const QuestConfirmed : String = "qcQuestConfirmed";
		
		private var _quest : QuestObject;
		
		public function QuestControllerEvent(type:String)
		{
			super(type, ControllerNames.AvatarController);
		}

		public function get quest():QuestObject
		{
			return _quest;
		}

		public function set quest(value:QuestObject):void
		{
			_quest = value;
		}

	}
}