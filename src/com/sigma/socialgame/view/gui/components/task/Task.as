package com.sigma.socialgame.view.gui.components.task
{
	import com.sigma.socialgame.events.view.gui.TaskEvent;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.config.object.task.NeedData;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Task extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _task : TaskData;
		private var _job : JobData;
		
		private var _taskGraphic : TaskGraphicLoader;
		
		public function Task()
		{
			super();
			
			_taskGraphic = new TaskGraphicLoader();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.Task);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);

				_taskGraphic.useHandCursor = true;

				image.addChild(_taskGraphic);
				
				nameTF.selectable = false;
				timeTF.selectable = false;
				experienceTF.selectable = false;
				moneyTF.selectable = false;
				priceTF.selectable = false;
				
				unlockButton.gotoAndStop(1);
				
				unlockButton.addEventListener(MouseEvent.MOUSE_OVER, onUnlockButtonMouseEvent);
				unlockButton.addEventListener(MouseEvent.MOUSE_OUT, onUnlockButtonMouseEvent);
				unlockButton.addEventListener(MouseEvent.CLICK, onUnlockButtonMouseEvent);
			}
		}
		
		protected function onUnlockButtonMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
trace("task click") ;
					var newTE : TaskEvent = new TaskEvent(TaskEvent.Unlock);
					newTE.task = this;
					dispatchEvent(newTE);
					
					e.stopPropagation();
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					
					unlockButton.gotoAndStop(1);
					
					break;
				
				case MouseEvent.MOUSE_OVER:
					
					unlockButton.gotoAndStop(2);
					
					break;
			}
		}
		
		public function get task() : TaskData
		{
			return _task;
		}
		
		public function get job():JobData
		{
			return _job;
		}
		
		public function set job(value:JobData):void
		{
			_job = value;

			var time : Date = new Date(_job.period * 1000);
			
			var hours : int = _job.period / (60 * 60);
			var minutes : int = time.minutesUTC;
			var seconds : int = time.secondsUTC;

			var timeStr : String = "";
			
			if (hours != 0)
				timeStr += "" + hours + "ч. ";
			
			if (minutes != 0)
				timeStr += "" + minutes + "м. ";
			
			if (seconds != 0)
				timeStr += "" + seconds + "с.";
			
			timeTF.text = timeStr;
			
			for each (var gives : GiveData in _job.gives)
			{
				switch (gives.currency.type)
				{
					case CurrencyType.Experience:
						experienceTF.text = String(gives.amount);
						break;
					
					case CurrencyType.Coin:
						moneyTF.text = String(gives.amount);
						break;
				}
			}
			
			for each (var need : NeedData in _job.need)
			{
				switch (need.currency.type)
				{
					case CurrencyType.Coin:
						priceTF.text = String(need.amount);
						break;
				}
			}
		}
		
		public function locked(canUnlock_ : Boolean) : void
		{
			unlock.visible = true;
			
			var cond : ConditionData = (job as ILockable).condition;

			if (!canUnlock_)
				unlockButton.visible = false;
			else
				unlockButton.visible = true;
			
			unlockCost.text = String(cond.price.amount);
			
			if (cond.friends > 0 && cond.level > 0)
			{
				line1.text = "" + cond.level + " уровень";
				line3.text = "" + cond.friends + " друзей";
			}
			else if (cond.friends > 0)
			{
				line1.visible = false;
				line2.text = "" + cond.friends + " друзей";
				line3.visible = false;
			}
			else if (cond.level > 0)
			{
				line1.visible = false;
				line2.text = "" + cond.level + " уровень";
				line3.visible = false;
			}
		}
		
		public function unlocked() : void
		{
			unlock.visible = false;
		}
		
		public function set task(task_ : TaskData) : void
		{
			_task = task_;
			
			nameTF.text = _task.name;
			
			_taskGraphic.setImage(_task.image);
		}
		
		private const _unlock : String = "unlockImage";
		
		private const _unlockCost : String = "Cost";
		private const _unlockButton : String = "unlockButton";
		
		private const _line1 : String = "RequaredOne";
		private const _line2 : String = "RequaredTwo";
		private const _line3 : String = "RequaredThree";
		
		private const _name : String = "taskName";
		private const _time : String = "time";
		private const _experience : String = "experience";
		private const _money : String = "money";
		private const _price : String = "price";
		private const _image : String = "image";
		
		protected function get line1() : TextField
		{
			return unlock[_line1];
		}
		
		protected function get line2() : TextField
		{
			return unlock[_line2];
		}
		
		protected function get line3() : TextField
		{
			return unlock[_line3];
		}
		
		protected function get unlockCost() : TextField
		{
			return unlockButton[_unlockCost];
		}
		
		protected function get unlockButton() : MovieClip
		{
			return unlock[_unlockButton];
		}
		
		protected function get unlock() : MovieClip
		{
			return _skin[_unlock];
		}
		
		protected function get image() : MovieClip
		{
			return _skin[_image] as MovieClip;
		}
		
		protected function get nameTF() : TextField
		{
			return _skin[_name] as TextField;
		}
		
		protected function get timeTF() : TextField
		{
			return _skin[_time] as TextField;
		}
		
		protected function get experienceTF() : TextField
		{
			return _skin[_experience] as TextField;
		}
		
		protected function get moneyTF() : TextField
		{
			return _skin[_money] as TextField;
		}
		
		protected function get priceTF() : TextField
		{
			return _skin[_price] as TextField;
		}
	}
}