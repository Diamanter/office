package com.sigma.socialgame.controller.quest.lock
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.quest.QuestController;
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.events.controller.QuestControllerEvent;
	import com.sigma.socialgame.view.gui.components.quest.QuestBar;

	public class QuestLocks
	{
		private var _questLockMap : Object;
		private var _currLock : QuestLock;
		
		public function QuestLocks()
		{
			_questLockMap = new Object();
			
			_questLockMap["1"] = new WorkspaceQuestLock(1);
			_questLockMap["2"] = new WorkerQuestLock(2);
			_questLockMap["3"] = new TaskQuestLock(3);
		}
		
		public function checkLock() : void
		{
			var qo : QuestObject;
			
			var found : Boolean = false;
			
			if (_currLock != null)
			{
				for each (qo in questController.quests)
				{
					if (qo.questData.type == _currLock.id)
					{
						found = true;
						
						break;
					}
				}
				
				if (!found)
				{
					_currLock.unlock();
				}
			}
			
			for each (qo in questController.quests)
			{
				if (_questLockMap[qo.questData.type] != null)
				{
					_currLock = _questLockMap[qo.questData.type];
					
					_currLock.lock();
					
					QuestBar.instance.showWindow(qo);
				}
			}
		}
		
		protected function get questController() : QuestController
		{
			return ControllerManager.instance.getController(ControllerNames.QuestController) as QuestController;
		}
	}
}