package com.sigma.socialgame.events.controller
{
	import flash.events.Event;
	
	public class QuestClientEvent extends Event
	{
		public static const QuestChanged : String = "qcQuestChanged";
		
		public function QuestClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}