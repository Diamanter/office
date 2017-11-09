package com.sigma.socialgame.events.controller
{
	public class WorkerClientEvent extends EntityClientEvent
	{
		public static const WorkDone : String = "wcWorkDone"; 
		public static const WorkStarted : String = "wcWorkStarted"; 
		public static const WorkAccepted : String = "wcWorkAccepted"; 
	
		public static const Manured : String = "wcManured";
		public static const UnManured : String = "wcUnManured";
		
		public static const SkillUp : String = "wcSkillUp";
		
		public static const Tick : String = "wcTick";
		
		private var _secElapsed : int;
		private var _secLeft : int;
		
		public function WorkerClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get secLeft():int
		{
			return _secLeft;
		}

		public function set secLeft(value:int):void
		{
			_secLeft = value;
		}

		public function get secElapsed():int
		{
			return _secElapsed;
		}

		public function set secElapsed(value:int):void
		{
			_secElapsed = value;
		}

	}
}