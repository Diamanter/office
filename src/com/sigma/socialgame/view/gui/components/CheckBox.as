package com.sigma.socialgame.view.gui.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class CheckBox
	{
		private var _skin : MovieClip;
		
		private var _checked : Boolean;
		
		public function CheckBox()
		{
			super();
		}

		protected function onMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					if (_checked)
					{
						_checked = false;
						
						_skin.gotoAndStop(1);
					}
					else
					{
						_checked = true;
						
						_skin.gotoAndStop(2);
					}
					
					break;
				
/*				case MouseEvent.MOUSE_OUT:
					
					if (_checked)
						_skin.gotoAndStop(2);
					else
						_skin.gotoAndStop(1);
						
					break;
				
				case MouseEvent.MOUSE_OVER:
					
					if (_checked)
						_skin.gotoAndStop(4);
					else
						_skin.gotoAndStop(3);
					
					break;
*/			}
		}
		
		public function get skin():MovieClip
		{
			return _skin;
		}

		public function set skin(value:MovieClip):void
		{
			_skin = value;
			
			_checked = true;
			
			_skin.gotoAndStop(2);
			
			_skin.addEventListener(MouseEvent.CLICK, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			_skin.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}

		public function get checked():Boolean
		{
			return _checked;
		}

		public function set checked(value:Boolean):void
		{
			_checked = value;
		}


	}
}