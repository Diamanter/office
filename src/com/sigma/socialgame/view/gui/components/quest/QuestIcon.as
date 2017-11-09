package com.sigma.socialgame.view.gui.components.quest
{
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Button;
	import starling.display.MovieClip;
	
	public class QuestIcon extends Sprite
	{
		//private var _skin : MovieClip;
		
		private var _questObject : QuestObject;
		
		public function QuestIcon(image_ : String)
		{
			super();
			trace(image_);
			var button:Button = new Button(SkinManager.instance.getSkinTexture(image_));
			button.pivotX = button.width/2;
			button.pivotY = button.height/2;
			addChild(button);			
			addEventListener(Event.TRIGGERED, onClick);
			
			
			/*var clazz : Class = SkinManager.instance.getQuestSkin(image_);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				addEventListener(MouseEvent.CLICK, onClick);
			}*/
		}
		
		protected function onClick(e : Object) : void
		{
			GuiManager.instance.showQuestWindow(_questObject);
		}

		public function get questObject():QuestObject
		{
			return _questObject;
		}

		public function set questObject(value:QuestObject):void
		{
			_questObject = value;
		}

	}
}