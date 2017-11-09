package com.sigma.socialgame.controller.quest.lock
{
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.components.task.TaskChoice;

	public class TaskQuestLock extends QuestLock
	{
		public function TaskQuestLock(id_:int)
		{
			super(id_);
		}
		
		public override function lock():void
		{
			GuiManager.instance.selectFriends();
			GuiManager.instance.lockButtons();
			GuiManager.instance.lockMenus();
			TaskChoice.instance.lockFire();
		}
		
		public override function unlock():void
		{
			GuiManager.instance.unlockButtons();
			GuiManager.instance.unlockMenus();
			TaskChoice.instance.unlockFire();
		}
	}
}