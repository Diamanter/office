package com.sigma.socialgame.view.gui.components.gifts
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.gift.GiftController;
	import com.sigma.socialgame.controller.gift.objects.CurrGiftObject;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.BaseTab;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.osmf.layout.AbsoluteLayoutFacet;
	
	public class ConfirmGiftsWindow extends Sprite
	{
		public static var ScreenDim : Array;
		
		private var _skin : MovieClip;
		private var _mainTab : BaseTab;
		
		public function ConfirmGiftsWindow()
		{
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.ConfirmGiftsWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				ScreenDim = [GuiPlaces.ConfirmGiftsWindowPlace.dim.x, GuiPlaces.ConfirmGiftsWindowPlace.dim.y];
				
				addChild(_skin);
				
				share.gotoAndStop(1);
				share.visible = false;
				
				var widgets : Array =
					[
						{ Widget: closeButt, Function: onCloseButtonClick },
						{ Widget: okButt, Function: onOkButtonClick },
						{ Widget: leftButt, Function: onLeftButtonClick },
						{ Widget: rightButt, Function: onRightButtonClick },
					];
				
				for each (var obj : Object in widgets)
				{
					obj.Widget.gotoAndStop(1);
					
					if (obj.Function != null)
					{
						obj.Widget.addEventListener(MouseEvent.CLICK, obj.Function);
					}
					
					obj.Widget.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					obj.Widget.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);					
				}
				
				init();
			}
		}
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
				GuiManager.instance.windowOpened(this);
			else
				GuiManager.instance.windowClosed(this);
		}
		
		public function checkGifts() : Boolean
		{
			if (giftController.currGifts.length > 0)
				return true;
			
			return false;
		}
		
		protected function init():void
		{	
			_mainTab = new BaseTab(ConfirmGiftsWindow.ScreenDim[0], ConfirmGiftsWindow.ScreenDim[1]);
			
			gifts.addChild(_mainTab);

			var result : Object = new Object();
			
			var types : Vector.<String> = new Vector.<String>();
			var type : String;
			var foundType : Boolean;
			
			for each (var currgift : CurrGiftObject in giftController.currGifts)
			{
				type = currgift.gift.obejct.objectId.id;
			
				foundType = false;
				
				for each (var t : String in types)
				{
					if (t == type)
					{
						foundType = true;
						
						break;
					}
				}
				
				if (!foundType)
					types.push(type);
				
				if (result[type] == null)
				{
					result[type] = new Vector.<CurrGiftObject>();
				}
				
				result[type].push(currgift);
			}
			
			for each (type in types)
			{
				var newItem : ConfirmGiftItem = new ConfirmGiftItem();
				
				newItem.giftObject = result[type][0];
				newItem.num = result[type].length;
				
				_mainTab.addItem(newItem);
			}
			
/*			for each (var currgift : CurrGiftObject in giftController.currGifts)
			{
				var newItem : ConfirmGiftItem = new ConfirmGiftItem();
				newItem.giftObject = currgift;
				_mainTab.addItem(newItem);
			}
*/			
			closeButt.visible = false;
			
			var stringCase : StringCase = StringManager.instance.getCase(StringTypes.ConfirmGiftWindow);
			
			title.text = stringCase.title;
			message.text = stringCase.message;
		}
		
		protected function onLeftButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoLeft();
		}
		
		protected function onRightButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoRight();
		}
		
		protected function onMouseEvent(e : Event) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					mc.gotoAndStop(2);
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					mc.gotoAndStop(1);
					
					break;
			}
		}
		
		protected function onOkButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			visible = !visible;
			
			giftController.confirmGifts();
		}

		protected function onCloseButtonClick(e : Event) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			visible = !visible;
		}
		
		private const _closeButt : String = "Close";
		private const _okButt : String = "Ok";
		private const _title : String = "Title";
		private const _message : String = "Message_Text";
		
		private const _items : String = "ItemSlot";
		private const _leftButt : String = "Left";
		private const _rightButt : String = "Right";
		private const _gifts : String = "Gifts";
		
		private const _share : String = "to_wall";
		
		protected function get share() : MovieClip
		{
			return _skin[_share];
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
		
		protected function get okButt() : MovieClip
		{
			return _skin[_okButt] as MovieClip;
		}
		
		protected function get title() : TextField
		{
			return _skin[_title] as TextField;
		}
		
		protected function get message() : TextField
		{
			return _skin[_message] as TextField;
		}
		
		protected function get items() : MovieClip
		{
			return _skin[_items] as MovieClip;
		}
		
		protected function get leftButt() : MovieClip
		{
			return items[_leftButt] as MovieClip;
		}
		
		protected function get rightButt() : MovieClip
		{
			return items[_rightButt] as MovieClip;
		}
		
		protected function get gifts() : MovieClip
		{
			return items[_gifts] as MovieClip;
		}
		
		protected function get giftController() : GiftController
		{
			return ControllerManager.instance.getController(ControllerNames.GiftController) as GiftController;
		}
	}
}