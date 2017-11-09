package com.sigma.socialgame.model
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.model.ResourceManagerEvent;
	import com.sigma.socialgame.events.model.common.SenderEvent;
	import com.sigma.socialgame.model.common.id.objectid.ObjectIdentifier;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.common.id.socialid.SocialIdFactory;
	import com.sigma.socialgame.model.common.id.socialid.SocialIdentifier;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdFactory;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.graphic.GraphicManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.model.objects.config.avatar.AvatarPart;
	import com.sigma.socialgame.model.objects.config.condition.ConditionData;
	import com.sigma.socialgame.model.objects.config.convert.ConvertData;
	import com.sigma.socialgame.model.objects.config.currency.CurrencyData;
	import com.sigma.socialgame.model.objects.config.expand.ExpandData;
	import com.sigma.socialgame.model.objects.config.graphic.ImageData;
	import com.sigma.socialgame.model.objects.config.graphic.SkinData;
	import com.sigma.socialgame.model.objects.config.level.LevelData;
	import com.sigma.socialgame.model.objects.config.money.MoneyData;
	import com.sigma.socialgame.model.objects.config.object.ObjectData;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.config.object.task.JobData;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.model.objects.config.quest.QuestData;
	import com.sigma.socialgame.model.objects.sync.avatar.CurrAvatarPart;
	import com.sigma.socialgame.model.objects.sync.friend.FriendData;
	import com.sigma.socialgame.model.objects.sync.gift.GiftData;
	import com.sigma.socialgame.model.objects.sync.id.ReservedIdObject;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.MapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.quest.CurrQuestData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.model.objects.sync.task.CurrTaskData;
	import com.sigma.socialgame.model.objects.sync.unlock.ExpandUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.JobUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.PriceUnlockedData;
	import com.sigma.socialgame.model.objects.sync.unlock.UnlockedData;
	import com.sigma.socialgame.model.objects.sync.wallet.AmountData;
	import com.sigma.socialgame.model.param.MusicState;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.model.param.QualityState;
	import com.sigma.socialgame.model.param.SoundState;
	import com.sigma.socialgame.model.server.Sender;
	import com.sigma.socialgame.model.server.packet.Packet;
	import com.sigma.socialgame.model.server.packet.PacketTypes;
	import com.sigma.socialgame.model.social.SocialNetwork;
	import com.sigma.socialgame.view.gui.GuiManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
//	import flashx.textLayout.tlf_internal;
	
//	import mx.controls.Alert;
	
	import org.osmf.layout.AbsoluteLayoutFacet;
	
	public class ResourceManager extends EventDispatcher
	{
		public static const TAG : String = "ResourceManager";
		
		private var _sender : Sender;

		private static var _instance : ResourceManager;
		
		private var _graphicManager : GraphicManager;
		
		private var _syncTimer : Timer;
		
// Config data
		
		private var _mySocId : SocialIdentifier;
		
		private var _objects : Vector.<ObjectData>;
		private var _skins : Vector.<SkinData>;
		private var _images : Vector.<ImageData>;
		private var _currencies : Vector.<CurrencyData>;
		private var _levels : Vector.<LevelData>;
		private var _levelsDictionary : Object;
		private var _avatarParts : Vector.<AvatarPart>;
		
		private var _conditions : Vector.<ConditionData>;
		
		private var _convert : Vector.<ConvertData>;
		
		private var _expands : Vector.<ExpandData>;
		
		private var _money : Vector.<MoneyData>;
		
// Sync data
		
		private var _syncTime : Date;
		private var _currTime : Date;
		
		private var _mapWidth : int;
		private var _mapHeight : int;
		
		private var _quests : Vector.<CurrQuestData>;
		
		private var _storeIds : Vector.<ReservedIdObject>;
		private var _takenStoreIds : Vector.<ReservedIdObject>;
		private var _taskIds : Vector.<ReservedIdObject>;
		private var _takenTaskIds : Vector.<ReservedIdObject>;
		
		private var _mapCells : Vector.<CellMapObjectData>;
		private var _mapWalls : Vector.<WallMapObjectData>;
		private var _store : Vector.<StoreObjectData>;
		private var _wallet : Vector.<AmountData>;
		private var _tasks : Vector.<CurrTaskData>;
		private var _unlocked : Vector.<UnlockedData>;
		
		private var _friends : Vector.<FriendData>;
		private var _currAvatarParts : Vector.<CurrAvatarPart>;
		private var _boughtAvatarParts : Vector.<CurrAvatarPart>;
		
		private var _gifts : Vector.<GiftData>;
		
		private var _myOffice : Boolean;
		private var _officeId : String;
		
		private var _donotSync : Boolean = false;
	
		private var _paramManager : ParamManager;
		
		private var _timeTimer : Timer;
		
		public function ResourceManager()
		{
			super();
			
			_instance = this;
			
			_sender = new Sender();
			
			_graphicManager = new GraphicManager();
			_paramManager = new ParamManager();
			
			_takenStoreIds = new Vector.<ReservedIdObject>();
			_takenTaskIds = new Vector.<ReservedIdObject>();
			
			_syncTimer = new Timer(1 * 60 * 1000);
			_syncTimer.addEventListener(TimerEvent.TIMER, onSyncTimer);
			
			_timeTimer = new Timer(1000);
			_timeTimer.addEventListener(TimerEvent.TIMER, onTimeTimer);
			
			_sender.addEventListener(SenderEvent.PacketRecieved, onPacket);
		}
		
		public function init() : void
		{
			Logger.message("Initializing ResourceManager.", TAG, LogLevel.Info, LogModule.Model);
			
			Logger.message("ResourceManager initialized.", TAG, LogLevel.Info, LogModule.Model);
		}
		
		protected function onPacket(e : SenderEvent) : void
		{
			switch (e.packet.type)
			{
				case PacketTypes.Init:
					initPacket(e.packet);
				break;
				
				case PacketTypes.Sync:
					syncPacket(e.packet);
				break;
				
				case PacketTypes.Auth:
					
				break;
				
				case PacketTypes.Info:
					infoPacket(e.packet);
				break;
				
				case PacketTypes.Quest:
					questPacket(e.packet);
					break;
			}
		}

		protected function questPacket(packet_ : Packet) : void
		{
			_loaded++;

/*			var quest : QuestData = ResourceFactory.readQuest(packet_, _objects, _currencies, _conditions);
			
			for each (var cq : CurrQuestData in _quests)
			{
				if (cq.type == quest.id)
				{
					cq.data = quest;
					
					break;
				}
			}
			
			if (_needLoad == _loaded)
				dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.QuestsUpdated));
*/		}
		
		protected function initPacket(packet_ : Packet) : void
		{
//			Logger.message(packet_.data.toXMLString(), TAG, LogLevel.Info, LogModule.Model);
			
			Logger.message("Configurating resources.", TAG, LogLevel.Info, LogModule.Model);
			
			_myOffice = true;
			
			_paramManager.addConfigParam(ResourceFactory.readConfigParam(packet_, ParamType.GuiURL), ParamType.GuiURL);
			_paramManager.addConfigParam(ResourceFactory.readConfigParam(packet_, ParamType.GiftNum), ParamType.GiftNum);
			_paramManager.addConfigParam(ResourceFactory.readConfigParam(packet_, ParamType.FertilizerNum), ParamType.FertilizerNum);
			
			_paramManager.addSyncParam(ResourceFactory.readSyncParam(packet_, ParamType.MusicState), ParamType.MusicState);
			_paramManager.addSyncParam(ResourceFactory.readSyncParam(packet_, ParamType.SoundState), ParamType.SoundState);
			_paramManager.addSyncParam(ResourceFactory.readSyncParam(packet_, ParamType.QualityState), ParamType.QualityState);
			
			if (packet_.session && _paramManager.getSyncParam(ParamType.MusicState) == null)
			{
				_paramManager.addSyncParam(MusicState.On, ParamType.MusicState);
				_sender.sendParamCommand(ParamType.MusicState, MusicState.On);
			}
			
			if (packet_.session && _paramManager.getSyncParam(ParamType.SoundState) == null)
			{
				_paramManager.addSyncParam(SoundState.On, ParamType.SoundState);
				_sender.sendParamCommand(ParamType.SoundState, SoundState.On);
			}
			
			if (packet_.session && _paramManager.getSyncParam(ParamType.QualityState) == null)
			{
				_paramManager.addSyncParam(QualityState.High, ParamType.QualityState);
				_sender.sendParamCommand(ParamType.QualityState, QualityState.High);
			}
			
			_skins = ResourceFactory.readSkins(packet_);
			_images = ResourceFactory.readImages(packet_, _skins);
			_currencies = ResourceFactory.readCurrencies(packet_);
			
			_money = ResourceFactory.readMoney(packet_, _currencies);
			
			_convert = ResourceFactory.readConverts(packet_, _currencies);
			
			_levels = ResourceFactory.readLevels(packet_, _currencies);
			makeLevelsDictionary();
			
			_conditions = ResourceFactory.readConditions(packet_, _currencies);
			_avatarParts = ResourceFactory.readAvatarParts(packet_, _conditions, _currencies);
			_expands = ResourceFactory.readExpands(packet_, _currencies, _conditions);
			_objects = ResourceFactory.readObjects(packet_, _currencies, _conditions);
			
			Logger.message("Resources configurated.", TAG, LogLevel.Info, LogModule.Model);
			Logger.message("Synchronizing resources.", TAG, LogLevel.Info, LogModule.Model);

			_quests = ResourceFactory.readCurrQuests(packet_, _objects, _currencies, _conditions);
			
			_storeIds = ResourceFactory.readStoreIds(packet_);
			_taskIds = ResourceFactory.readTaskIds(packet_);
			
 			_store = ResourceFactory.readStore(packet_, _objects);
			_tasks = ResourceFactory.readTasks(packet_, _store, _objects);
			_unlocked = ResourceFactory.readUnlocked(packet_, _objects);
			_wallet = ResourceFactory.readWallet(packet_, _currencies);
			_mapWalls = ResourceFactory.readWalls(packet_, _objects, _store);
			_mapCells = ResourceFactory.readCells(packet_, _objects, _store, _tasks);
			
			_friends = ResourceFactory.readFriends(packet_);
			_gifts = ResourceFactory.readGifts(packet_, _objects);
			
			_currTime = ResourceFactory.readTime(packet_);
			
			_timeTimer.start();
			_syncTime = new Date();
			
			_mapWidth = ResourceFactory.readMapWidth(packet_);
			_mapHeight = ResourceFactory.readMapHeigth(packet_);
			
			if (_storeIds.length < 15 || _storeIds.length > 15)
			{
				_sender.sendParamCommand(ParamType.ReserveObject, "15"); 
			}
			
 			_currAvatarParts = ResourceFactory.readCurrAvatarParts(packet_, _avatarParts);
			_boughtAvatarParts = ResourceFactory.readBoughtAvatarParts(packet_, _avatarParts);
			
			Logger.message("Resources synchronized.", TAG, LogLevel.Info, LogModule.Model);
			
			_graphicManager.init();
			
			_syncTimer.stop();
			_syncTimer.reset();
			_syncTimer.start();
			
			if (packet_.session && needUpdate())
			{
				addEventListener(ResourceManagerEvent.QuestsUpdated, onInitQuestUpdated);
			
				updateQuests();
			}
			else
				dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Started));
				
		}

		protected function onInitQuestUpdated(e : Event) : void
		{
			removeEventListener(ResourceManagerEvent.QuestsUpdated, onInitQuestUpdated);
			
			dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Started));
		}
		
		private var _needLoad : int;
		private var _loaded : int;
		
		protected function needUpdate() : Boolean
		{
			for each (var quest : CurrQuestData in _quests)
			{
				if (quest.data == null)
				{
					loadQuest(quest.type);
					
					return true;
				}
			}
			
			return false;
		}
		
		protected function updateQuests() : void
		{
			for each (var quest : CurrQuestData in _quests)
			{
				if (quest.data == null)
				{
					loadQuest(quest.type);
					
					_needLoad++;
				}
			}
		}
		
		public function sendParam(id_ : String, value_ : String) : void
		{
			_sender.sendParamCommand(id_, value_);
		}
		
		protected function loadQuest(id_ : int) : void
		{
			_sender.sendQuestCommand(id_);
		}
		
		protected function makeLevelsDictionary() : void
		{
			_levelsDictionary = new Object();
			
			for each (var level : LevelData in _levels)
			{
				_levelsDictionary[level.rank] = level;
			}
		}
		
		protected function syncPacket(packet_ : Packet) : void
		{
			if (_touch)
			{
				_touch = false;
				
				return;
			}
			
			if (ResourceFactory.isMyOffice(packet_))
			{
				var newQuests : Vector.<CurrQuestData>;
				
				newQuests = ResourceFactory.readCurrQuests(packet_, _objects, _currencies, _conditions);
				
				ResourceSynchronizer.syncQuests(_quests, newQuests);
				
				updateQuests();
				
				_storeIds = ResourceFactory.readStoreIds(packet_);
				_taskIds = ResourceFactory.readTaskIds(packet_);
					
				if (myOffice)
				{
					if (!_donotSync)
					{
						_donotSync = true;
					}
					else
						return;
				}
			}
			
			Logger.message("Synchronizing resources.", TAG, LogLevel.Info, LogModule.Model);
			
			var newStore : Vector.<StoreObjectData>;
			var newTasks : Vector.<CurrTaskData>;
			var newUnlocked : Vector.<UnlockedData>;
			var newWallet : Vector.<AmountData>;
			var newMapWalls : Vector.<WallMapObjectData>;
			var newMapCells : Vector.<CellMapObjectData>;
			
			var newAvatar : Vector.<CurrAvatarPart>;
			
			var newMapWidth : int;
			var newMapHeight : int;
			if (ResourceFactory.isMyOffice(packet_))
			{
				if (_myOffice)
				{
					newStore = ResourceFactory.readStore(packet_, _objects);
					newTasks = ResourceFactory.readTasks(packet_, newStore, _objects);
					newUnlocked = ResourceFactory.readUnlocked(packet_, _objects);
					newWallet = ResourceFactory.readWallet(packet_, _currencies);
					newMapWalls = ResourceFactory.readWalls(packet_, _objects, newStore);
					newMapCells = ResourceFactory.readCells(packet_, _objects, newStore, newTasks);
					
					newAvatar = _currAvatarParts;
					_currAvatarParts = ResourceFactory.readCurrAvatarParts(packet_, _avatarParts);
					
					newMapWidth = ResourceFactory.readMapWidth(packet_);
					newMapHeight = ResourceFactory.readMapHeigth(packet_);
			
					_currTime = ResourceFactory.readTime(packet_);
					_syncTime = new Date();
			
					_paramManager.addSyncParam(ResourceFactory.readSyncParam(packet_, ParamType.FertilizerNum), ParamType.FertilizerNum);
					
					//TODO: sync unlocked, tasks
					ResourceSynchronizer.syncData(_mapWidth, newMapWidth, _mapHeight, newMapHeight, _store, newStore, _tasks, newTasks, _wallet, newWallet, _mapCells, newMapCells, _mapWalls, newMapWalls, _unlocked, newUnlocked, newAvatar, _currAvatarParts);
					
					_mapWidth = newMapWidth;
					_mapHeight = newMapHeight;
					
					Logger.message("Resources synchronized.", TAG, LogLevel.Info, LogModule.Model); 
					
					_syncTimer.stop();
					_syncTimer.reset();
					_syncTimer.start();
					
					dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Synced));
				}
				else
				{
					if (!_needTogo)
					{
						return;
					}
					
					_store = ResourceFactory.readStore(packet_, _objects);
					_tasks = ResourceFactory.readTasks(packet_, _store, _objects);
					_unlocked = ResourceFactory.readUnlocked(packet_, _objects);
					_wallet = ResourceFactory.readWallet(packet_, _currencies);
					_mapWalls = ResourceFactory.readWalls(packet_, _objects, _store);
					_mapCells = ResourceFactory.readCells(packet_, _objects, _store, _tasks);
					
					_currAvatarParts = ResourceFactory.readCurrAvatarParts(packet_, _avatarParts);
					
					_friends = ResourceFactory.readFriends(packet_);
					
					_currTime = ResourceFactory.readTime(packet_);
					_syncTime = new Date();
					
					_mapWidth = ResourceFactory.readMapWidth(packet_);
					_mapHeight = ResourceFactory.readMapHeigth(packet_);
					
					Logger.message("Resources synchronized.", TAG, LogLevel.Info, LogModule.Model);
					
					_syncTimer.stop();
					_syncTimer.reset();
					_syncTimer.start();
					
					_myOffice = true;
					_needTogo = false;
					
					dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Reload));
				}
			}
			else
			{
				if (_myOffice)
				{
					if (!_needTogo)
					{
						return;
					}
					
					_store = ResourceFactory.readStore(packet_, _objects);
					_tasks = ResourceFactory.readTasks(packet_, _store, _objects);
//					_unlocked = ResourceFactory.readUnlocked(packet_, _objects);
//					_wallet = ResourceFactory.readWallet(packet_, _currencies);
					_mapWalls = ResourceFactory.readWalls(packet_, _objects, _store);
					_mapCells = ResourceFactory.readCells(packet_, _objects, _store, _tasks);
					
//					_friends = ResourceFactory.readFriends(packet_);
					
					_currTime = ResourceFactory.readTime(packet_);
					_syncTime = new Date();
					
					_mapWidth = ResourceFactory.readMapWidth(packet_);
					_mapHeight = ResourceFactory.readMapHeigth(packet_);
					
					Logger.message("Resources synchronized.", TAG, LogLevel.Info, LogModule.Model);
					
					_syncTimer.stop();
					_syncTimer.reset();
					_syncTimer.start();
					
					_myOffice = false;
					_needTogo = false;
					
					_officeId = ResourceFactory.readOfficeId(packet_);
					
					dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Reload));
				}
				else
				{
					var newOffid : String = ResourceFactory.readOfficeId(packet_);
					
					if (_officeId == newOffid && false)
					{
						newStore = ResourceFactory.readStore(packet_, _objects);
						newTasks = ResourceFactory.readTasks(packet_, newStore, _objects);
						newUnlocked = ResourceFactory.readUnlocked(packet_, _objects);
						newWallet = ResourceFactory.readWallet(packet_, _currencies);
						newMapWalls = ResourceFactory.readWalls(packet_, _objects, newStore);
						newMapCells = ResourceFactory.readCells(packet_, _objects, newStore, newTasks);
						
						newMapWidth = ResourceFactory.readMapWidth(packet_);
						newMapHeight = ResourceFactory.readMapHeigth(packet_);
						
						_currTime = ResourceFactory.readTime(packet_);
						_syncTime = new Date();
						
						//TODO: sync unlocked, tasks
						ResourceSynchronizer.syncData(_mapWidth, newMapWidth, _mapHeight, newMapHeight, _store, newStore, _tasks, newTasks, _wallet, newWallet, _mapCells, newMapCells, _mapWalls, newMapWalls, _unlocked, newUnlocked, _currAvatarParts, newAvatar);
						
						_mapWidth = newMapWidth;
						_mapHeight = newMapHeight;
						
						Logger.message("Resources synchronized.", TAG, LogLevel.Info, LogModule.Model); 
						
						_syncTimer.stop();
						_syncTimer.reset();
						_syncTimer.start();
						
						dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Synced));
					}
					else
					{
						if (!_needTogo)
						{
							return;
						}
						
						_store = ResourceFactory.readStore(packet_, _objects);
						_tasks = ResourceFactory.readTasks(packet_, _store, _objects);
						_unlocked = ResourceFactory.readUnlocked(packet_, _objects);
						_wallet = ResourceFactory.readWallet(packet_, _currencies);
						_mapWalls = ResourceFactory.readWalls(packet_, _objects, _store);
						_mapCells = ResourceFactory.readCells(packet_, _objects, _store, _tasks);
						
//						_friends = ResourceFactory.readFriends(packet_);
						
						_currTime = ResourceFactory.readTime(packet_);
						_syncTime = new Date();
						
						_mapWidth = ResourceFactory.readMapWidth(packet_);
						_mapHeight = ResourceFactory.readMapHeigth(packet_);
						
						Logger.message("Resources synchronized.", TAG, LogLevel.Info, LogModule.Model);
						
						_syncTimer.stop();
						_syncTimer.reset();
						_syncTimer.start();
						
						_myOffice = false;
						_needTogo = false;
						
						_officeId = ResourceFactory.readOfficeId(packet_);
						
						dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Reload));
					}
				}
			}
		}

		private var _needTogo : Boolean = false;
		
		public function returnToOffice() : void
		{
			_needTogo = true;
			
			dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Reloading));
			
			_sender.sendSyncCommand();
		}
		
		public function gotoOffice(id_ : String) : void
		{
			_needTogo = true;
			
			dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Reloading));
			
			_sender.sendSyncCommand(id_);
		}
		
		protected function infoPacket(packet_ : Packet) : void
		{
//			navigateToURL(new URLRequest("javascript:window.location.reload();"));
			
			//Alert.show(packet_.toString());
			
			if (GuiManager.instance.inited)
				GuiManager.instance.errorWindow();
			
			Logger.message("Info packet: " + packet_.toString(), TAG, LogLevel.Error, LogModule.Model);
			
			//if (packet_.data.code > 0)
			//	_sender.sendSyncCommand();
		}
		
		public function changeDimension(width_ : int, height_ : int) : void
		{
			_mapWidth = width_;
			_mapHeight = height_;
		}
		
		public function addCurrTask(storeObject_ : StoreObjectData, task_ : TaskData, job_ : JobData) : CurrTaskData
		{
			var newCurrTask : CurrTaskData = new CurrTaskData();
			  
			newCurrTask.task = task_;
			newCurrTask.time = currTime.getTime() + job_.period * 1000;
			newCurrTask.job = job_;
			newCurrTask.storeObject = storeObject_;			
			  
			newCurrTask.complete = false;
			  
			newCurrTask.id = int(nextTaskId.id);
			  
			_tasks.push(newCurrTask);
			  
			return newCurrTask;
		}
		
		public function convertCurr(id_ : int) : void
		{
			_sender.sendConvertCommand(id_);
		}
		
		public function addFriend(id_ : String) : void
		{
			var newFriend : FriendData = new FriendData();
			
			newFriend.sociId = SocialIdFactory.createSocialId(id_);
			
			_friends.push(newFriend);
			
			//_donotSync = true;
			
			_sender.sendFriendCommand(id_);
		}
		
		public function removeFriend(fd_ : FriendData) : void
		{
			_friends.splice(_friends.indexOf(fd_), 1);
			
			//_donotSync = true;
			
			_sender.sendUnFriendCommand(fd_.sociId.id);
		}
		
		public function startTask(job_ : int, worker_ : int, backId_ : int) : void
		{
			_sender.sendTaskCommand(job_, worker_, backId_);
		}
		
		public function cancelTask(currTaskId_ : int) : void
		{
			_sender.sendCancelCommand(currTaskId_);
			
			var length : int = _tasks.length;
			for (var i : int = 0; i < length; ++i)
			{
				if (_tasks[i].id == currTaskId_)
				{
					_tasks.splice(i, 1);
					break;
				}
			}
		}
		
		public function moveCell(storeId_ : StoreIdentifier, x_ : int, y_ : int) : void
		{
			_sender.sendMoveCellCommand(storeId_, x_, y_);
		}
		
		public function moveToStore(storeId_ : StoreIdentifier) : void
		{
			_sender.sendMoveCellCommand(storeId_, -1, 0);
		}
		
		public function moveWall(storeId_ : StoreIdentifier, x_ : int, wall_ : int) : void
		{
			_sender.sendMoveWallCommand(storeId_, x_, wall_);
		}

		public function rotate(storeId_ : StoreIdentifier, rot_ : int) : void
		{
			_sender.sendRotateCommand(storeId_, rot_);
		}

		public function sell(storeId_ : StoreIdentifier, curr_ : String) : void
		{
			_sender.sendSellCommand(storeId_, curr_);	
		}
		
		public function fertilizer(job_ : int) : void
		{
			//_donotSync = true;
			
			_sender.sendFertilizerCommand(job_);
		}
		
		public function confirmGift(gift_ : int, backid_ : int) : void
		{
			// TODO: move from gifts to store
			
			_sender.sendConfirmCommand(-1, gift_, -1, backid_);
		}
		
		public function confirmJob(job_ : int) : void
		{
			_sender.sendConfirmCommand(job_, -1, -1, -1);
		}
		
		public function confirmQuest(quest_ : int) : void
		{
			for each (var cquest : CurrQuestData in _quests)
			{
				if (cquest.id == quest_)
				{
					_quests.splice(_quests.indexOf(cquest), 1);
					
					break;
				}
			}
			
			_sender.sendConfirmCommand(-1, -1, quest_, -1);
		}
		
		public function avatarPart(partId_ : int) : void
		{
			var neededPart : AvatarPart = null;
			for each (var toCheck : AvatarPart in _avatarParts)
			{
				if (toCheck.id == partId_) 
				{
					neededPart = toCheck;
					break;
				} 
			}
			
			if (neededPart == null) return;
			
			var length : int = _currAvatarParts.length;
			//var oldPart : AvatarPart = null;
			
			for (var i : int = 0; i < length; ++i)
			{
				if (_currAvatarParts[i].part.type == neededPart.type)
				{
					_currAvatarParts[i].part = neededPart;
					
					_sender.sendAvatarCommand(partId_);
					
					break;
				}
			}
			var found : Boolean = false;
			
			for each (var part : CurrAvatarPart in _boughtAvatarParts)
			{
				if (part.part.id == neededPart.id)
				{
					found = true;
					
					break;
				}
			}
			
			if (!found)
			{
				var newPart : CurrAvatarPart = new CurrAvatarPart();
				
				newPart.part = neededPart;
				
				_boughtAvatarParts.push(newPart);
			}
		}
		
		public function sendGift(socId_ : String, objId_ : ObjectIdentifier, curr_ : String) : void
		{
			//_donotSync = true;
			_sender.sendGiftCommand(socId_, objId_, curr_);
		}
		
		public function removeTask(currtask_ : CurrTaskData) : void
		{
			_tasks.splice(_tasks.indexOf(currtask_), 1);
		}

		public function buyMoveCell(objId_ : ObjectIdentifier, curr_ : String, backId_ : int, x : int, y : int, skill : int = 0) : void
		{
			_sender.sendBuyMoveCellCommand(objId_, curr_, backId_, x, y, skill);
		}
		
		public function buyMoveWall(objId_ : ObjectIdentifier, curr_ : String, backId_ : int, x : int, wall : int) : void
		{
			_sender.sendBuyMoveWallCommand(objId_, curr_, backId_, x, wall);
		}
		
		public function buy(objId_ : ObjectIdentifier, curr_ : String, backId_ : int, skill : int = 0) : void
		{
			_sender.sendBuyCommand(objId_, curr_, backId_, skill);
		}
		
		protected function onSyncTimer(e : TimerEvent) : void
		{
			syncGame();
		}
		
		private var _touch : Boolean;
		
		public function syncGame(force:Boolean=false) : void
		{
//			dispatchEvent(new ResourceManagerEvent(ResourceManagerEvent.Reloading));
			
			_touch = true;
			
			if (force) _sender._server = true;
			
			_sender.sendSyncCommand();
		}
		
		public function expandOffice(expandId_ : int, curr_ : String) : void
		{
			_donotSync = false;
			_sender.sendExpandCommand(expandId_, curr_);
		}
		
		public function startGame() : void
		{
			Logger.message("Starting game.", TAG, LogLevel.Info, LogModule.Model);

			_mySocId = SocialIdFactory.createSocialId(SocialNetwork.instance.me.uid);
			
			_sender.sendStartCommand(_mySocId);
		}
		
		public function finishGame() : void
		{
			Logger.message("Finishing game.", TAG, LogLevel.Info, LogModule.Model);
			
			_sender.sendFinishCommand();
		}
		
		public function getSWFLib(image_ : String, callBack_ : Function) : void
		{
			_graphicManager.getSWFLib(image_, callBack_);
		}
		
		public function getGraphicClazz(className_ : String, swfLib_ : SWFLib) : Class
		{
			return _graphicManager.getClass(className_, swfLib_);
		}
		
		private function get nextStoreId() : ReservedIdObject
		{
			var found : Boolean;
			var id : ReservedIdObject;
			var takenId : ReservedIdObject;
			
			do 
			{
				found = true;
				
				id = _storeIds.shift(); 
				
				for each (takenId in _takenStoreIds)
				{
					if (id.id == takenId.id)
					{
						found = false;
						break;
					}
				}
			}
			while (!found);
			
			_takenStoreIds.push(id);
			
			return id;
		}
		
		private function get nextTaskId() : ReservedIdObject
		{
			var found : Boolean;
			var id : ReservedIdObject;
			var takenId : ReservedIdObject;
			
			do 
			{
				found = true;
				
				id = _taskIds.shift(); 
				if (id==null) return new ReservedIdObject();
				
				for each (takenId in _takenTaskIds)
				{
					if (id.id == takenId.id)
					{
						found = false;
						break;
					}
				}
			}
			while (!found);
			
			_takenTaskIds.push(id);
			
			return id;
		}
		
		private var _sId : int = -1;
		
		public function addStoreObject(object_ : ObjectData, skill_ : SkillData) : StoreObjectData
		{
			var newSO : StoreObjectData;
			
			if (object_.type == ObjectTypes.Worker)
			{
				newSO = new WorkerStoreObjectData();
				newSO.storeId = StoreIdFactory.createStoreId(int(nextStoreId.id));
				newSO.object = object_;
				(newSO as WorkerStoreObjectData).currSkill = skill_;
			}
			else
			{
				newSO = new StoreObjectData();
				newSO.storeId = StoreIdFactory.createStoreId(int(nextStoreId.id));
				newSO.object = object_;
			}
			
			_store.push(newSO);
			
			return newSO;
		}
		
		public function addUnlockedJob(currency_ : String, job_ : JobData) : void
		{
			var newUnlocked : JobUnlockedData = new JobUnlockedData();
			
			newUnlocked.job = job_;
			
			_unlocked.push(newUnlocked);
			
			_sender.sendUnlockCommand(currency_, job_.id, -1, null, -1);
			//send
		}
		
		public function addUnlockedPrice(currency_ : String, object_ : ObjectData, skill_ : SkillData = null) : void
		{
			var newUnlocked : PriceUnlockedData = new PriceUnlockedData();
			
			newUnlocked.object = object_;
			newUnlocked.skill = skill_;
			
			_unlocked.push(newUnlocked);
			
			_sender.sendUnlockCommand(currency_, -1, -1, object_.objectId.id, (skill_ == null ? -1 : skill_.id));
			//send
		}

		public function addUnlockedExpand(currency_ : String, expand_ : ExpandData) : void
		{
			var newUnlocked : ExpandUnlockedData = new ExpandUnlockedData();
			
			newUnlocked.expand = expand_;
			
			_unlocked.push(newUnlocked);
			
			_sender.sendUnlockCommand(currency_, -1, expand_.id, null, -1);
			//send
		}
		
		public function addCellObject(storeObject_ : StoreObjectData) : CellMapObjectData
		{
			var newCellMap : CellMapObjectData = ResourceFactory.createCellMapObjectData(storeObject_);
			
			_mapCells.push(newCellMap);
			
			return newCellMap;
		}
		
		public function addWallObject(storeObject_ : StoreObjectData) : WallMapObjectData
		{
			var newWallMap : WallMapObjectData = ResourceFactory.createWallMapObjectData(storeObject_);
			
			_mapWalls.push(newWallMap);
			
			return newWallMap;
		}
		
		public function removeCellObject(mod : MapObjectData) : void
		{
			_mapCells.splice(_mapCells.indexOf(mod), 1);
		}
		
		public function removeWallObject(mod : MapObjectData) : void
		{
			_mapWalls.splice(_mapWalls.indexOf(mod), 1);
		}
		
		public static function get instance() : ResourceManager
		{
			return _instance;
		}
		
		private function onTimeTimer(e : TimerEvent) : void
		{
			_currTime.setTime(_currTime.getTime() + 1000);
		}
		
		public function get currTime() : Date
		{
			return _currTime;
			
/*			var curr : Date = new Date();

			var newTime : Date = new Date();
			newTime.setTime(_currTime.getTime() + curr.getTime() - _syncTime.getTime());
			
			return newTime;
*/		}

		public function get mapCells():Vector.<CellMapObjectData>
		{
			return _mapCells;
		}

		public function get mapWalls():Vector.<WallMapObjectData>
		{
			//trace("get w", _mapWalls.length)
			return _mapWalls;
		}
		
		public function get objects():Vector.<ObjectData>
		{
			//trace("get o", _objects.length)
			return _objects;
		}

		public function get store():Vector.<StoreObjectData>
		{
			return _store;
		}

		public function get wallet():Vector.<AmountData>
		{
			return _wallet;
		}

		public function get mapWidth():int
		{
			return _mapWidth;
		}

		public function get mapHeight():int
		{
			return _mapHeight;
		}

		public function get skins():Vector.<SkinData>
		{
			return _skins;
		}

		public function get images():Vector.<ImageData>
		{
			return _images;
		}

		public function get levels():Vector.<LevelData>
		{
			return _levels;
		}

		public function get levelsDictionary(): Object
		{
			return _levelsDictionary;
		}
		
		public function get avatarParts():Vector.<AvatarPart>
		{
			return _avatarParts;
		}
		
/*		public function get partsDictionary() : Object
		{
			return _partsDictionary;
		}
*/		
		public function get unlocked():Vector.<UnlockedData>
		{
			return _unlocked;
		}

/*		public function get avatarState():AvatarState
		{
			return _avatarState;
		}
*/		
		public function toSyncString():String
		{
			var str : String = "";
			
			str += "Unlocked:\n";
			
			for each (var unlock : UnlockedData in _unlocked)
			{
//				str += "\tType: " + unlock.object.objectId.id + "\n";
			}
			
			str += "Tasks:\n";
			
			for each (var task : CurrTaskData in _tasks)
			{
				str += "\tType: " + task.storeObject.object.objectId.id +   
					   " StoreId: " + task.storeObject.storeId.storeId +  
					   " TaskId: " + task.task.id + "\n"; 
//					   " CurrJobId" + task.task.currSkillJob.level + "\n"; 
			}
			
			str += "Wallet:\n";
			
			for each (var wallet : AmountData in _wallet)
			{
				str += "\tCurr: " + wallet.currency.type + " Amount: " + wallet.amount + "\n";
			}
			
			str += "Store:\n";
			
			for each (var store : StoreObjectData in _store)
			{
				str += "\tType: " + store.object.objectId.id + 
					   " StoreId: " + store.storeId.storeId + "\n"; 
			}
			
			str += "Walls:\n";
			
			for each (var wall : WallMapObjectData in _mapWalls)
			{
				str += "\tType: " + wall.storeObject.object.objectId.id + 
					   " StoreId: " + wall.storeObject.storeId.storeId + 
					   " Wall,X: " + wall.wall + " " + wall.x + "\n"; 
			}
			
			str += "Cells:\n";
			
			for each (var cell : CellMapObjectData in _mapCells)
			{
				str += "\tType: " + cell.storeObject.object.objectId.id + 
					   " StoreId: " + cell.storeObject.storeId.storeId +
					   " X,Y: " + cell.x + " " + cell.y +
					   " Rot: " + cell.rotation + "\n";
			}
			
			return str;
		}

		public function get expands():Vector.<ExpandData>
		{
			return _expands;
		}

		public function get friends():Vector.<FriendData>
		{
			return _friends;
		}

		public function get myOffice():Boolean
		{
			return _myOffice;
		}

		public function set myOffice(value:Boolean):void
		{
			_myOffice = value;
		}

		public function get currAvatarParts():Vector.<CurrAvatarPart>
		{
			return _currAvatarParts;
		}

		public function get gifts():Vector.<GiftData>
		{
			return _gifts;
		}

		public function get quests():Vector.<CurrQuestData>
		{
			return _quests;
		}

		public function get convert():Vector.<ConvertData>
		{
			return _convert;
		}

		public function get money():Vector.<MoneyData>
		{
			return _money;
		}

		public function get officeId():String
		{
			return _officeId;
		}
		
		public function get storeIds():Vector.<ReservedIdObject>
		{
			return _storeIds;
		}

		public function get taskIds():Vector.<ReservedIdObject>
		{
			return _taskIds;
		}

		public function get boughtAvatarParts():Vector.<CurrAvatarPart>
		{
			return _boughtAvatarParts;
		}
	}
}