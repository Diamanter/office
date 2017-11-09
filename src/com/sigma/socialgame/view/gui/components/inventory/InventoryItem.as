package com.sigma.socialgame.view.gui.components.inventory
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.sell.SellController;
	import com.sigma.socialgame.controller.shop.ShopController;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.events.controller.StoreControllerEvent;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	public class InventoryItem extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _storeObject : StoreObject;
		
		private var _num : int;
		
		private var _graphicLoader : InventoryGraphicLoader;
		
		public function InventoryItem()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.InventoryItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);

				_skin.addEventListener(MouseEvent.CLICK, onSkinMouseEvent);
				
				unlockButton.gotoAndStop(1);
				unlockButton.visible = false;
				unlock.visible = false;
				
				coinsImage.visible = false;
				goldImage.visible = false;
				
				sellItem.gotoAndStop(1);
				
				sellItem.addEventListener(MouseEvent.CLICK, onSellMouseEvent);
				
				sellItem.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				sellItem.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				
				_graphicLoader = new InventoryGraphicLoader();
				
				image.addChild(_graphicLoader);
				
				storeController.addEventListener(StoreControllerEvent.StoreObjectRemoved, onObjectRemoved);
			}
		}
		
		protected function onSkinMouseEvent(e : MouseEvent) : void
		{
			var objs : Vector.<StoreObject> = storeController.inventory;
			
			for each (var obj : StoreObject in objs)
			{
				if (obj.storeObject.object.objectId.id == _storeObject.storeObject.object.objectId.id)
				{
					InventoryWindow.hide();
					
					Map.instance.addMapEntity(obj, shopController.getClientForStoreObject(obj));
//					Map.instance.addMapEntity(obj, null);
					
					break;
				}
			}
		}
		
		protected function onObjectRemoved(e : StoreControllerEvent) : void
		{
			if (e.storeObject.storeObject.object.objectId.id == _storeObject.storeObject.object.objectId.id)
			{
				if (num > 1)
					num--;
				else
					InventoryWindow.reinit();
			}
		}
		
		protected function onSellMouseEvent(e : MouseEvent) : void
		{
			var sCon : SellController = ControllerManager.instance.getController(ControllerNames.SellController) as SellController;
			var objs : Vector.<StoreObject> = storeController.inventory;
			
			for each (var obj : StoreObject in objs)
			{
				if (obj.storeObject.object.objectId.id == _storeObject.storeObject.object.objectId.id)
				{
					sCon.sell(obj.storeObject);
					
					break;
				}
			}
			
			e.stopImmediatePropagation();
		}
		
		protected function onMouseEvent(e : MouseEvent) : void
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
		
		public function get storeObject():StoreObject
		{
			return _storeObject;
		}

		public function set storeObject(value:StoreObject):void
		{
			_storeObject = value;
			
			if (_storeObject.storeObject.object.type != ObjectTypes.Worker)
				_graphicLoader.setImage(_storeObject.storeObject.object.objectId.id);
			else
				_graphicLoader.setImage(_storeObject.storeObject.object.objectId.id, (_storeObject.storeObject as WorkerStoreObjectData).currSkill);
			
			itemNameTF.text = _storeObject.storeObject.object.name;
			
			var i : int;
			
			if (_storeObject.storeObject is WorkerStoreObjectData)
			{
				for (i = 0; i < (_storeObject.storeObject as WorkerStoreObjectData).currSkill.rank; i++)
				{
					var filters : Array = new Array();
					
					for each (var filter : BitmapFilter in getStar(i).filters)
					{
						if (!(filter is ColorMatrixFilter))
						{
							filters.push(filter);
						}
					}
					
					getStar(i).filters = filters;
				}
			}
			else
			{
				for (i = 0; i < 3; i++)
				{
					getStar(i).visible = false;
				}
			}
			
		}

		public function get num():int
		{
			return _num;
		}
		
		public function set num(value:int):void
		{
			_num = value;
			
			if (_num > 1)
				itemCountTF.text = String(_num);
			else
				itemCountTF.text = "";
		}
		
		private const _unlockCost : String = "Cost";
		private const _unlock : String = "unlockButton"
		private const _unlockButton : String = "unlockButton";
		private const _itemName : String = "itemName";
		private const _itemCount : String = "ItemCount";
		private const _image : String = "image";
		private const _cost : String = "Cost";
		
		private const _sellItem : String = "SellItem";
		
		private const _line1 : String = "RequaredOne";
		private const _line2 : String = "RequaredTwo";
		private const _line3 : String = "RequaredThree";
		
		private const _goldImage : String = "Maney1";
		private const _coinsImage : String = "Maney0";
		
		private const _star : String = "star";
		
		protected function get sellItem() : MovieClip
		{
			return _skin[_sellItem];
		}
		
		protected function get line1() : TextField
		{
			return unlock[_line1];
		}
		
		protected function get line2() : TextField
		{
			return unlock[_line2];
		}
		
		protected function get line3() : TextField
		{
			return unlock[_line3];
		}
		
		protected function get unlock() : MovieClip
		{
			return _skin[_unlock];
		}
		
		protected function get unlockButton() : MovieClip
		{
			return unlock[_unlockButton] as MovieClip;
		}
		
		protected function get unlockCost() : TextField
		{
			return unlockButton[_unlockCost];
		}
		
		protected function getStar(ind_ : int) : MovieClip
		{
			return _skin[_star + "" + ind_];
		}
		
		protected function get goldImage() : MovieClip
		{
			return _skin[_goldImage];
		}
		
		protected function get coinsImage() : MovieClip
		{
			return _skin[_coinsImage];
		}
		
		protected function get costTF() : TextField
		{
			return _skin[_cost] as TextField;
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image] as MovieClip;
		}
		
		protected function get itemNameTF() : TextField
		{
			return _skin[_itemName] as TextField;
		}
		
		protected function get itemCountTF() : TextField
		{
			return _skin[_itemCount] as TextField;
		}
		
		protected function get shopController() : ShopController
		{
			return ControllerManager.instance.getController(ControllerNames.ShopController) as ShopController;
		}
		
		protected function get storeController() : StoreController
		{
			return ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
		}
	}
}