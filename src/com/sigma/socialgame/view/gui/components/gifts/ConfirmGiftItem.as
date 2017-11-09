package com.sigma.socialgame.view.gui.components.gifts
{
	import com.sigma.socialgame.controller.gift.clients.GiftClient;
	import com.sigma.socialgame.controller.gift.objects.CurrGiftObject;
	import com.sigma.socialgame.controller.gift.objects.GiftObject;
	import com.sigma.socialgame.events.controller.GiftControllerEvent;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ConfirmGiftItem extends GiftItem
	{
		private var _giftObject : CurrGiftObject;
		private var _num : int;
		
		public function ConfirmGiftItem()
		{
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.GiftItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				gold.visible = false;
				coins.visible = false;
				bought.visible = false;
				
				_graphic = new GiftGraphicLoader();
				image.addChild(_graphic);
				
				itemCount.text = "";
			}
		}
		
		public function get giftObject():CurrGiftObject
		{
			return _giftObject;
		}

		public function set giftObject(value:CurrGiftObject):void
		{
			_giftObject = value;
			
			_graphic.setImage(_giftObject.gift.obejct.objectId.id);
		}

		public function get num():int
		{
			return _num;
		}

		public function set num(value:int):void
		{
			_num = value;
			
			if (_num > 1)
				itemCount.text = String(_num);
		}

		private const _itemCount : String = "ItemCount";
		
		protected function get itemCount() : TextField
		{
			return _skin[_itemCount] as TextField;
		}
	}
}