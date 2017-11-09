package com.sigma.socialgame.controller.entity.clients
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.objects.EntityObject;
	import com.sigma.socialgame.controller.entity.objects.WorkerEntityObject;
	import com.sigma.socialgame.controller.entity.objects.WorkerEntityState;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.WorkerClientEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.object.WorkerObjectData;
	import com.sigma.socialgame.model.objects.config.object.lock.ILockable;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.config.object.task.NeedData;
	import com.sigma.socialgame.model.objects.config.object.task.RequireData;
	import com.sigma.socialgame.model.objects.config.object.task.RequireTypes;
	import com.sigma.socialgame.model.objects.config.object.task.ResultData;
	import com.sigma.socialgame.model.objects.config.object.task.ResultTypes;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.model.objects.sync.unlock.JobUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedData;
	import com.sigma.socialgame.sound.SoundEvents;
	import com.sigma.socialgame.sound.SoundManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class WorkerEntityClient extends EntityClient
	{
		public static const TAG : String = "WorkerEntityClient";
		
		private var _workingTimer : Timer;
		
		public function WorkerEntityClient()
		{
			super();
			
			_workingTimer = new Timer(1000, 1);
			_workingTimer.addEventListener(TimerEvent.TIMER, onTimer);
			_workingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		public override function set entityObj(entObj_:EntityObject):void
		{
			super.entityObj = entObj_;
			
			applyEntity();
		}
		
		public function currSkillJob(task_ : TaskData) : JobData
		{
			for each (var job : JobData in task_.jobs)
			{
				if (job.skill.id == workerObject.currSkill.id)
					return job;
			}
			
			return null;
		}
		
		protected function applyEntity() : void
		{
			if (workerObject.currTask != null)
			{
				var currTime : Date = ResourceManager.instance.currTime;
				
				var readyTime : Date = new Date();
				
				readyTime.setTime(workerObject.currTask.time);

				if (workerObject.currTask.complete)
				{
					workerObject.state = WorkerEntityState.WorkDone;
				}
				else
				{
					workerObject.state = WorkerEntityState.Working;
					
					_workingTimer.reset();
					_workingTimer.repeatCount = (readyTime.getTime() - currTime.getTime()) / 1000;
					_workingTimer.start();
				}
			}
			else
				workerObject.state = WorkerEntityState.NeedWork;
		}
		
		protected function onTimer(e : TimerEvent) : void
		{
			var wecEvent : WorkerClientEvent = new WorkerClientEvent(WorkerClientEvent.Tick);
			
			wecEvent.secElapsed = _workingTimer.currentCount;
			wecEvent.secLeft = _workingTimer.repeatCount - _workingTimer.currentCount; 
			
			dispatchEvent(wecEvent);
		}
		
		protected function onTimerComplete(e : TimerEvent) : void
		{
			Logger.message("Work done.", TAG, LogLevel.Debug, LogModule.Controller);
			
			workerObject.state = WorkerEntityState.WorkDone;
			workerObject.currTask.complete = true;
			
			_workingTimer.stop();
			
			SoundManager.instance.playEvent(workerObject.storeObject.storeObject.object.objectId.id);

			dispatchEvent(new WorkerClientEvent(WorkerClientEvent.WorkDone));
		}

		public function canStartTask(task_ : TaskData) : void
		{
			
		}
		
		public function canUnlock(task_ : TaskData) : Boolean
		{
			var cj : JobData = currSkillJob(task_);
			
			if (cj is ILockable)
			{
				if ((cj as ILockable).condition.price.amount > 0)
					return true;
			}
			
			return false;
		}
		
		public function unlock(task_ : TaskData) : Boolean
		{
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var cj : JobData = currSkillJob(task_);
			
			if (cj is ILockable)
			{
				var cond : ConditionData = (cj as ILockable).condition;
				
				if (wCon.getAmount(cond.price.currency.type).amountData.amount >= cond.price.amount)
				{
					wCon.addAmount(cond.price.currency.type, -cond.price.amount);
					
					ResourceManager.instance.addUnlockedJob(cond.price.currency.type, cj);
					
					return true;
				}
			}
			
			return false;
		}
		
		public function get manured() : Boolean
		{
			if (workerObject.currTask != null)
				return workerObject.currTask.manured;
			
			return false;
		}
		
		public function unlocked(task_ : TaskData) : Boolean
		{
			var cj : JobData = currSkillJob(task_);
			
			for each (var unlocked : UnlockedData in ResourceManager.instance.unlocked)
			{
				if (unlocked is JobUnlockedData)
				{
					if (cj.id == (unlocked as JobUnlockedData).job.id)
					{
						return true;
					}
				}
			}
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
			
			if (cj is ILockable)
			{
				if ((cj as ILockable).condition.level > 0)
					if ((cj as ILockable).condition.level <= wCon.currLevel.rank)
						return true;
				
				if ((cj as ILockable).condition.friends > 0)
					if ((cj as ILockable).condition.friends <= fCon.appFriends.length)
						return true;
			}
			else 
				return true;
			
			return false;
		}
		
		public function startTask(task_ : TaskData) : Boolean
		{
			if (workerObject.state != WorkerEntityState.NeedWork)
				return true;
			
			Logger.message("Staring task.", TAG, LogLevel.Debug, LogModule.Controller);
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var require : RequireData;
			var need : NeedData;
			
			var csJob : JobData = currSkillJob(task_);
			
			for each (need in csJob.need)
			{
				if (need.amount > wCon.getAmount(need.currency.type).amountData.amount)
				{
					Logger.message("Not enough currency.", TAG, LogLevel.Debug, LogModule.Controller);
					
					return false;
				}
			}
			
			for each (require in csJob.require)
			{
				if (require.type == RequireTypes.Object)
				{
					if (!sCon.hasObject(require.object))
					{
						return true;
					}
				}
			}
			
			//TODO remove needed objects
			
			for each (need in csJob.need)
			{
				wCon.addAmount(need.currency.type, -need.amount);
			}
	
			workerObject.currTask = ResourceManager.instance.addCurrTask(workerObject.storeObject.storeObject, task_, csJob);
//			workerObject.currTask = ResourceFactory.createCurrTask(task_, csJob, ResourceManager.instance.currTime.getTime());
			workerObject.state = WorkerEntityState.Working;
			
			_workingTimer.reset();
			_workingTimer.repeatCount = csJob.period; 
			_workingTimer.start();
			
			Logger.message(workerObject.currTask.toString(), "", LogLevel.Debug, LogModule.Controller);

			ResourceManager.instance.startTask(workerObject.currTask.job.id, workerObject.storeObject.storeObject.storeId.storeId, workerObject.currTask.id);
			
			SoundManager.instance.playEvent(workerObject.storeObject.storeObject.object.objectId.id);
			
			dispatchEvent(new WorkerClientEvent(WorkerClientEvent.WorkStarted));
			
			return true;
		}
		
		public function cancelTask() : void
		{
			Logger.message("Task cancled.", TAG, LogLevel.Debug, LogModule.Controller);
			
			_workingTimer.stop();
			
			ResourceManager.instance.cancelTask(workerObject.currTask.id);
			
			workerObject.state = WorkerEntityState.NeedWork;
			workerObject.currTask = null;
			
			dispatchEvent(new WorkerClientEvent(WorkerClientEvent.UnManured));
			
			dispatchEvent(new WorkerClientEvent(WorkerClientEvent.WorkAccepted));
		}
		
		public function acceptWork() : void
		{
			Logger.message("Accepting work.", TAG, LogLevel.Debug, LogModule.Controller);
			
			if (workerObject.state != WorkerEntityState.WorkDone)
				return;
			
			workerObject.state = WorkerEntityState.NeedWork;
			
			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			var csjob : JobData = currSkillJob(workerObject.currTask.task);
			
			var gives : GiveData;
			
			if (workerObject.currTask.manured)
				for each (gives in csjob.manured.give)
				{
					wCon.addAmount(gives.currency.type, gives.amount);
				}
			else
				for each (gives in csjob.gives)
				{
					wCon.addAmount(gives.currency.type, gives.amount);
				}
			
			for each (var result : ResultData in csjob.result)
			{
				if (result.type == ResultTypes.Skill)
				{
					for each (var skill : SkillData in (workerObject.mapObject.storeObject.object as WorkerObjectData).skills)
					{
						if (skill.id == result.skill.id)
						{
							workerObject.currSkill = skill;
							
							dispatchEvent(new WorkerClientEvent(WorkerClientEvent.SkillUp));
						}
					}
				}
			}
			
			dispatchEvent(new WorkerClientEvent(WorkerClientEvent.UnManured));
			
			ResourceManager.instance.removeTask(workerObject.currTask);
			ResourceManager.instance.confirmJob(workerObject.currTask.id);
			
			workerObject.currTask = null;
			
			dispatchEvent(new WorkerClientEvent(WorkerClientEvent.WorkAccepted));
		}
		
		public function manure() : void
		{
			if (workerObject.currTask != null)
			{
				if (!workerObject.currTask.complete && !workerObject.currTask.manured)
				{
					workerObject.currTask.manured = true;
					
					var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
					var csJob : JobData = currSkillJob(workerObject.currTask.task);
					
					for each (var give : GiveData in csJob.ferilizer.give)
					{
						wCon.addAmount(give.currency.type, give.amount);
					}
					
					SoundManager.instance.playEvent(SoundEvents.Manure);
					dispatchEvent(new WorkerClientEvent(WorkerClientEvent.Manured));
					
					ResourceManager.instance.fertilizer(workerObject.currTask.id);
				}
			}
		}
		
		public override function update():void
		{
			applyEntity();
			
			super.update();
		}
		
		public function get workerObject() : WorkerEntityObject
		{
			return entityObj as WorkerEntityObject;
		}
	}
}