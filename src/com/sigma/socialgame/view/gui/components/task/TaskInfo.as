package com.sigma.socialgame.view.gui.components.task
{
	import com.sigma.socialgame.events.controller.WorkerClientEvent;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyType;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TaskInfo extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _workerEntity : WorkerEntity;
		
		private var _task : CurrTaskData;
		private var _job : JobData;
		
		private var _taskGraphic : TaskGraphicLoader;
		
		public function TaskInfo()
		{
			super();
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.TaskInfo);

			if (clazz != null)
			{
				_taskGraphic = new TaskGraphicLoader();
				
				_skin =  new clazz();
				
				addChild(_skin);
				
				image.addChild(_taskGraphic);
				
				experienceTF.selectable = false;
				moneyTF.selectable = false;
				timeTF.selectable = false;
				
				okButton.gotoAndStop(1);
				
				okButton.addEventListener(MouseEvent.CLICK, onOkMouseEvent);
				okButton.addEventListener(MouseEvent.MOUSE_OVER, onOkMouseEvent);
				okButton.addEventListener(MouseEvent.MOUSE_OUT, onOkMouseEvent);
				
				cancelButton.gotoAndStop(1);
				
				cancelButton.addEventListener(MouseEvent.CLICK, onCancelMouseEvent);
				cancelButton.addEventListener(MouseEvent.MOUSE_OVER, onCancelMouseEvent);
				cancelButton.addEventListener(MouseEvent.MOUSE_OUT, onCancelMouseEvent);
			}
		}
		
		public function get task():CurrTaskData
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
			
			applyJob();
		}

		public function set task(value:CurrTaskData):void
		{
			_task = value;
			
			applyTask();
		}

		public function get workerEntity():WorkerEntity
		{
			return _workerEntity;
		}

		public function set workerEntity(value:WorkerEntity):void
		{
			removeWorker();
			
			_workerEntity = value;
			
			applyWorker();
		}

		protected function removeWorker() : void
		{
			if (_workerEntity != null)
				_workerEntity.workerClient.removeEventListener(WorkerClientEvent.Tick, onTick);
		}
		
		protected function applyWorker() : void
		{
			_workerEntity.workerClient.addEventListener(WorkerClientEvent.Tick, onTick);
		}
		
		protected function applyJob() : void
		{
			timeTF.text = "";
			
			for each (var give : GiveData in _job.gives)
			{
				switch (give.currency.type)
				{
					case CurrencyType.Experience:
						experienceTF.text = String(give.amount);
						break;
					
					case CurrencyType.Coin:
						moneyTF.text = String(give.amount);
						break;
				}
			}
		}
		
		protected function applyTask() : void
		{
			nameTF.text = _task.task.name;
			
			_taskGraphic.setImage(_task.task.image);
		}
		
		protected function onTick(e : WorkerClientEvent) : void
		{
			var time : Date = new Date(e.secLeft * 1000);
			
			var hours : int = e.secLeft / (60 * 60);
			var minutes : int = time.minutesUTC;
			var seconds : int = time.secondsUTC;
			
			var timeStr : String = "";
			
			if (hours != 0)
				timeStr += "" + hours + "ч. ";
			
			if (minutes != 0)
				timeStr += "" + minutes + "м. ";
			
			if (seconds < 10)
				timeStr += "0";
			
			timeStr += "" + seconds + "с.";
			
			timeTF.text = timeStr;
			
			if (e.secLeft == 0)
				GuiManager.instance.closeTaskInfo();
		}
		
		protected function onOkMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					GuiManager.instance.closeTaskInfo();
					break;
				
				case MouseEvent.MOUSE_OVER:
					okButton.gotoAndStop(2);
					break;
				
				case MouseEvent.MOUSE_OUT:
					okButton.gotoAndStop(1);
					break;
			}
		}
		
		protected function callBack(val_ : Boolean) : void
		{
			if (val_)
			{
				_workerEntity.cancelTask();
				GuiManager.instance.closeTaskInfo();
			}	
		}
		
		protected function onCancelMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					var stringCase : StringCase = StringManager.instance.getCase(StringTypes.CancelTask);
					
					GuiManager.instance.showConfirm(stringCase.title, stringCase.message, callBack);
					break;
				
				case MouseEvent.MOUSE_OVER:
					cancelButton.gotoAndStop(2);
					break;
				
				case MouseEvent.MOUSE_OUT:
					cancelButton.gotoAndStop(1);
					break;
			}
		}
		
		private const _okButton : String = "OkButton";
		private const _cancelButton : String = "CancelButton";
		private const _money : String = "money";
		private const _time : String = "time";
		private const _experience : String = "experience";
		private const _name : String = "Name";
		private const _image : String = "image";
		
		protected function get image() : MovieClip
		{
			return _skin[_image];
		}
		
		protected function get nameTF() : TextField
		{
			return _skin[_name];
		}
		
		protected function get okButton() : MovieClip
		{
			return _skin[_okButton] as MovieClip;
		}
		
		protected function get cancelButton() : MovieClip
		{
			return _skin[_cancelButton] as MovieClip;
		}
		
		protected function get moneyTF() : TextField
		{
			return _skin[_money] as TextField;
		}
		
		protected function get timeTF() : TextField
		{
			return _skin[_time] as TextField;
		}
		
		protected function get experienceTF() : TextField
		{
			return _skin[_experience] as TextField;
		}


	}
}