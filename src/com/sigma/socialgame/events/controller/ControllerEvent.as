package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class ControllerEvent extends Event
	{
		private var _controllerName : String;
		
		public function ControllerEvent(type:String, name_ : String)
		{
			super(type);
			
			_controllerName = name_;
		}

		public function get controllerName():String
		{
			return _controllerName;
		}

		public function set controllerName(value:String):void
		{
			_controllerName = value;
		}

	}
}