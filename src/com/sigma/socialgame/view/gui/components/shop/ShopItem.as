package com.sigma.socialgame.view.gui.components.shop
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.shop.clients.ShopClient;
	import com.sigma.socialgame.controller.shop.objects.WorkerShopObject;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.events.controller.ShopClientEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.WorkerLimit;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	import com.sigma.socialgame.view.game.map.objects.graphic.MovieClipped;
	
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
	import starling.text.TextField;
	import starling.text.BitmapFont;
	
	public class ShopItem extends Sprite
	{
		//private var _skin : MovieClip;
		
		private var _client : ShopClient;
		
		//private var _graphicLoader : ShopGraphicLoader;
		
		private var bg:Image;
		private var bg2:Image;
		private var fontN:BitmapFont = starling.text.TextField.getBitmapFont("imp");
		private var fontN2:BitmapFont = starling.text.TextField.getBitmapFont("imp2");
		private var font:BitmapFont = starling.text.TextField.getBitmapFont("ver");
		private var font2:BitmapFont = starling.text.TextField.getBitmapFont("ver2");
        private var mState:String;
        private var mTriggerBounds:Rectangle;			
		
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
		private var star1:Sprite;
		private var star2:Sprite;
		private var star3:Sprite;
		private var coinsImage:Image;
		private var image:MovieClipped;
		private var corner:Image;
		
		public function ShopItem()
		{
			super();
			
			//_graphicLoader = new ShopGraphicLoader(); 
			
			bg = new Image(SkinManager.instance.getSkinTexture("shopItemBg"));
			bg.x = 18;
			bg.y = 14;
			addChild(bg);			
			bg2 = new Image(SkinManager.instance.getSkinTexture("shopItemBg2"));
			bg2.x = 38.5;
			bg2.y = 47;
			addChild(bg2);			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			/*var clazz : Class = SkinManager.instance.getSkin(GuiIds.ShopItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				image.addChild(_graphicLoader);
				
				itemNameTF.selectable = false;
				itemCountTF.selectable = false;
				
				_skin.addEventListener(MouseEvent.CLICK, onMouseEvent);
				_skin.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
				_skin.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				
				sellItem.gotoAndStop(1);
				unlockButton.gotoAndStop(1);
				
				sellItem.addEventListener(MouseEvent.CLICK, onSellMouseEvent);
				sellItem.addEventListener(MouseEvent.MOUSE_OUT, onSellMouseEvent);
				sellItem.addEventListener(MouseEvent.MOUSE_OVER, onSellMouseEvent);
				
				unlockButton.addEventListener(MouseEvent.CLICK, onUnlockMouseEvent);
				unlockButton.addEventListener(MouseEvent.MOUSE_OUT, onUnlockMouseEvent);
				unlockButton.addEventListener(MouseEvent.MOUSE_OVER, onUnlockMouseEvent);
				
				Map.instance.addEventListener(MapEvent.StartMove, onMapEvent);
				Map.instance.addEventListener(MapEvent.EndMove, onMapEvent);
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
		
		protected function onMapEvent(e : MapEvent) : void
		{
			trace(e)
			switch (e.type)
			{
				case MapEvent.StartMove:
					_moving = true;
					
					setAmount();
					break;
				
				case MapEvent.EndMove:
					_moving = false;
					
					setAmount();
					break;
			}
		}
		
		protected function onSellMouseEvent(e : Object) : void
		{
					
					if (shopClient.shopObject.object.type == ObjectTypes.Worker)
						shopClient.sell((shopClient.shopObject as WorkerShopObject).skill);
					else
						shopClient.sell();
					e.stopImmediatePropagation();
				
		}
		
		protected function onUnlockMouseEvent(e : Object) : void
		{
					shopClient.unlock();
			
					e.stopImmediatePropagation();
		}
		
		private var _moving : Boolean = false;
		
		protected function onMouseEvent(e : Object) : void
		{
					if (!shopClient.unlocked)
						return;
					
					if (!Map.instance.canBuy)
						return;
					
					if (shopClient.shopObject.object.type == ObjectTypes.Worker)
					{
						if (!WorkerLimit.instance.canAddWorker())
						{
							var sCase : StringCase = StringManager.instance.getCase(StringTypes.WorkerLimit);
							
							GuiManager.instance.showAlert(sCase.title, sCase.message);
							
							return;
						}
					}
					
					Field.instance.mouseMode = MouseModes.Select;
					
					Map.instance._wasBought = (shopClient.alreadyHave() == 0);

					var storeObj : StoreObject;
					
					if (shopClient.shopObject.object.type != ObjectTypes.Worker)
						storeObj = shopClient.buy(shopClient.shopObject.prices[0].currency.type)
					else
						storeObj = shopClient.buy(shopClient.shopObject.prices[0].currency.type, (shopClient.shopObject as WorkerShopObject).skill);

					if (storeObj != null)
						Map.instance.addMapEntity(storeObj, shopClient);
					else
						GuiManager.instance.noMoneyWindow.visible = true;
					
		}
		
		protected function setAmount() : void
		{
			var have : int = _client.alreadyHave();
			
			if (_moving && Map.instance.moving != null && !shopClient.wasBought)
			{
				if (Map.instance.moving.mapClient.mapObject.storeObject.storeObject.object.objectId.equals(shopClient.shopObject.object.objectId))
				{
					if (shopClient.shopObject.object.type == ObjectTypes.Worker)
					{
						if ((shopClient.shopObject as WorkerShopObject).skill.id == (Map.instance.moving.mapClient.mapObject.storeObject.storeObject as WorkerStoreObjectData).currSkill.id)
							have += 1;
					}
					else
						have += 1;
				}
			}
			
			if (itemCountTF) {
				itemCountTF2.removeChildren(0, -1, true);
				itemCountTF2.removeFromParent(true);
				itemCountTF.removeChildren(0, -1, true);
				itemCountTF.removeFromParent(true);
			}
			
			if (have > 0)
			{
				sellItem.visible = true;
				itemCountTF2 = fontN2.createSprite(70, 24, have.toString(), 14, 0xFFFFFF);
				itemCountTF2.x = 29;
				itemCountTF2.y = 5;
				//addChild(itemCountTF2);
				itemCountTF = fontN.createSprite(70, 24, have.toString(), 14, 0xFF6600);
				itemCountTF.x = 29;
				itemCountTF.y = 5;
				//addChild(itemCountTF);
			}
			else
			{
				sellItem.visible = false;
			}
		}
		
		public function get shopClient():ShopClient
		{
			return _client;
		}
		
		public function set shopClient(value:ShopClient):void
		{
			_client = value;
			
			var prefix:String;
			var suffix:String;
			
			switch (shopClient.shopObject.object.type)
			{
				case ObjectTypes.Worker:
					prefix = "";
					suffix = (_client.shopObject as WorkerShopObject).skill.rank + "_NW";
					break;
				
				case ObjectTypes.Workspace:
					prefix = "";
					suffix = "_table_NW";
					break;
				
				case ObjectTypes.Decor:
					prefix = "";
					suffix = "_NW";
					break;
				
				case ObjectTypes.Trim:
					prefix = "";
					suffix = "_NW";
					break;
			}
			var textures:Vector.<Texture> = SkinManager.instance.getSkinTextures(prefix + shopClient.shopObject.object.objectId.id + suffix);
			if (textures.length==0 && shopClient.shopObject.object.type == ObjectTypes.Worker) textures = SkinManager.instance.getSkinTextures("worker_" + shopClient.shopObject.object.objectId.id + suffix);
			if (shopClient.shopObject.object.type == ObjectTypes.Worker) trace("shopid", shopClient.shopObject.object.objectId.id, (_client.shopObject as WorkerShopObject).skill.rank, textures.length);
			
			if (textures && textures.length>0) {
				image = new MovieClipped(textures);
				var clipping:Rectangle = image.clipping;
				
				image.pivotX = clipping.x + clipping.width / 2;
				image.pivotY = clipping.y + clipping.height / 2;
					
				var wsc : Number = clipping.width / 95;
				var hsc : Number = clipping.height / 75;
				
				var resK : Number = wsc > hsc ? wsc : hsc;
				
				if (wsc > 1.0 || hsc > 1.0)
				{
					resK = 1 / resK;
				}
				
				image.scaleX = resK;
				image.scaleY = resK;
			
				image.x = 81;
				image.y = 81;
				addChild(image);
			
				if (shopClient.shopObject.object.type != ObjectTypes.Worker) {
					//_graphicLoader.setImage(shopClient.shopObject.object.objectId.id);
				} else {
					//_graphicLoader.setImage(shopClient.shopObject.object.objectId.id, (_client.shopObject as WorkerShopObject).skill);
				}
			} else {
				return;
			}
			
			shopClient.addEventListener(ShopClientEvent.Unlocked, onUnlocked);
			shopClient.addEventListener(ShopClientEvent.AmountChanged, onAmountChanged);
			
			var itemName:String = _client.shopObject.object.name;
			if (itemName.indexOf("_")!=-1) itemName = StringManager.instance.getText(_client.shopObject.object.name);
			itemNameTF2 = font2.createSprite(116, 60, itemName, 20, 0xFFCC00, "center", "top");
			itemNameTF2.x = 23;
			itemNameTF2.y = 16;
			addChild(itemNameTF2);
			itemNameTF = font.createSprite(116, 60, itemName, 20, 0x000000, "center", "top");
			itemNameTF.x = 23;
			itemNameTF.y = 16;
			addChild(itemNameTF);
			
			costTF2 = fontN2.createSprite(70, 20, ""+_client.shopObject.prices[0].amount, 18, 0xFFCC00, "left", "top");
			costTF2.x = 67;
			costTF2.y = 125;
			addChild(costTF2);
			costTF = fontN.createSprite(70, 20, ""+_client.shopObject.prices[0].amount, 18, 0x000000, "left", "top");
			costTF.x = 67;
			costTF.y = 125;
			addChild(costTF);
			
			if (_client.shopObject.prices[0].currency.type == "gold")
			{
				coinsImage = new Image(SkinManager.instance.getSkinTexture("shopItemGold"));
			}
			else if (_client.shopObject.prices[0].currency.type == "coins")
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
			
			sellItem = new Button(SkinManager.instance.getSkinTexture("buttonSell"));
			sellItem.pivotX = sellItem.width/2;
			sellItem.pivotY = sellItem.height/2;
			sellItem.scaleX = sellItem.scaleY = 0.4;
			sellItem.x = 127;
			sellItem.y = 16;
			//addChild(sellItem);
			
			/*var i : int;
			
			if (_client.shopObject is WorkerShopObject)
			{
				for (i = 0; i < (_client.shopObject as WorkerShopObject).skill.rank; i++)
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
			}*/
			
			setAmount();
			
			if (!_client.unlocked)
			{
				locked();
			}
			else
			{
				unlocked();
			}
			addEventListener(Event.TRIGGERED, onMouseEvent);
		}
		
		protected function onAmountChanged(e : ShopClientEvent) : void
		{
			setAmount();
		}
		
		protected function onUnlocked(e : ShopClientEvent) : void
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
			
			var cond : ConditionData = (_client.shopObject.prices[0] as ILockable).condition;
			
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