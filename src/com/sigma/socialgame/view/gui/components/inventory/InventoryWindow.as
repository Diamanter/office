package com.sigma.socialgame.view.gui.components.inventory
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.BaseTab;
	import com.sigma.socialgame.view.gui.components.help.HelpCaseType;
	import com.sigma.socialgame.view.gui.components.help.HelpManager;
	import com.sigma.socialgame.view.gui.place.GuiPlaces;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class InventoryWindow extends Sprite
	{
		public static var ScreenDim : Array;
		
		private var _skin : MovieClip;
		
		private var _mainTab : BaseTab;
		
		public function InventoryWindow()
		{
			super();
			
			_instance = this;
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.InventoryWindow);
			
			if (clazz != null)
			{
				ScreenDim = [GuiPlaces.InventoryWindowPlace.dim.x, GuiPlaces.InventoryWindowPlace.dim.y];
				
				_skin = new clazz();
				
				addChild(_skin);
				
				applyButt.gotoAndStop(1);
				backButt.gotoAndStop(1);
				chooseButt.gotoAndStop(1);
				
				applyButt.visible = false;
				backButt.visible = false;
				chooseButt.visible = false;
				
				titleTextField.text = "Склад";
				
				var widgets : Array =
					[
						{ Widget: closeButt, Function: onCloseButtonClick },
						{ Widget: leftButt, Function: onLeftButtonClick },
						{ Widget: help, Function: onHelp },
						{ Widget: rightButt, Function: onRightButtonClick }
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
			}
		}
		
		protected function init() : void
		{
			if (_mainTab != null)
				stickers.removeChild(_mainTab);
			
			_mainTab = new BaseTab(InventoryWindow.ScreenDim[0], InventoryWindow.ScreenDim[1]);
			
			stickers.addChild(_mainTab);
			
			var mapSticker : Object = new Object();
			var mapNum : Object = new Object();
			
			var inv : Vector.<StoreObject> = storeController.inventory;
			
			var id : String;
			var newItem : InventoryItem;
			
			for each (var storeObj : StoreObject in inv)
			{
				id = storeObj.storeObject.object.objectId.id;
				
				if (storeObj.storeObject is WorkerStoreObjectData)
					id += (storeObj.storeObject as WorkerStoreObjectData).currSkill.id;
				
				if (mapNum[id] == null)
				{
					mapNum[id] = 1;
					
					newItem = new InventoryItem();
					
					newItem.storeObject = storeObj;
					newItem.num = 1;
					
					_mainTab.addItem(newItem);
					
					mapSticker[id] = newItem;
				}
				else
				{
					mapNum[id]++;
					mapSticker[id].num++;
				}
			}
			
			checkLeftRight();
		}
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
			{
				init();
				
				GuiManager.instance.windowOpened(this);
			}
			else
				GuiManager.instance.windowClosed(this);
		}
		
		private static var _instance : InventoryWindow;
		
		protected function checkLeftRight() : void
		{
			if (_mainTab.canLeft)
				leftButt.gotoAndStop(1);
			else
				leftButt.gotoAndStop(3);
			
			if (_mainTab.canRight)
				rightButt.gotoAndStop(1);
			else
				rightButt.gotoAndStop(3);
		}
		
		public static function hide() : void
		{
			_instance.visible = false;
		}
		
		public static function reinit() : void
		{
			_instance.init();
		}
		
		protected function onHelp(e : MouseEvent) : void
		{
			HelpManager.instance.showHelpCase(HelpCaseType.Inventory);
		}
		
		protected function onLeftButtonClick(e : MouseEvent) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoLeft();
			
			checkLeftRight();
		}
		
		protected function onRightButtonClick(e : MouseEvent) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			_mainTab.gotoRight();
			
			checkLeftRight();
		}
		
		protected function onCloseButtonClick(e : MouseEvent) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			visible = !visible;
		}
		
		protected function onMouseEvent(e : MouseEvent) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			if (mc == leftButt && !_mainTab.canLeft)
				return;
			
			if (mc == rightButt && !_mainTab.canRight)
				return;
			
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
		
		protected const _closeButt : String = "Close";
		protected const _applyButt : String = "ApplyButton";
		protected const _chooseButt : String = "ChooseButton";		
		protected const _leftButt : String = "LeftButton";		
		protected const _rightButt: String = "RightButton";
		protected const _titleField : String = "Title";
		protected const _stickers : String = "Stickers";
		protected const _backButt : String = "BackButton";
		
		protected const _help : String = "Help";
		
		protected function get help() :  MovieClip
		{
			return _skin[_help];
		}
		
		protected function get chooseButt() : MovieClip
		{
			return _skin[_chooseButt] as MovieClip;
		}		
		
		protected function get backButt() : MovieClip
		{
			return _skin[_backButt] as MovieClip;
		}
		
		protected function get stickers() : MovieClip
		{
			return _skin[_stickers] as MovieClip;
		}
		
		protected function get storeController() : StoreController
		{
			return ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
		
		protected function get applyButt() : MovieClip
		{
			return _skin[_applyButt] as MovieClip;
		}
		
		protected function get leftButt() : MovieClip
		{
			return _skin[_leftButt] as MovieClip;
		}
		
		protected function get rightButt() : MovieClip
		{
			return _skin[_rightButt] as MovieClip;
		}
		
		protected function get titleTextField() : TextField
		{
			return _skin[_titleField] as TextField;
		}
	}
}