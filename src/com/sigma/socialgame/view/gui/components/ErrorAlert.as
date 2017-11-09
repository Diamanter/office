package com.sigma.socialgame.view.gui.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class ErrorAlert extends AlertWindow
	{
		public function ErrorAlert()
		{
			super();
			
			okButt.Title1.text = "Перезагрузить";
		}
		
		protected override function onMouseEvent(e:MouseEvent):void
		{
			var mc : MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER:
					
					mc.gotoAndStop(2);
					
					okButt.Title1.text = "Перезагрузить";
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					mc.gotoAndStop(1);

					okButt.Title1.text = "Перезагрузить";
					
					break;
			}
		}
		
		protected override function onOkButtonClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("javascript:window.location.reload();"));
			
			visible = false;
		}
	}
}