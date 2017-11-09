package com.sigma.socialgame.events.view.gui
{
	import com.sigma.socialgame.view.gui.components.task.Task;
	
	import flash.events.Event;
	
	public class TaskEvent extends Event
	{
		public static const Unlock : String = "tUnlock";
		
		private var _task : Task;
		
		public function TaskEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get task():Task
		{
			return _task;
		}

		public function set task(value:Task):void
		{
			_task = value;
		}

	}
}