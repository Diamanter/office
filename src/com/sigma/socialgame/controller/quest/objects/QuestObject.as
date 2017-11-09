package com.sigma.socialgame.controller.quest.objects
{
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;

	public class QuestObject
	{
		private var _questData : CurrQuestData;
		
		public function QuestObject()
		{
		}

		public function get questData():CurrQuestData
		{
			return _questData;
		}

		public function set questData(value:CurrQuestData):void
		{
			_questData = value;
		}

	}
}