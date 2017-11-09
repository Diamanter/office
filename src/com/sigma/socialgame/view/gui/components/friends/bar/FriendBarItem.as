package com.sigma.socialgame.view.gui.components.friends.bar
{

	import com.api.forticom.ForticomAPI;
	import com.sigma.socialgame.controller.friends.clients.AppFriendClient;
	import com.sigma.socialgame.controller.friends.clients.FriendClient;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
	import flash.geom.Rectangle;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.*;
	import flash.net.*;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
    
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
	
	public class FriendBarItem extends Sprite
	{
//		private var _skin : MovieClip;
		
//		private var _friend : FriendObject;
		private var _friendClient : AppFriendClient;	
		
		private var image:Image;
		private var friendNameTF:Sprite;
		private var friendNameTF2:Sprite;
		private var levelTF:Sprite;
		private var levelTF2:Sprite;
		private var texture:Texture;
		private var bg:Image;
		private var bg2:Image;
		private var levelImage:Image;
		private var giftsButton:Button;
		private var fontN:BitmapFont = starling.text.TextField.getBitmapFont("imp");
		private var fontN2:BitmapFont = starling.text.TextField.getBitmapFont("imp2");
		private var font:BitmapFont = starling.text.TextField.getBitmapFont("ver");
		private var font2:BitmapFont = starling.text.TextField.getBitmapFont("ver2");
        private var mState:String;
        private var mTriggerBounds:Rectangle;			
		
		public function FriendBarItem()
		{
			super();
			
			bg = new Image(SkinManager.instance.getSkinTexture("shopItemBg"));
			bg.width = 109;
			bg.x = 18 + 14;
			bg.y = 14;
			addChild(bg);			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			/*var clazz : Class = SkinManager.instance.getSkin(GuiIds.FriendBarItem);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				_skin.addEventListener(MouseEvent.CLICK, onMouseEvent);
				
				sendButton.gotoAndStop(1);
				
				sendButton.addEventListener(MouseEvent.MOUSE_OVER, onSendMouseEvent);
				sendButton.addEventListener(MouseEvent.MOUSE_OUT, onSendMouseEvent);
				
				sendButton.addEventListener(MouseEvent.CLICK, onSendMouseEvent);
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
		
		protected function onSendMouseEvent(e : Object) : void
		{

					e.stopImmediatePropagation();
					
					var sCase : StringCase;
					
					if (friendClient.friendObject.friend.gifts >= ParamManager.instance.getConfigParam(ParamType.GiftNum))
					{
						sCase = StringManager.instance.getCase(StringTypes.NotThisFriend);
						
						GuiManager.instance.showAlert(sCase.title, sCase.message);
						
						return;
					}
					
					friendClient.sendGift();
					
		}
		
		protected function onMouseEvent(e : Object) : void
		{
			friendClient.gotoOffice();
		}
		
		public function get friendClient():AppFriendClient
		{
			return _friendClient;
		}
		
		private var loader : Loader;
		
		public function set friendClient(value:AppFriendClient):void
		{
			_friendClient = value;
			
			friendNameTF2 = font2.createSprite(92, 25, _friendClient.friendObject.socFriend.name, 20, 0xFF3300, "center", "top");
			friendNameTF2.x = 41;
			friendNameTF2.y = 110;
			addChild(friendNameTF2);
			friendNameTF = font.createSprite(92, 25, _friendClient.friendObject.socFriend.name, 20, 0x000000, "center", "top");
			friendNameTF.x = 41;
			friendNameTF.y = 110;
			addChild(friendNameTF);
			
			levelImage = new Image(SkinManager.instance.getSkinTexture("iconFriend"));
			levelImage.pivotX = levelImage.width/2;
			levelImage.pivotY = levelImage.height/2;
			levelImage.x = 40;
			levelImage.y = 22;
			addChild(levelImage);
			
			giftsButton = new Button(SkinManager.instance.getSkinTexture("buttonGifts"));
			giftsButton.pivotX = giftsButton.width/2;
			giftsButton.pivotY = giftsButton.height/2;
			giftsButton.scaleX = giftsButton.scaleY = 0.35;
			giftsButton.x = 40;
			giftsButton.y = 57;
			addChild(giftsButton);
			
			levelTF2 = fontN2.createSprite(25, 25, ""+_friendClient.friendObject.friend.level, 20, 0xFFCC00, "center", "center");
			levelTF2.x = 25;
			levelTF2.y = 6;
			//addChild(levelTF2);
			levelTF = fontN.createSprite(25, 25, ""+_friendClient.friendObject.friend.level, 20, 0x993333, "center", "center");
			levelTF.x = 25;
			levelTF.y = 9;
			addChild(levelTF);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorListener);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityListener);
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPic);
			
			if (_friendClient.friendObject.socFriend.pic != null)
				loader.load(new URLRequest(_friendClient.friendObject.socFriend.pic), context);
				
			addEventListener(Event.TRIGGERED, onMouseEvent);
			giftsButton.addEventListener(Event.TRIGGERED, onSendMouseEvent);
			//friendLevelTF.text = String(_friendClient.friendObject.friend.level);
		}
		
		private function IOErrorListener(evt:Object):void {
			close();
		}
		private function securityListener(evt:Object):void {
			trace(evt)
		}
		private function onLoadPic(event:Object):void {
			var data:BitmapData = (event.target.content as Bitmap).bitmapData;
			if (texture) texture.dispose();
			texture = Texture.fromBitmapData(data, false);
			onLoaderComplete();
		}
		private function close():void {
			if (loader) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadPic);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorListener);
				loader = null;
			}
		}
		public function onLoaderComplete() : void
		{
			image = new Image(texture);
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			var wsc : Number = image.width / 80;
			var hsc : Number = image.height / 80;
			
			var resK : Number = wsc > hsc ? wsc : hsc;
			
			if (wsc > 1.0 || hsc > 1.0)
			{
				resK = 1 / resK;
			}
			
			image.scaleX = resK;
			image.scaleY = resK;
			
			image.x = 88;
			image.y = 64;
			
			addChildAt(image, 3);
			
			close();
		}
		
		private static const _friendName : String = "friendName";
		private static const _friendLevel : String = "FriendLevel";
		private static const _sendButton : String = "SendButton";
		
		private static const _image : String = "image";
		
		/*protected function get image() : MovieClip
		{
			return _skin[_image];
		}
		
		protected function get friendLevelTF() : TextField
		{
			return _skin[_friendLevel] as TextField;
		}

		protected function get sendButton() : MovieClip
		{
			return _skin[_sendButton] as MovieClip;
		}
		
		protected function get friendNameTF() : TextField
		{
			return _skin[_friendName] as TextField;
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