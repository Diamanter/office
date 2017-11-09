package com.sigma.socialgame.view.gui.components.friends.bar
{
	import com.api.forticom.ForticomAPI;
	import com.sigma.socialgame.model.social.OdnoklassnikiFAPI;
	import com.sigma.socialgame.model.social.OndoklassnikiDelegate;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.model.social.SocialNetwork;
	
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
	
	public class AddFriendBarItem extends Sprite
	{
//		private var _skin : MovieClip;
		
		private var bg:Image;
		private var bg2:Image;
        private var mState:String;
        private var mTriggerBounds:Rectangle;			
		
		public function AddFriendBarItem()
		{
			super();
			
			var ind : int = Math.floor(Math.random() * 4.0) + 1;
			
			bg = new Image(SkinManager.instance.getSkinTexture("addFriend"+ind));
			bg.x = 18;
			bg.y = 14;
			addChild(bg);			
			addEventListener(TouchEvent.TOUCH, onTouch);
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
                if (!touch.cancelled) onMouseEvent();
            }
        }
		
        public function get state():String { return mState; }
        public function set state(value:String):void
        {
            mState = value;
		}
		
		protected function onMouseEvent(e : Object = null) : void
		{
					
//					ForticomAPI.showInvite();
					
//					ExternalInterface.call("FAPI.UI.showInvite");
					
					//OdnoklassnikiFAPI.showInvite();
				
					SocialNetwork.instance.invite([]);
					
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