package com.sigma.socialgame.controller.quest
{
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;

	public class QuestFactory
	{
		public static function createQuestObject(questData_ : CurrQuestData) : QuestObject
		{
			var newQO : QuestObject = new QuestObject();
			
			newQO.questData = questData_;
			
			return newQO;
		}
	}
}