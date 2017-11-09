package com.sigma.socialgame.view.gui.components
{
	import com.sigma.socialgame.model.social.SocialNetwork;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class GiftAlert extends AlertWindow
	{
		public function GiftAlert()
		{
			super();
			
			okButt.Title1.text = "Рассказать друзьям";
			
		}
		
		protected override function onMouseEvent(e : MouseEvent) : void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					mc.gotoAndStop(2);
					
					okButt.Title1.text = "Рассказать друзьям";
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					mc.gotoAndStop(1);
					
					okButt.Title1.text = "Рассказать друзьям";
					
					break;
			}
		}
		
		protected override function onOkButtonClick(e:MouseEvent):void
		{
			visible = false;
			
			var stringCase : StringCase = StringManager.instance.getCase(StringTypes.GiftPublish);
			
			SocialNetwork.instance.publish(stringCase.title, stringCase.message, stringCase.imageMessage);
		}
	}
}