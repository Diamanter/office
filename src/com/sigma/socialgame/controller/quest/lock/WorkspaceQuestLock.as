package com.sigma.socialgame.controller.quest.lock
{
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.components.shop.Shop;
	import com.sigma.socialgame.view.gui.components.task.TaskChoice;

	public class WorkspaceQuestLock extends QuestLock
	{
		public function WorkspaceQuestLock(id_ : int)
		{
			super(id_);
		}
		
		public override function lock():void
		{
			GuiManager.instance.selectShop();
			GuiManager.instance.lockButtons();
			GuiManager.instance.lockMenus();
			GuiManager.instance.lockTaskChoise();
			Shop.instance.selectWorkspace();
			Shop.instance.lockTabs();
			TaskChoice.instance.lockFire();
		}
		
		public override function unlock():void
		{
			GuiManager.instance.unlockButtons();
			GuiManager.instance.unlockMenus();
			GuiManager.instance.unlockTaskChoise();
			Shop.instance.unlockTabs();
			TaskChoice.instance.unlockFire();
		}
	}
}