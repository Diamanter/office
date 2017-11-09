package com.sigma.socialgame.controller.quest
{
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.quest.lock.QuestLocks;
	import com.sigma.socialgame.controller.quest.objects.QuestObject;
	import com.sigma.socialgame.controller.wallet.WalletController;
	import com.sigma.socialgame.events.controller.QuestControllerEvent;
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.object.task.GiveData;
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;
	
	import flash.utils.Dictionary;
	
	public class QuestController extends Controller
	{
		private var _quests : Vector.<QuestObject>;
		
		private var _questLocks : QuestLocks;
		
		public function QuestController()
		{
			super(ControllerNames.QuestController);
		}
		
		public override function init():void
		{
			_quests = new Vector.<QuestObject>();
			_questLocks = new QuestLocks();
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.QuestAdded, onQuestAdded);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.QuestChanged, onQuestChanged);
			
			dispatchEvent(new QuestControllerEvent(QuestControllerEvent.Inited));
		}
		
		public override function start():void
		{
			for each (var qd : CurrQuestData in ResourceManager.instance.quests)
			{
				_quests.push(QuestFactory.createQuestObject(qd));
			}
			
			dispatchEvent(new QuestControllerEvent(QuestControllerEvent.Started));
		}
		
		protected function findQuestObjectByData(qd_ : CurrQuestData) : QuestObject
		{
			for each (var quest : QuestObject in _quests)
			{
				if (quest.questData.id == qd_.id)
					return quest;
			}
			
			return null;
		}
		
		public function confirmQuest(qo : QuestObject) : void
		{
			_quests.splice(_quests.indexOf(qo), 1);

			var wCon : WalletController = ControllerManager.instance.getController(ControllerNames.WalletController) as WalletController;
			
			for each (var give : GiveData in qo.questData.data.gives)
			{
				wCon.addAmount(give.currency.type, give.amount);
			}
		
			var qcEvent : QuestControllerEvent = new QuestControllerEvent(QuestControllerEvent.QuestConfirmed);
			qcEvent.quest = qo;
			dispatchEvent(qcEvent);
			
			ResourceManager.instance.confirmQuest(qo.questData.id);
			
			checkDone();
			
			_questLocks.checkLock();
		}
		
		public function onQuestChanged(e : ResourceSynchronizerEvent) : void
		{
			checkDone();
		}
		
		public function checkLock() : void
		{
			_questLocks.checkLock();	
		}
		
		public function checkDone() : void
		{
			for each (var quest : QuestObject in _quests)
			{
				if (quest.questData.done)
				{
					var qcEvent : QuestControllerEvent = new QuestControllerEvent(QuestControllerEvent.QuetsDone);
					qcEvent.quest = quest;
					dispatchEvent(qcEvent);
					
					return;
				}
			}
		}
		
		public function onQuestAdded(e : ResourceSynchronizerEvent) : void
		{
			var newQuest : QuestObject = QuestFactory.createQuestObject(e.quest); 
			
			_quests.push(newQuest);
			
			var qcEvent : QuestControllerEvent = new QuestControllerEvent(QuestControllerEvent.QuestAdded);
			qcEvent.quest = newQuest;
			dispatchEvent(qcEvent);
			
			_questLocks.checkLock();
		}
		
		public function get quests():Vector.<QuestObject>
		{
			return _quests;
		}
	}
}