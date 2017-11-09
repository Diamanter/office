package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.controller.wallet.objects.WalletObject;
	import com.sigma.socialgame.events.controller.MapControllerEvent;
	import com.sigma.socialgame.events.controller.WalletControllerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.param.MusicState;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.model.param.QualityState;
	import com.sigma.socialgame.model.param.SoundState;
	import com.sigma.socialgame.sound.SoundManager;
	import com.sigma.socialgame.view.game.WorkerLimit;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.BitmapFont;
	import starling.core.Starling;
	import starling.animation.Juggler;
	import starling.textures.Texture;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.extensions.Scale9Image;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.StageDisplayState;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.*;
	import flash.net.*;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.FullScreenEvent;
	
	public class InfoBar extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _optionsOpened : Boolean = false;
		private var fontN:BitmapFont = starling.text.TextField.getBitmapFont("imp");
		private var fontN2:BitmapFont = starling.text.TextField.getBitmapFont("imp2");
		private var font:BitmapFont = starling.text.TextField.getBitmapFont("ver");
		private var font2:BitmapFont = starling.text.TextField.getBitmapFont("ver2");
        private var mState:String;
        private var personalCount:Sprite;
		private var image:Image;
		private var texture:Texture;
		private var goldTF:Sprite;
		private var coinsTF:Sprite;
		private var levelTF:Sprite;
		private var experienceTF:Sprite;
		private var toolTipPlace:Sprite;
		private var options:Sprite;
		private var soundButton:starling.display.Button;
		private var soundButtonOff:starling.display.Button;
		private var musicButton:starling.display.Button;
		private var musicButtonOff:starling.display.Button;
		private var zoomInButton:starling.display.Button;
		private var zoomOutButton:starling.display.Button;
		private var qualityButton:starling.display.Button;
		private var fullscreenButt:starling.display.Button;
		private var fullscreenButtOff:starling.display.Button;
		private var experienceBar:Scale9Image;
		private var experienceBarBack:Image;
		private var transferButton:starling.display.Button;
		private var paymentButton:starling.display.Button;
		private var optionsButton:starling.display.Button;
		private var optionsButtonOpened:starling.display.Button;
		
		public function InfoBar()
		{
			super();
			
			var bg:Scale9Image = new Scale9Image(SkinManager.instance.getSkinTexture("infoBarBack"), new Rectangle(10, 10, 30, 24));
			bg.x = -3;
			bg.width = 813;
			bg.touchable = false;
			addChild(bg);
			
			experienceBarBack = new Image(SkinManager.instance.getSkinTexture("infoBarExpBack"));
			experienceBarBack.x = 100;
			experienceBarBack.y = 13;
			experienceBarBack.touchable = false;
			addChild(experienceBarBack);
			
			experienceBar = new Scale9Image(SkinManager.instance.getSkinTexture("infoBarExp"), new Rectangle(10, 10, 132, 10));
			experienceBar.x = 100;
			experienceBar.y = 13;
			experienceBar.touchable = false;
			addChild(experienceBar);
			
			var bg2:Image = new Image(SkinManager.instance.getSkinTexture("shopItemBg"));
			bg2.x = 7;
			bg2.y = 7;
			bg2.touchable = false;
			addChild(bg2);
			
			var star:Image = new Image(SkinManager.instance.getSkinTexture("iconStar"));
			star.x = 84;
			star.y = 0;
			star.touchable = false;
			addChild(star);
			
			var coins:Image = new Image(SkinManager.instance.getSkinTexture("iconCoins"));
			coins.x = 269;
			coins.y = 7;
			coins.touchable = false;
			addChild(coins);
			
			var gold:Image = new Image(SkinManager.instance.getSkinTexture("iconGold"));
			gold.x = 395;
			gold.y = 7;
			gold.touchable = false;
			addChild(gold);
			
			var people:Image = new Image(SkinManager.instance.getSkinTexture("iconPeople"));
			people.x = 521;
			people.y = 7;
			people.touchable = false;
			addChild(people);
			
			transferButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarExchange0001"), "", SkinManager.instance.getSkinTexture("infoBarExchange0002"));
			transferButton.x = 642;
			transferButton.y = 5;
			transferButton.addEventListener(Event.TRIGGERED, onTranferMouseEvent);
			addChild(transferButton);
			
			paymentButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarPlusGold0001"), "", SkinManager.instance.getSkinTexture("infoBarPlusGold0002"));
			paymentButton.x = 705;
			paymentButton.y = 5;
			paymentButton.addEventListener(Event.TRIGGERED, onPaymentMouseEvent);
			addChild(paymentButton);
			
			optionsButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarSettings"), "", SkinManager.instance.getSkinTexture("infoBarSettings2"));
			optionsButton.x = 764;
			optionsButton.y = 8;
			optionsButton.addEventListener(Event.TRIGGERED, onOptionsMouseEvent);
			addChild(optionsButton);
			
			optionsButtonOpened = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarSettings2"), "", SkinManager.instance.getSkinTexture("infoBarSettings"));
			optionsButtonOpened.x = optionsButton.x;
			optionsButtonOpened.y = optionsButton.y;
			optionsButtonOpened.addEventListener(Event.TRIGGERED, onOptionsMouseEvent);
			optionsButtonOpened.visible = false;
			addChild(optionsButtonOpened);
			
			options = new Sprite();
			options.x = optionsButton.x;
			options.y = optionsButton.y;
			options.visible = false;
			addChild(options);
			
			zoomInButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarZoomIn0001"), "", SkinManager.instance.getSkinTexture("infoBarZoomIn0002"));
			zoomInButton.x = 0;
			zoomInButton.y = 48;
			zoomInButton.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(zoomInButton);
			
			zoomOutButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarZoomOut0001"), "", SkinManager.instance.getSkinTexture("infoBarZoomOut0002"));
			zoomOutButton.x = 0;
			zoomOutButton.y = 88;
			zoomOutButton.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(zoomOutButton);
			
			musicButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarMusic0001"), "", SkinManager.instance.getSkinTexture("infoBarMusic0002"));
			musicButton.x = 0;
			musicButton.y = 128;
			musicButton.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(musicButton);
			
			musicButtonOff = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarMusic0003"), "", SkinManager.instance.getSkinTexture("infoBarMusic0004"));
			musicButtonOff.x = 0;
			musicButtonOff.y = 128;
			musicButtonOff.visible = false;
			musicButtonOff.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(musicButtonOff);
			
			soundButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarSound0001"), "", SkinManager.instance.getSkinTexture("infoBarSound0002"));
			soundButton.x = 0;
			soundButton.y = 168;
			soundButton.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(soundButton);
			
			soundButtonOff = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarSound0003"), "", SkinManager.instance.getSkinTexture("infoBarSound0004"));
			soundButtonOff.x = 0;
			soundButtonOff.y = 168;
			soundButtonOff.visible = false;
			soundButtonOff.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(soundButtonOff);
			
			qualityButton = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarQuality0001"), "", SkinManager.instance.getSkinTexture("infoBarQuality0002"));
			qualityButton.x = 0;
			qualityButton.y = 208;
			qualityButton.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(qualityButton);
			
			fullscreenButt = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarFullScreen0001"), "", SkinManager.instance.getSkinTexture("infoBarFullScreen0002"));
			fullscreenButt.x = 0;
			fullscreenButt.y = 248;
			fullscreenButt.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(fullscreenButt);
			
			fullscreenButtOff = new starling.display.Button(SkinManager.instance.getSkinTexture("infoBarFullScreen0003"), "", SkinManager.instance.getSkinTexture("infoBarFullScreen0004"));
			fullscreenButtOff.x = 0;
			fullscreenButtOff.y = 248;
			fullscreenButtOff.visible = false;
			fullscreenButtOff.addEventListener(Event.TRIGGERED, onOptionButtonMouseEvent);
			options.addChild(fullscreenButtOff);
			
			
			applyAmount();
			applyLevel();
			
			loadAvatar();
			
			Starling.current.nativeStage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			walletController.addEventListener(WalletControllerEvent.AmountChanged, onAmountChanged);
			walletController.addEventListener(WalletControllerEvent.LevelChanged, onLevelChanged);
			
			/*var clazz : Class = SkinManager.instance.getSkin(GuiIds.InfoBar);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				walletController.addEventListener(WalletControllerEvent.AmountChanged, onAmountChanged);
				walletController.addEventListener(WalletControllerEvent.LevelChanged, onLevelChanged);
				
				paymentButt.gotoAndStop(1);
				
				paymentButt.addEventListener(MouseEvent.MOUSE_OVER, onPaymentMouseEvent);
				paymentButt.addEventListener(MouseEvent.MOUSE_OUT, onPaymentMouseEvent);
				paymentButt.addEventListener(MouseEvent.CLICK, onPaymentMouseEvent);
				
				tranferButton.gotoAndStop(1);
				
				tranferButton.addEventListener(MouseEvent.MOUSE_OVER, onTranferMouseEvent);
				tranferButton.addEventListener(MouseEvent.MOUSE_OUT, onTranferMouseEvent);
				tranferButton.addEventListener(MouseEvent.CLICK, onTranferMouseEvent);
				
				applyAmount();
				applyLevel();
				
				loadAvatar();
				
				options.gotoAndStop(1);
				
				options.addEventListener(MouseEvent.CLICK, onOptionsMouseEvent);
				options.addEventListener(MouseEvent.MOUSE_OVER, onOptionsMouseEvent);
				options.addEventListener(MouseEvent.MOUSE_OUT, onOptionsMouseEvent);

				mapController.addEventListener(MapControllerEvent.CellObjectAdded, onMapObjectAdded);
				mapController.addEventListener(MapControllerEvent.CellObjectRemoved, onMapObjectRemoved);
				
//				experienceTF.visible = false;
				
//				experienceBar.addEventListener(MouseEvent.MOUSE_OVER, onExperienceBarMouseEvent);
//				experienceBar.addEventListener(MouseEvent.MOUSE_OUT, onExperienceBarMouseEvent);
				experienceBarBack.addEventListener(MouseEvent.MOUSE_OVER, onExperienceBarMouseEvent);
				experienceBarBack.addEventListener(MouseEvent.MOUSE_OUT, onExperienceBarMouseEvent);
//				this.addEventListener(Event.ENTER_FRAME, onExperienceBarEvent);
			}*/
		}
		
		private function onFullScreen (e:Object) : void
		{
			fullscreenButt.visible = Starling.current.nativeStage.displayState == StageDisplayState.NORMAL;
			fullscreenButtOff.visible = !fullscreenButt.visible;
		}
		
		protected function onMapObjectAdded(e : MapControllerEvent) : void
		{
			updateCount();
		}
		
		protected function onMapObjectRemoved(e : MapControllerEvent) : void
		{
			updateCount();
		}
			
		protected function updateCount() : void
		{
			if (!ResourceManager.instance.myOffice)
				return;
			
			var currWorker : int = mapController.howManyWorkers();
			var text:String = String(currWorker) + "/" + String(WorkerLimit.instance.limit(walletController.currLevel.rank));
			if (personalCount) {
				personalCount.removeChildren(0, -1, true);
				personalCount.removeFromParent(true);
			}
			personalCount = fontN.createSprite(82, 30, text, 22, 0xFFFFFF, "left", "top");
			personalCount.x = 560;
			personalCount.y = 16;
			personalCount.touchable = false;
			addChild(personalCount);
		}
		
		protected function onTranferMouseEvent(e : Object) : void
		{
					
					GuiManager.instance.transferWindow.visible = !GuiManager.instance.transferWindow.visible;
		}
		
		protected function onPaymentMouseEvent(e : Object) : void
		{
					
//					SocialNetwork.instance.publish("Do you want to PublishString?", "PublishString");
					
					GuiManager.instance.buyOkWindow.visible = !GuiManager.instance.buyOkWindow.visible;
					
//					SocialNetwork.instance.publish("Вы выполнили квест!", "Я выполнил квест");
		}
		
		private var loader : Loader;
		
		protected function loadAvatar() : void
		{
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderFail);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderFail);
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPic);
			
			if (fCon.me.socFriend.pic != null)
				loader.load(new URLRequest(fCon.me.socFriend.pic));
		}
		
		protected function onLoaderFail(e : Event) : void
		{
			trace(e);
		}
		
		private function onLoadPic(event:Object):void {
			var data:BitmapData = (event.target.content as Bitmap).bitmapData;
			if (texture) texture.dispose();
			texture = Texture.fromBitmapData(data, false);
			onLoaderComplete();
		}
		
		protected function onLoaderComplete() : void
		{
			image = new Image(texture);
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			var wsc : Number = image.width / 80;
			var hsc : Number = image.height / 120;
			
			var resK : Number = wsc > hsc ? wsc : hsc;
			
			if (wsc > 1.0 || hsc > 1.0)
			{
				resK = 1 / resK;
			}
			
			image.scaleX = resK;
			image.scaleY = resK;
			
			image.x = 7 + 125/2;
			image.y = 7 + 137/2;
			
			addChildAt(image, 4);
		}
		
		/*protected function onExperienceBarEvent(e : Event) : void
		{
			if (e.type != Event.ENTER_FRAME) return;
			
			if (experienceBarBack.hitTestPoint(mouseX, mouseY))
			{
				var nextLevelExp : int = walletController.nextLevelExperience;
				var currentExp : int = walletController.getAmount(CurrencyType.Experience).amountData.amount;
				
				var text : String = (nextLevelExp != -1) ? (nextLevelExp - currentExp).toString() + " ед. опыта" : "максимальный уровень";
				
				GuiManager.instance.showToolTip(toolTipPlace.x, toolTipPlace.y, text);
			}
			else
			{
				GuiManager.instance.hideToolTip();
			}
		}*/
		
		/*protected function onExperienceBarMouseEvent(e : Event) : void
		{
			if (e.type == MouseEvent.MOUSE_OVER)
			{
				var nextLevelExp : int = walletController.nextLevelExperience;
				var currentExp : int = walletController.getAmount(CurrencyType.Experience).amountData.amount;
				
				var text : String = (nextLevelExp != -1) ? (nextLevelExp - currentExp).toString() + " ед. опыта" : "максимальный уровень";
				
				GuiManager.instance.showToolTip(toolTipPlace.x, toolTipPlace.y, text);
			}
			else
			{
				GuiManager.instance.hideToolTip();
			}
		}*/
		
		protected function takeScreenshot() : void
		{
			/*var newBMD : BitmapData = new BitmapData(Map.instance.screenShotDim.x, Map.instance.screenShotDim.y);
			
			var matr : Matrix = new Matrix(1, 0, 0, 1, Map.instance.screenShotBias.x, Map.instance.screenShotBias.y);
			
			Map.instance.iWantScreenShot();
			//newBMD.draw(Map.instance.screenShot, matr);
			Map.instance.iDontWantScreenShot();
			
			var newBM : Bitmap = new Bitmap(newBMD);
			stage.addChild(newBM);
			
			newBM.scaleX = 0.3;
			newBM.scaleY = 0.3;
			
			newBM.x = 100;
			newBM.y = 100;*/
		}
		
		private var qualities:Array = [0,2,16];
		protected function onOptionButtonMouseEvent(e : Object) : void
		{
			e.stopImmediatePropagation();
			
			switch (e.currentTarget)
			{
				case qualityButton:
					
					var qIndex:int = qualities.indexOf(Starling.current.antiAliasing);
					Starling.current.antiAliasing = qualities[(qIndex+1)%qualities.length];
					Logger.message("Change quality", "InfoBar", LogLevel.Info, LogModule.View);
					trace("Quality", Starling.current.antiAliasing);
					break;
				
				case fullscreenButt:
				case fullscreenButtOff:
					
					if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL)
						Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN;
					else
						Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
					
					break;
				
				case zoomInButton:
					Map.instance.zoomIn();
					break;
				
				case zoomOutButton:
					Map.instance.zoomOut();
					break;
				
				case soundButton:
				case soundButtonOff:
					
					if (SoundManager.instance.soundOn)
					{
						sound = false;
					}
					else
					{
						sound = true;
					}
					
					break;
				
				case musicButton:
				case musicButtonOff:

					if (SoundManager.instance.musicOn)
					{
						music = false;
					}
					else
					{
						music = true;
					}
					
					break;
			}
		}
		
		protected function set quality(on_ : Boolean) : void
		{
			/*if (on_)
			{
				stage.quality = StageQuality.BEST;
				qualityButton.gotoAndStop(1);
				ResourceManager.instance.sendParam(ParamType.QualityState, QualityState.High);
			}
			else
			{
				stage.quality = StageQuality.MEDIUM;
				qualityButton.gotoAndStop(2);
				ResourceManager.instance.sendParam(ParamType.QualityState, QualityState.Low);
			}*/
		}
		
		protected function set music(on_ : Boolean) : void
		{
			if (on_)
			{
				SoundManager.instance.musicOn = true;
				musicButton.visible = true;
				musicButtonOff.visible = false;
				ResourceManager.instance.sendParam(ParamType.MusicState, MusicState.On);
			}
			else
			{
				SoundManager.instance.musicOn = false;
				musicButton.visible = false;
				musicButtonOff.visible = true;
				ResourceManager.instance.sendParam(ParamType.MusicState, MusicState.Off);
			}
		}
		
		protected function set sound(on_ : Boolean) : void
		{
			if (on_)
			{
				SoundManager.instance.soundOn = true;
				soundButton.visible = true;
				soundButtonOff.visible = false;
				ResourceManager.instance.sendParam(ParamType.SoundState, SoundState.On);
			}
			else
			{
				SoundManager.instance.soundOn = false;
				soundButton.visible = false;
				soundButtonOff.visible = true;
				ResourceManager.instance.sendParam(ParamType.SoundState, SoundState.Off);
			}
		}
		
		protected function onOptionButtonMouseOverEvent(e : Object) : void
		{
			e.stopImmediatePropagation();
			
			/*switch (e.currentTarget)
			{
				case zoomOutButton:
				case zoomInButton:
				case screenButton:
					
					switch (e.type)
					{
						case MouseEvent.MOUSE_OVER:
							e.currentTarget.gotoAndStop(2);
							break;
						
						case MouseEvent.MOUSE_OUT:
							e.currentTarget.gotoAndStop(1);
							break;
					}
					
					break;
				
				case soundButton:
					
					switch (e.type)
					{
						case MouseEvent.MOUSE_OVER:
							
							if (SoundManager.instance.soundOn)
								e.currentTarget.gotoAndStop(2);
							else
								e.currentTarget.gotoAndStop(4);
								
							break;
						
						case MouseEvent.MOUSE_OUT:
							
							if (SoundManager.instance.soundOn)
								e.currentTarget.gotoAndStop(1);
							else
								e.currentTarget.gotoAndStop(3);
							
							break;
					}
					
					break;
				
				case musicButton:
					
					switch (e.type)
					{
						case MouseEvent.MOUSE_OVER:
							
							if (SoundManager.instance.musicOn)
								e.currentTarget.gotoAndStop(2);
							else
								e.currentTarget.gotoAndStop(4);
							
							break;
						
						case MouseEvent.MOUSE_OUT:

							if (SoundManager.instance.musicOn)
								e.currentTarget.gotoAndStop(1);
							else
								e.currentTarget.gotoAndStop(3);
							
							break;
					}
					
					break;
				
				case fullscreenButt:
					
					switch (e.type)
					{
						case MouseEvent.MOUSE_OVER:
							
							if (stage.displayState == StageDisplayState.NORMAL)
								e.currentTarget.gotoAndStop(2);
							else
								e.currentTarget.gotoAndStop(4);
							
							break;
						
						case MouseEvent.MOUSE_OUT:
							
							if (stage.displayState == StageDisplayState.NORMAL)
								e.currentTarget.gotoAndStop(1);
							else
								e.currentTarget.gotoAndStop(3);
							
							break;
					}
						
					break;
			}*/
		}
		
		protected function onOptionsMouseEvent(e : Object) : void
		{
			_optionsOpened = !_optionsOpened;
			options.visible = _optionsOpened;
			
					/*if (!_optionsOpened)
					{
						options.visible = true;
						
						var butt : Array = 
							[
//								screenButton,
								fullscreenButt,
								zoomInButton,
								zoomOutButton,
								musicButton,
								soundButton,
								qualityButton
							];
						
						for each (var button : MovieClip in butt)
						{
							button.addEventListener(MouseEvent.CLICK, onOptionButtonMouseEvent);
							
							button.addEventListener(MouseEvent.MOUSE_OVER, onOptionButtonMouseOverEvent);
							button.addEventListener(MouseEvent.MOUSE_OUT, onOptionButtonMouseOverEvent);
							
							button.gotoAndStop(1);
						}
						
						if (SoundManager.instance.musicOn)
							musicButton.gotoAndStop(1);
						else
							musicButton.gotoAndStop(3);
						
						if (SoundManager.instance.soundOn)
							soundButton.gotoAndStop(1);
						else
							soundButton.gotoAndStop(3);
						
						if (stage.quality == "BEST")
							qualityButton.gotoAndStop(1);
						else
							qualityButton.gotoAndStop(2);
						
						if (stage.displayState == StageDisplayState.NORMAL)
							fullscreenButt.gotoAndStop(1);
						else
							fullscreenButt.gotoAndStop(3);
						
						_optionsOpened = true;
					}
					else
					{
						options.gotoAndStop(1);
						
						_optionsOpened = false;
					}*/
					
		}
		
		protected function applyAmount() : void
		{
			var text:String;
			for each (var wallet : WalletObject in walletController.wallet)
			{
				switch (wallet.amountData.currency.type)
				{
					case CurrencyType.Coin:
						text = String(wallet.amountData.amount);
						if (coinsTF) {
							coinsTF.removeChildren(0, -1, true);
							coinsTF.removeFromParent(true);
						}
						coinsTF = fontN.createSprite(82, 30, text, 22, 0xFFFFFF, "left", "top");
						coinsTF.x = 329;
						coinsTF.y = 16;
						coinsTF.touchable = false;
						addChild(coinsTF);
						break;
					
					case CurrencyType.Gold:
						text = String(wallet.amountData.amount);
						if (goldTF) {
							goldTF.removeChildren(0, -1, true);
							goldTF.removeFromParent(true);
						}
						goldTF = fontN.createSprite(82, 30, text, 22, 0xFFFFFF, "left", "top");
						goldTF.x = 443;
						goldTF.y = 16;
						goldTF.touchable = false;
						addChild(goldTF);
						break;
					
					case CurrencyType.Experience:
						applyExperience(wallet);
						break;
				}
			}
		}
		
		protected function applyExperience(wallet : WalletObject) : void
		{
			var text:String = String(wallet.amountData.amount);
			if (experienceTF) {
				experienceTF.removeChildren(0, -1, true);
				experienceTF.removeFromParent(true);
			}
			experienceTF = fontN.createSprite(82, 30, text, 18, 0xFFFFFF, "center", "center");
			experienceTF.x = 155;
			experienceTF.y = 14;
			experienceTF.touchable = false;
			addChild(experienceTF);
			
			var nextLevelExp : int = walletController.nextLevelExperience;
			var currLevelExp : int = walletController.currentLevelExperience;
			
			if ((nextLevelExp == -1) || (currLevelExp == -1))
			{
				experienceBar.width = experienceBarBack.width;
			}
			else
			{
				experienceBar.width = experienceBarBack.width*((Number)(wallet.amountData.amount) - currLevelExp) / (nextLevelExp - currLevelExp);
			}
			
		}
					
		protected function applyLevel() : void
		{
			if (walletController.currLevel == null) return;
			
			var text:String = String(walletController.currLevel.rank);
			if (levelTF) {
				levelTF.removeChildren(0, -1, true);
				levelTF.removeFromParent(true);
			}
			levelTF = fontN.createSprite(33, 33, text, 22, 0xFF6600, "center", "top");
			levelTF.x = 98;
			levelTF.y = 22;
			levelTF.rotation = -6.8*Math.PI/180;
			levelTF.touchable = false;
			addChild(levelTF);

			updateCount();
			
			for each (var wallet : WalletObject in walletController.wallet)
			{
				if (wallet.amountData.currency.type == CurrencyType.Experience)
				{
					applyExperience(wallet);
				}
			}
		}
				
		protected function onLevelChanged(e : WalletControllerEvent) : void
		{
			applyLevel();

			updateCount();
			
			var stringCase : StringCase = StringManager.instance.getCase(StringTypes.LevelUp);
			
			GuiManager.instance.showAlert(stringCase.title, stringCase.message);
		}
		
		protected function onAmountChanged(e : WalletControllerEvent) : void
		{
			applyAmount();
		}
		
		protected function get walletController() : WalletController
		{
			return ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
		}
		
		protected function get mapController() : MapController
		{
			return ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
		}
		
		/*private const _experience : String = "experience";
		private const _coins : String = "coins";
		private const _gold : String = "gold";
		private const _level : String = "level";
		
		private const _owner : String = "Owner";
		private const _image : String = "image";
		
		private const _paymenButton : String = "paymentButton";
		private const _tranferButton : String = "Transfer";
		
		private const _experienceBar : String = "exp_bar";
		private const _experienceBarBack : String = "exp_bar_back";
		private const _toolTipPlace : String = "RegPoint";
		
		private const _screenButton : String = "ButtonScreen";
		private const _zoomInButton : String = "ButtonZoomIn";
		private const _zoomOutButton : String = "ButtonZoomOut";
		private const _musicButton : String = "ButtonMusic";
		private const _soundButton : String = "ButtonSound";
		private const _fullscreenButton : String = "ButtonFullScreen";
		private const _quality : String = "ButtonQuality";*/
		
		private const _personalCount : String = "PersonalCount";
		
		private const _options : String = "Options";
		
		/*protected function get personalCount() : TextField
		{
			return _skin[_personalCount];
		}
		
		protected function get tranferButton() : MovieClip
		{
			return _skin[_tranferButton];
		}
		
		protected function get qualityButton() : MovieClip
		{
			return options[_quality];
		}
		
		protected function get fullscreenButt() : MovieClip
		{
			return options[_fullscreenButton];
		}
		
		protected function get paymentButt() : MovieClip
		{
			return _skin[_paymenButton];
		}
		
		protected function get owner() : MovieClip
		{
			return _skin[_owner];
		}
		
		protected function get image() : MovieClip
		{
			return owner[_image];
		}
		
		protected function get screenButton() : MovieClip
		{
			return options[_screenButton];
		}
		
		protected function get zoomInButton() : MovieClip
		{
			return options[_zoomInButton];
		}
		
		protected function get zoomOutButton() : MovieClip
		{
			return options[_zoomOutButton];
		}
		
		protected function get musicButton() : MovieClip
		{
			return options[_musicButton];
		}
		
		protected function get soundButton() : MovieClip
		{
			return options[_soundButton];
		}
		
		protected function get experienceBar() : MovieClip
		{
			return _skin[_experienceBar] as MovieClip;
		}		
		
		protected function get experienceBarBack() : MovieClip
		{
			return _skin[_experienceBarBack] as MovieClip;
		}
		
		protected function get toolTipPlace() : MovieClip
		{
			return _skin[_toolTipPlace] as MovieClip;
		}
		
		protected function get options() : MovieClip
		{
			return _skin[_options] as MovieClip;
		}
		
		protected function get levelTF() : TextField
		{
			return _skin[_level] as TextField;
		}
		
		protected function get experienceTF() : TextField
		{
			return _skin[_experience] as TextField;
		}
		
		protected function get coinsTF() : TextField
		{
			return _skin[_coins] as TextField;
		}
		
		protected function get goldTF() : TextField
		{
			return _skin[_gold] as TextField;
		}*/
	}
}