package com.sigma.socialgame.view.gui.components.shop
{
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringManager;
	
    import flash.geom.Rectangle;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
	import flash.geom.Rectangle;
    
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.extensions.Scale9Image;
	import starling.text.TextField;
	import starling.text.BitmapFont;
	
	public class ShopTab extends Sprite
	{
		private var _skin : Scale9Image;
		private var _skinSelected : Scale9Image;
		private var _imageName : String;
        private var mState:String;
        private var mTriggerBounds:Rectangle;
        private var tabNameTF:Sprite;
        private var tabNameTF2:Sprite;
		
		private var fontN:BitmapFont = starling.text.TextField.getBitmapFont("imp");
		private var fontN2:BitmapFont = starling.text.TextField.getBitmapFont("imp2");
		private var font:BitmapFont = starling.text.TextField.getBitmapFont("ver");
		private var font2:BitmapFont = starling.text.TextField.getBitmapFont("ver2");
			
		public function ShopTab(name_ : String)
		{
			super();
			
			_imageName = name_;
			
			//var clazz : Class = SkinManager.instance.getSkin(name_);
			
			//if (clazz != null)
			//{
				_skin = new Scale9Image(SkinManager.instance.getSkinTexture("trimTab0001"), new Rectangle(40, 12, 20, 5));			
				_skinSelected = new Scale9Image(SkinManager.instance.getSkinTexture("trimTab0002"), new Rectangle(40, 12, 20, 5));
				addChild(_skin);
				addChild(_skinSelected);
				_skinSelected.visible = false;
				addEventListener(TouchEvent.TOUCH, onTouch);
				tabNameTF2 = font2.createSprite(200, 20, StringManager.instance.getText(name_), 20, 0xCCCCCC, "left", "top");
				tabNameTF2.x = 10;
				tabNameTF2.y = 1;
				tabNameTF2.alpha = 0.4;
				addChild(tabNameTF2);
				tabNameTF = font.createSprite(200, 20, StringManager.instance.getText(name_), 20, 0xFFFFFF, "left", "top");
				tabNameTF.x = 10;
				tabNameTF.y = 1;
				addChild(tabNameTF);
				if (tabNameTF.width + 20>100) {
					_skin.width = tabNameTF.width + 20;
					_skinSelected.width = tabNameTF.width + 20;
				} else {
					tabNameTF.x = tabNameTF2.x = 50 - tabNameTF.width/2;
				}
			//}
		}
		
		public function selected(sel_ : Boolean) : void
		{
			if (sel_) {
				_skin.visible = false;
				_skinSelected.visible = true;
			} else {
				_skin.visible = true;
				_skinSelected.visible = false;
			}
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
		
		public function get imageName():String
		{
			return _imageName;
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