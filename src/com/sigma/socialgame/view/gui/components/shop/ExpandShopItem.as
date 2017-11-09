package com.sigma.socialgame.view.gui.components.shop
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.shop.clients.ExpandShopClient;
	import com.sigma.socialgame.events.controller.ExpandShopClientEvent;
	import com.sigma.socialgame.events.controller.MapControllerEvent;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
	import flash.geom.Rectangle;
    
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.text.BitmapFont;
	
	public class ExpandShopItem extends Sprite
	{
		private var _client : ExpandShopClient;
		
		private var _skin : MovieClip;
		
		private var _checked : Image;
		private var _locked : Image;
		
		//private var _graphicLoader : ShopGraphicLoader;
		private var bg:Image;
		private var bg2:Image;
		private var fontN:BitmapFont = starling.text.TextField.getBitmapFont("imp");
		private var fontN2:BitmapFont = starling.text.TextField.getBitmapFont("imp2");
		private var font:BitmapFont = starling.text.TextField.getBitmapFont("ver");
		private var font2:BitmapFont = starling.text.TextField.getBitmapFont("ver2");
		
		private var line02:Sprite;
		private var line0:Sprite;
		private var line12:Sprite;
		private var line1:Sprite;
		private var line22:Sprite;
		private var line2:Sprite;
		private var line32:Sprite;
		private var line3:Sprite;
		private var unlockTitle2:Sprite;
		private var unlockTitle:Sprite;
		private var unlockCost2:Sprite;
		private var unlockCost:Sprite;
		private var costTF2:Sprite;
		private var costTF:Sprite;
		private var itemNameTF2:Sprite;
		private var itemNameTF:Sprite;
		private var itemCountTF2:Sprite;
		private var itemCountTF:Sprite;
		private var sellItem:Button;
		private var unlockButton:Button;
		private var unlock:Sprite;
		private var coinsImage:Image;
		private var image:Image;
		private var corner:Image;
        private var mState:String;
        private var mTriggerBounds:Rectangle;
		
		public function ExpandShopItem()
		{
			super();
			
			bg = new Image(SkinManager.instance.getSkinTexture("shopItemBg"));
			bg.x = 18;
			bg.y = 14;
			addChild(bg);			
			
			bg2 = new Image(SkinManager.instance.getSkinTexture("shopItemBg2"));
			bg2.x = 38.5;
			bg2.y = 47;
			addChild(bg2);			
			
			image = new Image(SkinManager.instance.getSkinTexture("expandIcon"));
			image.x = 46;
			image.y = 56;
			addChild(image);		
	
			addEventListener(TouchEvent.TOUCH, onTouch);
			/*_graphicLoader = new ShopGraphicLoader(); 
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.ShopItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				clazz = SkinManager.instance.getSkin(GuiIds.Checked);
				
				if (clazz != null)
				{
					_checked = new clazz();
					
					_skin.addChild(_checked);
				}
				
				clazz = SkinManager.instance.getSkin(GuiIds.Locked);
				
				if (clazz != null)
				{
					_locked = new clazz();
					
					_skin.addChild(_locked);
				}

				image.addChild(_graphicLoader);
				
				itemNameTF.selectable = false;
				itemCountTF.selectable = false;
				
				itemCountTF.visible = false;
				sellItem.visible = false;
				
				sellItem.gotoAndStop(1);
				unlockButton.gotoAndStop(1);
				
				_skin.addEventListener(MouseEvent.CLICK, onMouseEvent);
				_skin.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				_skin.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				
				unlockButton.addEventListener(MouseEvent.MOUSE_OUT, onUnlockMouseEvent);
				unlockButton.addEventListener(MouseEvent.MOUSE_OVER, onUnlockMouseEvent);
				unlockButton.addEventListener(MouseEvent.CLICK, onUnlockMouseEvent);
				
				var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
				
				mCon.addEventListener(MapControllerEvent.DimenstionChanged, onDimChanged);
			}*/
		}

        private function onTouch(event:TouchEvent):void
        {
            Mouse.cursor = (event.interactsWith(this)) ?
                MouseCursor.BUTTON : MouseCursor.AUTO;
            
            var touch:Touch = event.getTouch(this);
            var isWithinBounds:Boolean;

            if (touch == null)
            {
                state = ButtonState.UP;
            }
            else if (touch.phase == TouchPhase.HOVER)
            {
                state = ButtonState.OVER;
            }
            else if (touch.phase == TouchPhase.BEGAN && mState != ButtonState.DOWN)
            {
                mTriggerBounds = getBounds(stage, mTriggerBounds);
                mTriggerBounds.inflate(8, 8);

                state = ButtonState.DOWN;
            }
            else if (touch.phase == TouchPhase.MOVED)
            {
                isWithinBounds = mTriggerBounds.contains(touch.globalX, touch.globalY);

                if (mState == ButtonState.DOWN && !isWithinBounds)
                {
                    // reset button when finger is moved too far away ...
                    state = ButtonState.UP;
                }
                else if (mState == ButtonState.UP && isWithinBounds)
                {
                    // ... and reactivate when the finger moves back into the bounds.
                    state = ButtonState.DOWN;
                }
            }
            else if (touch.phase == TouchPhase.ENDED && mState == ButtonState.DOWN)
            {
                state = ButtonState.UP;
                if (!touch.cancelled) dispatchEventWith(Event.TRIGGERED, true);
            }
        }
		
        public function get state():String { return mState; }
        public function set state(value:String):void
        {
            mState = value;
		}
		
		protected function onDimChanged(e : MapControllerEvent) : void
		{
			checkAvialableness();
		}
		
		public function get expClient():ExpandShopClient
		{
			return _client;
		}

		public function set expClient(value:ExpandShopClient):void
		{
			_client = value;
			
			//_graphicLoader.setImage(expClient.expand.expandObject.image);
			
			//_client.addEventListener(ExpandShopClientEvent.Unlocked, onUnlocked);

			//itemNameTF.text = "" + _client.expand.expandObject.width + "x" + _client.expand.expandObject.width; 
			
//			trace("expshopid", expClient.expand.expandObject.image, texture);
			
			_client.addEventListener(ExpandShopClientEvent.Unlocked, onUnlocked);

			var itemName:String = _client.expand.expandObject.width + "x" + _client.expand.expandObject.width;
			itemNameTF2 = font2.createSprite(116, 60, itemName, 20, 0xFFCC00, "center", "top");
			itemNameTF2.x = 23;
			itemNameTF2.y = 16;
			addChild(itemNameTF2);
			itemNameTF = font.createSprite(116, 60, itemName, 20, 0x000000, "center", "top");
			itemNameTF.x = 23;
			itemNameTF.y = 16;
			addChild(itemNameTF);
			
			costTF2 = fontN2.createSprite(70, 20, ""+_client.expand.expandObject.prices[0].amount, 18, 0xFFCC00, "left", "top");
			costTF2.x = 67;
			costTF2.y = 125;
			addChild(costTF2);
			costTF = fontN.createSprite(70, 20, ""+_client.expand.expandObject.prices[0].amount, 18, 0x000000, "left", "top");
			costTF.x = 67;
			costTF.y = 125;
			addChild(costTF);
			
			if (_client.expand.prices[0].currency.type == "gold")
			{
				coinsImage = new Image(SkinManager.instance.getSkinTexture("shopItemGold"));
			}
			else if (_client.expand.prices[0].currency.type == "coins")
			{
				coinsImage = new Image(SkinManager.instance.getSkinTexture("shopItemCoins"));
			}
			coinsImage.pivotX = coinsImage.width/2;
			coinsImage.pivotY = coinsImage.height/2;
			coinsImage.x = 50;
			coinsImage.y = 133;
			addChild(coinsImage);
			var dx:int = (75 - (15 + costTF.width))/2;
			costTF2.x += dx;
			costTF.x += dx;
			coinsImage.x += dx;
			
			corner = new Image(SkinManager.instance.getSkinTexture("shopItemCorner"));
			corner.x = 114;
			corner.y = 128;
			addChild(corner);
			
			_locked = new Image(SkinManager.instance.getSkinTexture("iconLock"));
			_locked.pivotX = _locked.width/2;
			_locked.pivotY = _locked.height/2;
			_locked.x = 110;
			_locked.y = 128;
			addChild(_locked);
			
			_checked = new Image(SkinManager.instance.getSkinTexture("iconPurchased"));
			_checked.pivotX = _checked.width/2;
			_checked.pivotY = _checked.height/2;
			_checked.x = 110;
			_checked.y = 128;
			addChild(_checked);
			
			sellItem = new Button(SkinManager.instance.getSkinTexture("buttonSell"));
			sellItem.pivotX = sellItem.width/2;
			sellItem.pivotY = sellItem.height/2;
			sellItem.scaleX = sellItem.scaleY = 0.3;
			sellItem.x = 127;
			sellItem.y = 16;
			//addChild(sellItem);
			
			if (!_client.unlocked)
			{
				locked();
			}
			else
			{
				unlocked();
			}
			
			checkAvialableness();
		}

		protected function checkAvialableness() : void
		{
			var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			if (mCon.width >= _client.expand.expandObject.width)
			{
				_locked.visible = false;
				_checked.visible = true;
				
				return;
			}
			
			if (mCon.width + 1 != _client.expand.expandObject.width)
			{
				_locked.visible = true;
				_checked.visible = false;
				
				return;
			}
			
			_locked.visible = false;
			_checked.visible = false;
		}
		
		protected function onUnlockMouseEvent(e : Object) : void
		{
					
					_client.unlock();
			
					e.stopImmediatePropagation();
					
		}
		
		private var _moving : Boolean = false;
		
		protected function onMouseEvent(e : Object) : void
		{
					if (!_client.unlocked)
						return;
					
					var mCon : MapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;

					var stringCase : StringCase;
					
					if (mCon.width >= _client.expand.expandObject.width)
					{
						stringCase = StringManager.instance.getCase(StringTypes.CannotExpandTooSmall)
						
						GuiManager.instance.showAlert(stringCase.title, stringCase.message);
						
						return;
					}
					
					if (mCon.width + 1 != _client.expand.expandObject.width)
					{
						stringCase = StringManager.instance.getCase(StringTypes.CannotExpandTooBig)
						
						GuiManager.instance.showAlert(stringCase.title, stringCase.message);
						
						return;
					}
					
					if (!_client.buy(_client.expand.expandObject.prices[0].currency))
						GuiManager.instance.noMoneyWindow.visible = true;
					
/*					if (_client.shopObject.object.type != ObjectTypes.Worker) 
						Map.instance.addMapEntity(shopClient.buy(shopClient.shopObject.prices[0].currency.type), shopClient);
					else
						Map.instance.addMapEntity(shopClient.buy(shopClient.shopObject.prices[0].currency.type, (shopClient.shopObject as WorkerShopObject).skill), shopClient);
*/					
		}

		protected function onUnlocked(e : ExpandShopClientEvent) : void
		{
			unlocked();
		}
		
		protected function unlocked() : void
		{
			if (unlock) {
				unlock.removeChildren(0, -1, true);
				unlock.removeFromParent(true);
				unlock = null;
			}
			bg.texture = SkinManager.instance.getSkinTexture("shopItemBg");
			image.alpha = coinsImage.alpha = costTF2.alpha = costTF.alpha = itemNameTF2.alpha = itemNameTF.alpha = 1.0;
			corner.visible = true;
		}
		
		protected function locked() : void
		{
			bg.texture = SkinManager.instance.getSkinTexture("shopItemBgDisabled");
			bg2.visible = false;
			corner.visible = false;
			
			unlock = new Sprite();
			addChild(unlock);
			
			image.alpha = coinsImage.alpha = costTF2.alpha = costTF.alpha = itemNameTF2.alpha = itemNameTF.alpha = 0.3;
			
			var cond : ConditionData = _client.expand.condition;
			
			if (!_client.canUnlock) {
				unlockButton = new Button(SkinManager.instance.getSkinTexture("taskBlast"));
				unlockButton.scaleX = unlockButton.scaleY = 0.8;
				unlockButton.scaleWhenDown = 1/unlockButton.scaleX;
				unlockButton.pivotX = unlockButton.width/2;
				unlockButton.pivotY = unlockButton.height/2;
				unlockButton.x = 81;
				unlockButton.y = 117;
				unlock.addChild(unlockButton);
				
				unlockTitle2 = font2.createSprite(92, 18, "Открыть за", 18, 0xFF9900);
				unlockTitle2.x = 13;
				unlockTitle2.y = 19;
				(unlockButton.getChildAt(0) as Object).addChild(unlockTitle2);
				unlockTitle = font.createSprite(92, 18, "Открыть за", 18, 0xFFFFFF);
				unlockTitle.x = 13;
				unlockTitle.y = 19;
				(unlockButton.getChildAt(0) as Object).addChild(unlockTitle);
				
				unlockCost2 = fontN2.createSprite(18, 18, ""+cond.price.amount, 18, 0xFF9900, "right");
				unlockCost2.x = unlockTitle2.x + 23;
				unlockCost2.y = unlockTitle2.y + 25;
				(unlockButton.getChildAt(0) as Object).addChild(unlockCost2);
				unlockCost = fontN.createSprite(18, 18, ""+cond.price.amount, 18, 0xFFFFFF, "right");
				unlockCost.x = unlockCost2.x;
				unlockCost.y = unlockCost2.y;
				(unlockButton.getChildAt(0) as Object).addChild(unlockCost);
			}
			
			line02 = font2.createSprite(136, 16, "Требуется", 16, 0xFFFFFF, "center", "top");
			line02.x = 12;
			line02.y = 55;
			unlock.addChild(line02);
			line0 = font.createSprite(136, 16, "Требуется", 16, 0xFF9900, "center", "top");
			line0.x = 12;
			line0.y = 55;
			unlock.addChild(line0);
			
			var text1:String, text2:String, text3:String;
			
			if (cond.friends > 0 && cond.level > 0)
			{
				text1 = "" + cond.level + " уровень";
				text2 = "или";
				text3 = "" + cond.friends + " друзей";
				//trace(text1, text2, text3)
			}
			else if (cond.friends > 0)
			{
				text1 = "" + cond.friends + " друзей";
			}
			else if (cond.level > 0)
			{
				text1 = "" + cond.level + " уровень";
			}
			
			if (text1) {
				line12 = font2.createSprite(101, 18, text1, 18, 0xFFFFFF);
				line12.x = 28;
				line12.y = 73;
				unlock.addChild(line12);
				line1 = font.createSprite(101, 18, text1, 18, 0xFF9900);
				line1.x = 28;
				line1.y = 73;
				unlock.addChild(line1);
			}
			
			if (text2) {
				line22 = font2.createSprite(101, 18, text2, 18, 0xFFFFFF);
				line22.x = 28;
				line22.y = 93;
				unlock.addChild(line22);
				line2 = font.createSprite(101, 18, text2, 16, 0xFF9900);
				line2.x = 28;
				line2.y = 93;
				unlock.addChild(line2);
			}
			
			if (text3) {
				line32 = font2.createSprite(101, 18, text3, 16, 0xFFFFFF);
				line32.x = 28;
				line32.y = 113;
				unlock.addChild(line32);
				line3 = font.createSprite(101, 18, text3, 16, 0xFF9900);
				line3.x = 28;
				line3.y = 113;
				unlock.addChild(line3);
			}
		}
		
		/*protected function get sellItem() : MovieClip
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
		}*/
	}
}
class ButtonState
{
	/** @private */
	public function ButtonState() {}

	/** The button's default state. */
	public static const UP:String = "up";

	/** The button is pressed. */
	public static const DOWN:String = "down";

	/** The mouse hovers over the button. */
	public static const OVER:String = "over";

	/** The button was disabled altogether. */
	public static const DISABLED:String = "disabled";
}