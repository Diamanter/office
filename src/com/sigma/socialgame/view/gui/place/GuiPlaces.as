package com.sigma.socialgame.view.gui.place
{
	import com.sigma.socialgame.common.Address;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GuiPlaces
	{
		private static var _callback : Function;
		
		private static var _data : XML;
		
		public static function init(callback_ : Function) : void
		{
			_callback = callback_;
			
			var urlreq : URLRequest = new URLRequest(Address.Places);
			
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(urlreq);
		}

		protected static function onComplete(e : Event) : void
		{
			_data = XML(e.target.data);
			
			e.target.removeEventListener(Event.COMPLETE, onComplete);
			
			SelectButtonPlace = new Place(
				new Vector3D(_data.SelectButton.@x, _data.SelectButton.@y, _data.SelectButton.@z),
				new Vector3D(_data.SelectButton.FullScreen.@x, _data.SelectButton.FullScreen.@y),
				_data.SelectButton.FullScreen.@align
				);
			
			MoveButtonPlace = new Place(
				new Vector3D(_data.MoveButton.@x, _data.MoveButton.@y, _data.MoveButton.@z),
				new Vector3D(_data.MoveButton.FullScreen.@x, _data.MoveButton.FullScreen.@y),
				_data.MoveButton.FullScreen.@align
				);
		
			RotateButtonPlace = new Place(
				new Vector3D(_data.RotateButton.@x, _data.RotateButton.@y, _data.RotateButton.@z),
				new Vector3D(_data.RotateButton.FullScreen.@x, _data.RotateButton.FullScreen.@y),
				_data.RotateButton.FullScreen.@align
				);
			
			SellButtonPlace = new Place(
				new Vector3D(_data.SellButton.@x, _data.SellButton.@y, _data.SellButton.@z),
				new Vector3D(_data.SellButton.FullScreen.@x, _data.SellButton.FullScreen.@y),
				_data.SellButton.FullScreen.@align
				);
			
			ShopButtonPlace = new Place(
				new Vector3D(_data.ShopButton.@x, _data.ShopButton.@y, _data.ShopButton.@z),
				new Vector3D(_data.ShopButton.FullScreen.@x, _data.ShopButton.FullScreen.@y),
				_data.ShopButton.FullScreen.@align
				);
			
			FriendButtonPlace = new Place(
				new Vector3D(_data.FriendButton.@x, _data.FriendButton.@y, _data.FriendButton.@z),
				new Vector3D(_data.FriendButton.FullScreen.@x, _data.FriendButton.FullScreen.@y),
				_data.FriendButton.FullScreen.@align
				);
			
			GiftButtonPlace = new Place(
				new Vector3D(_data.GiftsButton.@x, _data.GiftsButton.@y, _data.GiftsButton.@z),
				new Vector3D(_data.GiftsButton.FullScreen.@x, _data.GiftsButton.FullScreen.@y),
				_data.GiftsButton.FullScreen.@align
				);
			
			CustButtonPlace = new Place(
				new Vector3D(_data.CustomizeButton.@x, _data.CustomizeButton.@y, _data.CustomizeButton.@z),
				new Vector3D(_data.CustomizeButton.FullScreen.@x, _data.CustomizeButton.FullScreen.@y),
				_data.CustomizeButton.FullScreen.@align
				);
			
			InventoryButtonPlace = new Place(
				new Vector3D(_data.InventoryButton.@x, _data.InventoryButton.@y, _data.InventoryButton.@z),
				new Vector3D(_data.InventoryButton.FullScreen.@x, _data.InventoryButton.FullScreen.@y),
				_data.InventoryButton.FullScreen.@align
				);
			
			QuestButtonPlace = new Place(
				new Vector3D(_data.QuestButton.@x, _data.QuestButton.@y, _data.QuestButton.@z),
				new Vector3D(_data.QuestButton.FullScreen.@x, _data.QuestButton.FullScreen.@y),
				_data.QuestButton.FullScreen.@align
				);
			
			HomeButtonPlace = new Place(
				new Vector3D(_data.HomeButton.@x, _data.HomeButton.@y, _data.HomeButton.@z),
				new Vector3D(_data.HomeButton.FullScreen.@x, _data.HomeButton.FullScreen.@y),
				_data.HomeButton.FullScreen.@align
				);
			
			CancelBuyButton = new Place(
				new Vector3D(_data.CancelBuyButton.@x, _data.CancelBuyButton.@y, _data.CancelBuyButton.@z),
				new Vector3D(_data.CancelBuyButton.@x, _data.CancelBuyButton.@y, _data.CancelBuyButton.@z),
				_data.CancelBuyButton.FullScreen.@align
				);
			
			CustomizeWindowPlace = new DimPlace(
				new Vector3D(_data.CustomizeWindow.@x, _data.CustomizeWindow.@y, _data.CustomizeWindow.@z),
				new Vector3D(_data.CustomizeWindow.FullScreen.@x, _data.CustomizeWindow.FullScreen.@y),
				_data.CustomizeWindow.FullScreen.@align,
				new Vector3D(_data.CustomizeWindow.@dimX, _data.CustomizeWindow.@dimY)
				);
			
//			CustomizeWindowDim = new Vector3D(_data.CustomizeWindow.@dimX, _data.CustomizeWindow.@dimY);
			
			GiftsWindowPlace = new DimPlace(
				new Vector3D(_data.GiftsWindow.@x, _data.GiftsWindow.@y, _data.GiftsWindow.@z),
				new Vector3D(_data.GiftsWindow.FullScreen.@x, _data.GiftsWindow.FullScreen.@y),
				_data.GiftsWindow.FullScreen.@align,
				new Vector3D(_data.GiftsWindow.@dimX, _data.GiftsWindow.@dimY)
				);
			
//			GiftsWindowDim = new Vector3D(_data.GiftsWindow.@dimX, _data.GiftsWindow.@dimY);
			
			InventoryWindowPlace = new DimPlace(
				new Vector3D(_data.InventoryWindow.@x, _data.InventoryWindow.@y, _data.InventoryWindow.@z),
				new Vector3D(_data.InventoryWindow.FullScreen.@x, _data.InventoryWindow.FullScreen.@y),
				_data.InventoryWindow.FullScreen.@align,
				new Vector3D(_data.InventoryWindow.@dimX, _data.InventoryWindow.@dimY)
				);
			
//			InventoryWindowDim = new Vector3D(_data.InventoryWindow.@dimX, _data.InventoryWindow.@dimY);
			
			ConfirmGiftsWindowPlace = new DimPlace(
				new Vector3D(_data.ConfirmGiftsWindow.@x, _data.ConfirmGiftsWindow.@y, _data.ConfirmGiftsWindow.@z),
				new Vector3D(_data.ConfirmGiftsWindow.FullScreen.@x, _data.ConfirmGiftsWindow.FullScreen.@y),
				_data.ConfirmGiftsWindow.FullScreen.@align,
				new Vector3D(_data.ConfirmGiftsWindow.@dimX, _data.ConfirmGiftsWindow.@dimY)
				);
			
//			ConfirmGiftsWindowDim = new Vector3D(_data.ConfirmGiftsWindow.@dimX, _data.ConfirmGiftsWindow.@dimY);
			
			FriendsWindowPlace = new DimPlace(
				new Vector3D(_data.FriendsWindow.@x, _data.FriendsWindow.@y, _data.FriendsWindow.@z),
				new Vector3D(_data.FriendsWindow.FullScreen.@x, _data.FriendsWindow.FullScreen.@y),
				_data.FriendsWindow.FullScreen.@align,
				new Vector3D(_data.FriendsWindow.@dimX, _data.FriendsWindow.@dimY)
				);
			
			QuestBarPlace = new DimPlace(
				new Vector3D(_data.QuestBar.@x, _data.QuestBar.@y, _data.QuestBar.@z),
				new Vector3D(_data.QuestBar.FullScreen.@x, _data.QuestBar.FullScreen.@y),
				_data.QuestBar.FullScreen.@align,
				new Vector3D(_data.QuestBar.@dimX, _data.QuestBar.@dimY)
			);
			
//			FriendsWindowDim = new Vector3D(_data.FriendsWindow.@dimX, _data.FriendsWindow.@dimY);
			
			TransferWindowPlace = new Place(
				new Vector3D(_data.TransferWindow.@x, _data.TransferWindow.@y, _data.TransferWindow.@z),
				new Vector3D(_data.TransferWindow.FullScreen.@x, _data.TransferWindow.FullScreen.@y),
				_data.TransferWindow.FullScreen.@align
				);
			
			NoMoneyWindowPlace = new Place(
				new Vector3D(_data.NoMoneyWindow.@x, _data.NoMoneyWindow.@y, _data.NoMoneyWindow.@z),
				new Vector3D(_data.NoMoneyWindow.FullScreen.@x, _data.NoMoneyWindow.FullScreen.@y),
				_data.NoMoneyWindow.FullScreen.@align
				);
			
			ConfirmQuestWindowPlace = new DimPlace(
				new Vector3D(_data.ConfirmQuestWindow.@x, _data.ConfirmQuestWindow.@y, _data.ConfirmQuestWindow.@z),
				new Vector3D(_data.ConfirmQuestWindow.FullScreen.@x, _data.ConfirmQuestWindow.FullScreen.@y),
				_data.ConfirmQuestWindow.FullScreen.@align,
				new Vector3D(_data.ConfirmQuestWindow.@dimX, _data.ConfirmQuestWindow.@dimY)
			);
			
			BuyOkWindowPlace = new Place(
				new Vector3D(_data.BuyOkWindow.@x, _data.BuyOkWindow.@y, _data.BuyOkWindow.@z),
				new Vector3D(_data.BuyOkWindow.FullScreen.@x, _data.BuyOkWindow.FullScreen.@y),
				_data.BuyOkWindow.FullScreen.@align
				);
			
			QuestWindowPlace = new Place(
				new Vector3D(_data.QuestWindow.@x, _data.QuestWindow.@y, _data.QuestWindow.@z),
				new Vector3D(_data.QuestWindow.FullScreen.@x, _data.QuestWindow.FullScreen.@y),
				_data.QuestWindow.FullScreen.@align
				);
			
			HelpWindowPlace = new Place(
				new Vector3D(_data.HelpWindow.@x, _data.HelpWindow.@y, _data.HelpWindow.@z),
				new Vector3D(_data.HelpWindow.FullScreen.@x, _data.HelpWindow.FullScreen.@y),
				_data.HelpWindow.FullScreen.@align
				);
			
			AlertWindowPlace = new Place(
				new Vector3D(_data.AlertWindow.@x, _data.AlertWindow.@y, _data.AlertWindow.@z),
				new Vector3D(_data.AlertWindow.FullScreen.@x, _data.AlertWindow.FullScreen.@y),
				_data.AlertWindow.FullScreen.@align
				);
			
			ErrorAlertPlace = new Place(
				new Vector3D(_data.ErrorAlert.@x, _data.ErrorAlert.@y, _data.ErrorAlert.@z),
				new Vector3D(_data.ErrorAlert.FullScreen.@x, _data.ErrorAlert.FullScreen.@y),
				_data.ErrorAlert.FullScreen.@align
			);
			
			ManureAlertPlace = new Place(
				new Vector3D(_data.ManureAlert.@x, _data.ManureAlert.@y, _data.ManureAlert.@z),
				new Vector3D(_data.ManureAlert.FullScreen.@x, _data.ManureAlert.FullScreen.@y),
				_data.ManureAlert.FullScreen.@align
				);
			
			GiftAlertPlace = new Place(
				new Vector3D(_data.GiftAlert.@x, _data.GiftAlert.@y, _data.GiftAlert.@z),
				new Vector3D(_data.GiftAlert.FullScreen.@x, _data.GiftAlert.FullScreen.@y),
				_data.GiftAlert.FullScreen.@align
			);
			
			ConfirmWindowPlace = new Place(
				new Vector3D(_data.ConfirmWindow.@x, _data.ConfirmWindow.@y, _data.ConfirmWindow.@z),
				new Vector3D(_data.ConfirmWindow.FullScreen.@x, _data.ConfirmWindow.FullScreen.@y),
				_data.ConfirmWindow.FullScreen.@align
				);
			
			InfoBarPlace = new Place(
				new Vector3D(_data.InfoBar.@x, _data.InfoBar.@y, _data.InfoBar.@z),
				new Vector3D(_data.InfoBar.FullScreen.@x, _data.InfoBar.FullScreen.@y),
				_data.InfoBar.FullScreen.@align
				);
			
			TaskChoicePlace = new Place(
				new Vector3D(_data.TaskChoice.@x, _data.TaskChoice.@y, _data.TaskChoice.@z),
				new Vector3D(_data.TaskChoice.FullScreen.@x, _data.TaskChoice.FullScreen.@y),
				_data.TaskChoice.FullScreen.@align
				);
			
			ShopPlace = new Place(
				new Vector3D(_data.Shop.@x, _data.Shop.@y, _data.Shop.@z),
				new Vector3D(_data.Shop.FullScreen.@x, _data.Shop.FullScreen.@y),
				_data.Shop.FullScreen.@align
				);
			
			FriendsPlace = new Place(
				new Vector3D(_data.Friends.@x, _data.Friends.@y, _data.Friends.@z),
				new Vector3D(_data.Friends.FullScreen.@x, _data.Friends.FullScreen.@y),
				_data.Friends.FullScreen.@align
				);
			
			ButtonOverScale = _data.Scales.@ButtonOverScale;
			
			_callback();
			
			_callback = null;
		}
		
		public static var ButtonOverScale : Number;

		public static var SelectButtonPlace : Place;
		public static var MoveButtonPlace : Place;
		public static var RotateButtonPlace : Place;
		public static var SellButtonPlace : Place;
		
		public static var CancelBuyButton : Place;
		
		public static var ShopButtonPlace : Place;
		public static var FriendButtonPlace : Place;
		public static var GiftButtonPlace : Place;
		public static var CustButtonPlace : Place;
		public static var InventoryButtonPlace : Place;
		public static var QuestButtonPlace : Place;
		public static var HomeButtonPlace : Place;
		
		public static var ConfirmWindowPlace : Place;
		
		public static var ConfirmQuestWindowPlace : DimPlace;
		
		public static var InventoryWindowPlace : DimPlace;
		
		public static var ManureAlertPlace : Place;
		public static var GiftAlertPlace : Place;
		
		public static var TransferWindowPlace : Place;
		public static var NoMoneyWindowPlace : Place;
		public static var BuyOkWindowPlace : Place;
		
		public static var HelpWindowPlace : Place;
		
		public static var QuestBarPlace : DimPlace;
		
		public static var CustomizeWindowPlace : DimPlace;
		
		public static var GiftsWindowPlace : DimPlace;
		
		public static var ConfirmGiftsWindowPlace : DimPlace;
		
		public static var FriendsWindowPlace : DimPlace;
		
		public static var QuestWindowPlace : Place;
		
		public static var AlertWindowPlace : Place;
		
		public static var ErrorAlertPlace : Place;
		
		public static var InfoBarPlace : Place;
		public static var TaskChoicePlace : Place;
		
		public static var ShopPlace : Place;
		public static var FriendsPlace : Place;
	}
}