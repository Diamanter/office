package com.sigma.socialgame.view.gui.components.task
{
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.events.view.gui.TaskEvent;
	import com.sigma.socialgame.model.objects.config.object.WorkerObjectData;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarStartJobTask;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarTaskManager;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.gui.components.help.HelpCaseType;
	import com.sigma.socialgame.view.gui.components.help.HelpManager;
	import com.sigma.socialgame.view.gui.components.quest.QuestBar;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TaskChoice extends Sprite
	{
		private var _skin : MovieClip;
		
		private var _workerEntity : WorkerEntity;
		
		private var _currScreenInd : int;
		private var _currScreen : TaskScreen;
		private var _screens : Vector.<TaskScreen>;
		
		private static var _instance : TaskChoice
		
		public function TaskChoice()
		{
			super();
			
			_instance = this;
			
			var clazz : Class = SkinManager.instance.getSkin(GuiIds.TaskChoice);
			
			if (clazz != null)
			{
				_skin = new clazz();
				
				addChild(_skin);
				
				closeButton.gotoAndStop(1);
				leftButton.gotoAndStop(1);
				rightButton.gotoAndStop(1);
				helpButton.gotoAndStop(1);
				
				closeButton.addEventListener(MouseEvent.CLICK, onCloseMouseEvent);
				closeButton.addEventListener(MouseEvent.MOUSE_OVER, onCloseMouseEvent);
				closeButton.addEventListener(MouseEvent.MOUSE_OUT, onCloseMouseEvent);
				
				helpButton.addEventListener(MouseEvent.CLICK, onHelpMouseEvent);
				helpButton.addEventListener(MouseEvent.MOUSE_OVER, onHelpMouseEvent);
				helpButton.addEventListener(MouseEvent.MOUSE_OUT, onHelpMouseEvent);
				
				leftButton.addEventListener(MouseEvent.CLICK, onLeftMouseEvent);
				leftButton.addEventListener(MouseEvent.MOUSE_OVER, onLeftMouseEvent);
				leftButton.addEventListener(MouseEvent.MOUSE_OUT, onLeftMouseEvent);
				
				rightButton.addEventListener(MouseEvent.CLICK, onRightMouseEvent);
				rightButton.addEventListener(MouseEvent.MOUSE_OVER, onRightMouseEvent);
				rightButton.addEventListener(MouseEvent.MOUSE_OUT, onRightMouseEvent);
			}
		}
		
		public override function set visible(value:Boolean):void
		{
			super.visible = value;
			
			if (visible)
				GuiManager.instance.windowOpened(this);
			else 
				GuiManager.instance.windowClosed(this);
		}
		
		protected function onHelpMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					HelpManager.instance.showHelpCase(HelpCaseType.TaskChoiseHelp);
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					helpButton.gotoAndStop(1);
					break;
				
				case MouseEvent.MOUSE_OVER:
					helpButton.gotoAndStop(2);
					break;
			}
		}
		
		protected var _lockFire : Boolean = false;
		
		public function lockFire() : void
		{
			_lockFire = true;
		}
		
		public function unlockFire() : void
		{
			_lockFire = false;
		}
		
		protected function onCloseMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					GuiManager.instance.closeTaskChoise();
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					closeButton.gotoAndStop(1);
					break;
				
				case MouseEvent.MOUSE_OVER:
					closeButton.gotoAndStop(2);
					break;
			}
		}
		
		protected function onLeftMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					if (_currScreenInd - 1 >= 0)
					{
						_currScreenInd--;
						
						_currScreen.visible = false;
						
						_currScreen = _screens[_currScreenInd];
						
						_currScreen.visible = true;
					}
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					if (canLeft)
						leftButton.gotoAndStop(1);
					break;
				
				case MouseEvent.MOUSE_OVER:
					if (canLeft)
						leftButton.gotoAndStop(2);
					break;
			}
			
			checkLiftRight();
		}
		
		protected function onRightMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					
					if (_currScreenInd + 1 < _screens.length)
					{
						_currScreenInd++;
						
						_currScreen.visible = false;
						
						_currScreen = _screens[_currScreenInd];
						
						_currScreen.visible = true;
					}
					
					break;
				
				case MouseEvent.MOUSE_OUT:
					if (canRight)
						rightButton.gotoAndStop(1);
					break;
				
				case MouseEvent.MOUSE_OVER:
					if (canRight)
						rightButton.gotoAndStop(2);
					break;
			}
			
			checkLiftRight();
		}
		
		public function set workerEntity(workerEnt_ : WorkerEntity) : void
		{
			_workerEntity = workerEnt_;
			
			applyWorker();
		}
		
		protected function applyWorker() : void
		{
			var tasks : Vector.<TaskData> = (_workerEntity.workerClient.workerObject.mapObject.storeObject.object as WorkerObjectData).tasks;
			
			var taskNum : int = tasks.length;
			
			if (_screens != null)
				for each (var screen : TaskScreen in _screens)
				{
					removeChild(screen);
				}
			
			_screens = new Vector.<TaskScreen>();
			
			var i : int = 0;
			var j : int = 0;
			
			_currScreenInd = 0;
			
			var newTask : Task;
			
			for each (var task : TaskData in tasks)
			{
				var newJob : JobData = _workerEntity.workerClient.currSkillJob(task);
				
				if (newJob == null)
					continue;
				
				if (j == 0)
				{
					_screens[i] = new TaskScreen();
					
					addChild(_screens[i]);
					
					_screens[i].x += 75;
					_screens[i].y += 25;
					
					if (i > 0)
						_screens[i].visible = false;
					else
						_currScreen = _screens[i];
				}
				
				newTask = new Task();
				
				newTask.addEventListener(MouseEvent.CLICK, onTaskMouseEvent);
				newTask.addEventListener(TaskEvent.Unlock, onTaskUnlock);
				
				newTask.task = task;
				newTask.job = newJob;
				
				if (_workerEntity.workerClient.unlocked(task))
					newTask.unlocked();
				else
					newTask.locked(_workerEntity.workerClient.canUnlock(task));
				
				_screens[i].addTask(newTask);
				
				j++;
				
				if (j >= TaskScreen._height * TaskScreen._width)
				{
					j = 0;
					i++;
				}
			}

			if (j == 0)
			{
				_screens[i] = new TaskScreen();
				
				addChild(_screens[i]);
				
				_screens[i].x += 75;
				_screens[i].y += 25;
				
				if (i > 0)
					_screens[i].visible = false;
				else
					_currScreen = _screens[i];
			}
			
			var fireTask : FireTask = new FireTask();
			
			fireTask.addEventListener(MouseEvent.CLICK, onFireTaskMouseEvent);
			
			_screens[i].addTask(fireTask);
			
			j++;
			
			if (j >= TaskScreen._height * TaskScreen._width)
			{
				j = 0;
				i++;
			}
			
			checkLiftRight();
		}
		
		protected function onConfirm(val_ : Boolean) : void
		{
			if (val_)
			{
				_workerEntity.sell();
				GuiManager.instance.closeTaskChoise();
			}
		}
		
		protected function onFireTaskMouseEvent(e : MouseEvent) : void
		{
			if (_lockFire)
			{
				QuestBar.instance.showFirstWindow();
				
				return;
			}
			
			var stringCase : StringCase = StringManager.instance.getCase(StringTypes.FireWorker);
			
			GuiManager.instance.showConfirm(stringCase.title, stringCase.message, onConfirm);
		}
		
		protected function onTaskUnlock(e : TaskEvent) : void
		{
			if (_workerEntity.workerClient.unlock(e.task.task))
				e.task.unlocked();
		}
		
		protected function onTaskMouseEvent(e : MouseEvent) : void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK:
					if (_workerEntity.workerClient.unlocked((e.currentTarget as Task).task))
					{
						PlayerAvatarTaskManager.addTask(
							new PlayerAvatarStartJobTask(
								null,
								new WayPoint(_workerEntity.cellX, _workerEntity.cellY, false),
								_workerEntity,
								(e.currentTarget as Task).task
							),
							true
						);
						GuiManager.instance.closeTaskChoise();
					}
					break;
			}
		}
		
		protected function checkLiftRight() : void
		{
			if (!canLeft)
				leftButton.gotoAndStop(3);
			else
				leftButton.gotoAndStop(1);
			
			if (!canRight)
				rightButton.gotoAndStop(3);
			else
				rightButton.gotoAndStop(1);
		}
		
		protected function get canLeft() : Boolean
		{
			return _currScreenInd - 1 >= 0;
		}
		
		protected function get canRight() : Boolean
		{
			return _currScreenInd + 1 < _screens.length;
		}
		
		private const _leftButton : String = "left";
		private const _rightButton : String = "right";
		private const _closeButton : String = "close";
		
		private const _helpButton : String = "Help";
		
		protected function get helpButton() : MovieClip
		{
			return _skin[_helpButton];
		}

		protected function get closeButton() : MovieClip
		{
			return _skin[_closeButton] as  MovieClip;
		}

		protected function get leftButton() : MovieClip
		{
			return _skin[_leftButton] as  MovieClip;
		}
		
		protected function get rightButton() : MovieClip
		{
			return _skin[_rightButton] as  MovieClip;
		}
		
		public static function get instance() : TaskChoice
		{
			return _instance;
		}
	}
}
import com.sigma.socialgame.view.gui.components.task.Task;

import flash.display.Sprite;

internal class TaskScreen extends Sprite
{
	public static const _width : int = 4;
	public static const _height : int = 2;
	
	private var _tasks : Vector.<Sprite>;
	
	public function TaskScreen()
	{
		_tasks = new Vector.<Sprite>;
	}
	
	public function addTask(task_ : Sprite) : void
	{
		if (_tasks.length == _width * _height)
		{
			return;
		}
		
		_tasks.push(task_);
		
		var taskX : int = (_tasks.length - 1) % _width;
		var taskY : int = (_tasks.length - 1) / _width;
		
		addChild(task_);
		
		task_.x = taskX * task_.width;
		task_.y = taskY * task_.height;
	}
}
