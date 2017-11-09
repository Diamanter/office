package com.sigma.socialgame.view.gui.components.customize
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.avatar.AvatarController;
	import com.sigma.socialgame.controller.avatar.objects.AvatarPartObject;
	import com.sigma.socialgame.events.controller.AvatarControllerEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.events.view.gui.CustomizeWindowEvent;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPartType;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarSex;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.sound.SoundEvents;
	import com.sigma.socialgame.sound.SoundManager;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatarState;
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
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	public class CustomizeWindow extends Sprite
	{
		public static var ScreenDim : Array;
		
		private var _skin : MovieClip;
		
		private var _tabsButtMap : Dictionary;
		
		private var _tabsMap : Object;
		
		private var _currTab : BaseTab;
		private var _currTabButt : MovieClip;
		private var _avatar : PlayerAvatar;
		
		private var _currSex : String = AvatarSex.Male;
		
		private static var _instance : CustomizeWindow; 
		
		public function CustomizeWindow()
		{
			super();
			
			_instance = this;
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.CustomizeWindow);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				ScreenDim = [GuiPlaces.CustomizeWindowPlace.dim.x, GuiPlaces.CustomizeWindowPlace.dim.y];
				
				var buttons : Array = 
				[
					closeButt, applyButt, listRightButt, help, manButt, womanButt, listLeftButt, hairButt,
					eyeButt, bodyButt, legsButt, bootsButt								
				];

				var functions : Array =
				[
					onCloseMouseEvent, onApplyMouseEvent, onArrowMouseEvent, onHelp, onSexChanged, onSexChanged, onArrowMouseEvent, onTabMouseEvent,
					onTabMouseEvent, onTabMouseEvent, onTabMouseEvent, onTabMouseEvent
				];
				
				addChild(_skin);
				
				var length : int = buttons.length;
				
				for(var i : int; i < length; ++i)
				{
					if (i < 7)
						buttons[i].gotoAndStop(1);
					else
						buttons[i].gotoAndStop(2);
					
					if (functions[i] != null)
					{
						buttons[i].addEventListener(MouseEvent.CLICK, functions[i]);
					}
					
					if (i < 7)
					{
						buttons[i].addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
						buttons[i].addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
					}
				}
				
				init();
				
				previewMC.scaleX = 1.5;
				previewMC.scaleY = 1.5;
				
				avatarController.addEventListener(AvatarControllerEvent.FitPartChanged, onPartChanged);
				avatarController.addEventListener(AvatarControllerEvent.AmountChanged, onAmountChanged);
				
				costCoinsText.text = "0";
				costGoldText.text = "0";
			}
		}
		
		protected function onHelp(e : MouseEvent) : void
		{
			HelpManager.instance.showHelpCase(HelpCaseType.CustomizeHelp);
		}
		
		protected function onAmountChanged(e : AvatarControllerEvent) : void
		{
			costCoinsText.text = "0";
			costGoldText.text = "0";
			
			for each (var amount : AmountData in avatarController.currAmounts)
			{
				switch (amount.currency.type)
				{
					case CurrencyType.Coin:
						costCoinsText.text = String(amount.amount);
						break;
					
					case CurrencyType.Gold:
						costGoldText.text = String(amount.amount);
						break;
				}
			}
			
			if (!avatarController.canBuy())
				lockBuy();
			else
				unlockBuy();
		}
		
		protected function lockBuy() : void
		{
			applyButt.removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			applyButt.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			
			applyButt.removeEventListener(MouseEvent.CLICK, onApplyMouseEvent);
				
			applyButt.gotoAndStop(3);
		}
		
		protected function unlockBuy() : void
		{
			applyButt.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			applyButt.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			
			applyButt.addEventListener(MouseEvent.CLICK, onApplyMouseEvent);
	
			applyButt.gotoAndStop(1);
//			applyButt.filters = null;
		}
		
		protected function onPartChanged(e : AvatarControllerEvent) : void
		{
			_avatar.graphicLoader.reloadParts();
		}
		
		protected function onAvatarLoaded(e : GraphicLoaderEvent) : void
		{
			//previewMC.addChild(_avatar.graphicLoader);
			_avatar.dir = MapRotation.SouthWest;
			_avatar.state = PlayerAvatarState.Standing;
		}
		
		protected function changeSex(sex : String) : void
		{
			var types : Array = [AvatarPartType.Body,
				AvatarPartType.Boots,
				AvatarPartType.Eyes,
				AvatarPartType.Hair,
				AvatarPartType.Legs
			];
			
			var type : String;
			var newCWEvent : CustomizeWindowEvent;
			
			switch (sex)
			{
				case AvatarSex.Male:
					
					if (_currSex != AvatarSex.Male)
					{
						_currSex = AvatarSex.Male;
						
						for each (type in types)
						{
							_tabsMap[AvatarSex.Female][type].visible = false;
						}
						
						_currTab = _tabsMap[_currSex][_tabsButtMap[_currTabButt]];
						_currTab.visible = true;
						
						newCWEvent = new CustomizeWindowEvent(CustomizeWindowEvent.SetSex);
						newCWEvent.sex = _currSex;
						dispatchEvent(newCWEvent);
					}
					
					break;
				
				case AvatarSex.Female:

					if (_currSex != AvatarSex.Female)
					{
						_currSex = AvatarSex.Female;
						
						for each (type in types)
						{
							_tabsMap[AvatarSex.Male][type].visible = false;
						}
						
						_currTab = _tabsMap[_currSex][_tabsButtMap[_currTabButt]];
						_currTab.visible = true;
						
						newCWEvent = new CustomizeWindowEvent(CustomizeWindowEvent.SetSex);
						newCWEvent.sex = _currSex;
						dispatchEvent(newCWEvent);
					}
					
					break;
			}
		}
		
		protected function onSexChanged(e : MouseEvent) : void
		{
			switch (e.currentTarget)
			{
				case manButt:

					changeSex(AvatarSex.Male);
					
					break;
				
				case womanButt:

					changeSex(AvatarSex.Female);
					
					break;
			}
			
			checkRightLeft();
		}
		
		protected function init() : void
		{
			_tabsButtMap = new Dictionary();
			
			_tabsButtMap[bodyButt] = AvatarPartType.Body;
			_tabsButtMap[bootsButt] = AvatarPartType.Boots;
			_tabsButtMap[eyeButt] = AvatarPartType.Eyes;
			_tabsButtMap[hairButt] = AvatarPartType.Hair;
			_tabsButtMap[legsButt] = AvatarPartType.Legs;
			
			_tabsMap = new Object();
			
			var types : Array = [AvatarPartType.Body,
								 AvatarPartType.Boots,
								 AvatarPartType.Eyes,
								 AvatarPartType.Hair,
								 AvatarPartType.Legs
								];
			
			var sexes : Array = [AvatarSex.Male, AvatarSex.Female];
			
			for each (var sex : String in sexes)
			{
				_tabsMap[sex] = new Object();
				
				for each (var type : String in types)
				{
					_tabsMap[sex][type] = new BaseTab(CustomizeWindow.ScreenDim[0], CustomizeWindow.ScreenDim[1]);
					
					stickers.addChild(_tabsMap[sex][type]);
					
					_tabsMap[sex][type].visible = false;
				}
			}
			
			var aCon : AvatarController = ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			var newItem : CustomizeItem;
			
			_currSex = aCon.currParts[0].part.sex; 
				
			_currTab = _tabsMap[_currSex][AvatarPartType.Hair];
			_currTab.visible = true;
			
			_currTabButt = hairButt;
			_currTabButt.gotoAndStop(1);
			
			for each (var part : AvatarPartObject in aCon.parts)
			{
				//todo newItem = new CustomizeItem();
				
				//newItem.client = aCon.getClient(part);
				
				//_tabsMap[part.part.sex][part.part.type].addItem(newItem);
			}
			
			_avatar = new PlayerAvatar();
			_avatar.graphicLoader.addEventListener(GraphicLoaderEvent.Loaded, onAvatarLoaded);
			_avatar.graphicLoader.load();
			
			checkRightLeft();
		}
		
		protected function checkRightLeft() : void
		{
			if (!_currTab.canLeft)
				listLeftButt.gotoAndStop(3);
			else
				listLeftButt.gotoAndStop(1);
			
			if (!_currTab.canRight)
				listRightButt.gotoAndStop(3);
			else
				listRightButt.gotoAndStop(1);
		}
		
		protected function onArrowMouseEvent(e : MouseEvent) : void
		{
			if (e.currentTarget == listLeftButt)
			{
				_currTab.gotoLeft();
			}
			else
			{
				_currTab.gotoRight();
				
			}
			
			checkRightLeft();
		}
		
		protected function onApplyMouseEvent(e : MouseEvent) : void
		{
			avatarController.applyFitting();
			SoundManager.instance.playEvent(SoundEvents.Buy);
			visible = false;
		}
		
		protected function onTabMouseEvent(e : MouseEvent) : void
		{
			_currTab.visible = false;
			_currTab = _tabsMap[_currSex][_tabsButtMap[e.currentTarget]]; 
			_currTab.visible = true;
			
			_currTabButt.gotoAndStop(2);
			_currTabButt = e.currentTarget as MovieClip;
			_currTabButt.gotoAndStop(1);
			
			checkRightLeft();
		}
		
		protected function onMouseEvent(e : MouseEvent) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			if (mc == null) return;
			
			if (mc == listLeftButt && !_currTab.canLeft)
				return;
			
			if (mc == listRightButt && !_currTab.canRight)
				return;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER: mc.gotoAndStop(2); break;
				case MouseEvent.MOUSE_OUT: mc.gotoAndStop(1); break;
			}
		}
		
		protected function onCloseMouseEvent(e : MouseEvent) : void
		{
			if (e.type != MouseEvent.CLICK) return;
			
			avatarController.cancelFitting();
			
			if (avatarController.currParts[0].part.sex != _currSex)
			{
				changeSex(avatarController.currParts[0].part.sex);
			}
			
			visible = !visible;
		}

		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			costCoinsText.text = "0";
			costGoldText.text = "0";
			
			if (visible)
			{
				avatarController.startFitting();
				_avatar.graphicLoader.reloadParts();
				
				_currSex = avatarController.currParts[0].part.sex;
				
				/*var types : Array = [AvatarPartType.Body,
					AvatarPartType.Boots,
					AvatarPartType.Eyes,
					AvatarPartType.Hair,
					AvatarPartType.Legs
				];
				
				var otherSex : String = (_currSex == AvatarSex.Male ? AvatarSex.Female : _currSex);
				
				for each (var type : String in types)
				{
					_tabsMap[otherSex][type].visible = false;
				}*/
				
				_currTab = _tabsMap[_currSex][_tabsButtMap[_currTabButt]];
				_currTab.visible = true;
				
				GuiManager.instance.windowOpened(this);
			}
			else
				GuiManager.instance.windowClosed(this);
		}
		
		private var _aCon : AvatarController;
		
		protected function get avatarController() : AvatarController
		{
			if (_aCon == null)
				_aCon = ControllerManager.instance.getController(ControllerNames.AvatarController) as AvatarController;
			
			return _aCon;
		}
		
		public static function get instance() : CustomizeWindow
		{
			return _instance;
		}
		
		protected const _closeButt : String = "Close";
		protected const _preview : String = "Preview";
		protected const _applyButt : String = "Apply_Button";
		
		protected const _hairButt : String = "Hair_Button";
		protected const _eyeButt : String = "Eye_Button";
		protected const _bodyButt : String = "Body_Button";
		protected const _legsButt : String = "Legs_Button";
		protected const _bootsButt : String = "Boots_Button";
		protected const _listRightButt : String = "Right_Button";
		protected const _listLeftButt : String = "Left_Button";
		protected const _costCoinsTextField : String = "Cost_s";
		protected const _costGoldTextField : String = "Cost_m";
		
		protected const _manButt : String = "Male_Button";
		protected const _womanButt : String = "Female_Button";
		
		protected const _help : String = "Help";
		
		protected const _stickers : String = "Stickers";
		
		protected function get manButt() : MovieClip
		{
			return _skin[_manButt];
		}
		
		protected function get womanButt() : MovieClip
		{
			return _skin[_womanButt];
		}
		
		protected function get help() : MovieClip
		{
			return _skin[_help];
		}
		
		protected function get stickers() : MovieClip
		{
			return _skin[_stickers] as MovieClip;
		}
		
		protected function get closeButt() : MovieClip
		{
			return _skin[_closeButt] as MovieClip;
		}
		
		protected function get previewMC() : MovieClip
		{
			return _skin[_preview] as MovieClip;
		}
		
		protected function get applyButt() : MovieClip
		{
			return _skin[_applyButt] as MovieClip;
		}
		
		protected function get hairButt() : MovieClip
		{
			return _skin[_hairButt] as MovieClip;
		}
		
		protected function get eyeButt() : MovieClip
		{
			return _skin[_eyeButt] as MovieClip;
		}
		
		protected function get bodyButt() : MovieClip
		{
			return _skin[_bodyButt] as MovieClip;
		}
		
		protected function get legsButt() : MovieClip
		{
			return _skin[_legsButt] as MovieClip;
		}
		
		protected function get bootsButt() : MovieClip
		{
			return _skin[_bootsButt] as MovieClip;
		}
		
		protected function get listRightButt() : MovieClip
		{
			return _skin[_listRightButt] as MovieClip;
		}								
		
		protected function get listLeftButt() : MovieClip
		{
			return _skin[_listLeftButt] as MovieClip;
		}
		
		protected function get costCoinsText() : TextField
		{
			return _skin[_costCoinsTextField] as TextField;
		}
		
		protected function get costGoldText() : TextField
		{
			return _skin[_costGoldTextField] as TextField;
		}		
	}
}