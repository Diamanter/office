package com.sigma.socialgame.controller.friends.clients
{
	import com.sigma.socialgame.view.gui.GuiManager;

	public class AppFriendClient extends AbstractFriendClient
	{
		public function AppFriendClient()
		{
			super();
		}
		
		public function gotoOffice() : void
		{
			friendContoller.gotoOffice(friendObject);
		}
		
		public function sendGift() : void
		{
			friendContoller.clearSelected();
			friendContoller.select(friendObject);
			
			GuiManager.instance.giftsWindow.sendAfterConfirm = true;
			GuiManager.instance.giftsWindow.visible = true;
		}
	}
}