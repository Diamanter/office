package com.sigma.socialgame.view.game.map.objects
{
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.entity.clients.EntityClient;
	import com.sigma.socialgame.controller.entity.clients.WorkerEntityClient;
	import com.sigma.socialgame.controller.entity.objects.WorkerEntityState;
	import com.sigma.socialgame.controller.friends.FriendsContoller;
	import com.sigma.socialgame.controller.shop.clients.ShopClient;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.controller.map.clients.WorkerClient;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.events.controller.EntityClientEvent;
	import com.sigma.socialgame.events.controller.MapClientEvent;
	import com.sigma.socialgame.events.controller.WorkerClientEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.events.view.gui.GuiManagerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.objects.config.object.task.TaskData;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.avatar.Avatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.Sex;
	import com.sigma.socialgame.view.game.map.objects.avatar.SexChooser;
	import com.sigma.socialgame.view.game.map.objects.avatar.WorkerAvatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.WorkerAvatarState;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarConfirmJobTask;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarManureTask;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarTaskManager;
	import com.sigma.socialgame.view.game.map.objects.graphic.CellHighlighter;
	import com.sigma.socialgame.view.game.map.objects.graphic.GraphicLoader;
	import com.sigma.socialgame.view.game.map.objects.graphic.WorkerGraphicLoader;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.components.WorkerState;
	import com.sigma.socialgame.view.gui.string.StringCase;
	import com.sigma.socialgame.view.gui.string.StringManager;
	import com.sigma.socialgame.view.gui.string.StringTypes;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.FragmentFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.BlurFilter;
	import starling.filters.BloomFilter;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class WorkerEntity extends CellEntity
	{
		public const WorkerStuffHeight : int = 10;
		
		private const _tableHeight : int = WorkspaceEntity.TableHeight;
		//private const _highlightOffset : int = 50;
		
		private var _stateImage : WorkerState;
		private var _myTaskInfo : Boolean = false;
		
		private var _table : WorkspaceEntity;
		private var _avatar : WorkerAvatar;
		
		public var shopClient : ShopClient;
				
		public function WorkerEntity()
		{
			super();
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
		}
		
		protected function onSkillUp(e : WorkerClientEvent) : void
		{
			removeChild(graphicLoader);
			
			graphicLoader = new WorkerGraphicLoader();
			graphicLoader.mapObject = mapClient.mapObject;
			graphicLoader.addEventListener(GraphicLoaderEvent.Loaded, onGraphicLoaded);
			graphicLoader.load();
			
			addChild(graphicLoader);
		}
		
		public override function apply(init_ : Boolean):void
		{
			_sprite.sprites = [this];
			_sprite.name = "worker";
			
			//cellHightLighter = new CellHighlighter();
			//cellHightLighter.mapObject = mapClient.mapObject;
			//cellHightLighter.visible = false;
			
			//addChild(cellHightLighter);
			
			//cellHightLighter.y = -_highlightOffset;
			
			graphicLoader = new WorkerGraphicLoader();
			graphicLoader.mapObject = mapClient.mapObject;
			graphicLoader.addEventListener(GraphicLoaderEvent.Loaded, onGraphicLoaded);
			graphicLoader.load();
			
			addChild(graphicLoader);
			
			_stateImage = new WorkerState();
			_stateImage.state = workerClient.workerObject.state;
			
			//Map.instance.addEventListener(MapEvent.MapMoved, onMapEvent);
			//Map.instance.addEventListener(MapEvent.MapZoomed, onMapEvent);
			//Map.instance.addEventListener(MapEvent.CellMouse, onMapEvent);
			//Map.instance.addEventListener(MapEvent.MapClicked, onMapEvent);
			
			GuiManager.instance.addEventListener(GuiManagerEvent.TaskInfoClosed, onGuiManagerEvent);
			
			var mo : MapObject = (mapClient as WorkerClient).isThereWorkspace(cellClient.cellObject.x, cellClient.cellObject.y); 

			_avatar = new WorkerAvatar(SexChooser.chooseSex(mapClient.mapObject.storeObject.storeObject.storeId.storeId), this);
			
			if (mo != null && init_)
			{
				var wse : WorkspaceEntity = Map.instance.findWS(mo.storeObject.storeObject.storeId);
				
				if (wse.empty)
				{
					applyWS(mo);
					applyAvatar();
					sit();
				}
				else
				{
					setCoords(cellClient.cellObject.x, cellClient.cellObject.y);
					applyAvatar();
				}
			}
			else
			{
				setCoords(cellClient.cellObject.x, cellClient.cellObject.y);
				applyAvatar();
				wrongLight();
			}
			
			if (workerClient.manured)
			{
				manured = true;
			}
			
			correctSprite();

			Map.instance.addNode(_sprite);

		}
		
		protected function applyAvatar() : void
		{
			_avatar.apply();
			
			var map : Map = Map.instance;
			var door : WallObject = _avatar.mapController.getDoor();			
			if (door == null)
			{
				_avatar.mapX = _avatar.mapController.width - 1;
				_avatar.mapY = _avatar.mapController.height - 1;
			}
			else
			{
				_avatar.mapX = 0;
				_avatar.mapY = 0;
				(door.wall == 1) ? _avatar.mapX = door.x : _avatar.mapY = door.x;
			}
		}

		override public function move(x_:int, y_:int):Boolean {
			setCoords(x_, y_);	
			
			cellClient.cellObject.x = x_;
			cellClient.cellObject.y = y_;
			var mo : MapObject = (mapClient as WorkerClient).isThereWorkspace(cellClient.cellObject.x, cellClient.cellObject.y); 
			if (mo!=null) var ws : WorkspaceEntity = Map.instance.findWS(mo.storeObject.storeObject.storeId);
			var correct:Boolean = ws != null && ws.empty;
			correct ? deHightLight() :	wrongLight();
			if (correct) {
				var wp : Point = ws.getWorkerPos(ws.cellX, ws.cellY);
				setCoords(wp.x, wp.y);
				setRotation(ws.getWorkerRot());
			}
			
			Map.instance.removeNode(_sprite);
			Map.instance.addNode(_sprite);
			
			Map.instance.renderScene();
			
			return correct;
		}
		
		protected function sit() : void
		{
			if (_table != null)
			{
				var need:Boolean = workerClient.workerObject.state == WorkerEntityState.Working;
				_avatar.graphicLoader.needToPlayAnimation = need;
				(graphicLoader as WorkerGraphicLoader).needToPlayAnimation = need;
				
				_table.avatar = _avatar;
				_table.avatarState = _stateImage;
				_avatar.sit(_table);
			}
		}
		
		protected function stand() : void
		{
			if (_table != null)
			{
				_table.avatar = null;
				_table.avatarState = null;
			}
			
			if (_avatar.state == WorkerAvatarState.Sitting)
			{
				_avatar.stand();
			
				_avatar.mapX = cellClient.cellObject.x;
				_avatar.mapY = cellClient.cellObject.y;
			}
			else
				_avatar.stand();
		}
		
		public function moveToTable(table_:WorkspaceEntity) : void
		{
			_table = table_;
			_table.worker = this;
			
			if (_avatar.state == WorkerAvatarState.Sitting)
				stand();
			
			_avatar.addWayPoint(new WayPoint(_table.cellX, _table.cellY), onTableReached);
			_avatar.move();
		}
		
		protected function onTableReached() : void
		{
			trace("table reached")
			touchable = true;
			sit();
			var mo : MapObject = (cellClient as WorkerClient).isThereWorkspace(cellClient.cellObject.x, cellClient.cellObject.y); 
			var ws : WorkspaceEntity = Map.instance.findWS(mo.storeObject.storeObject.storeId);
			//var wp : Point = ws.getWorkerPos(ws.cellX, ws.cellY);
			shopClient.applyBuyMove(ws.cellX, ws.cellY);
		}
		
		protected override function deHightLight() : void
		{
			super.deHightLight();
			
			graphicLoader.filter = null;
			if (_avatar) _avatar.graphicLoader.filter = null;
			
			manured = workerClient.manured;
			if (_table) _table.touchable = true;
			
			if (Map.instance.mouseWorker == this) Map.instance.mouseWorker = null;
		}
		
		protected override function highLight() : void
		{
			if (!Map.instance.canInteract(this))
				return;
			
			graphicLoader.filter = glowFilterOrange;
			_avatar.graphicLoader.filter = glowFilterOrange;
			if (_table) _table.touchable = false;
			Map.instance.mouseWorker = this;
		}			
		
		override protected function wrongLight() : void
		{
			if (graphicLoader.filter!=wrongFilter) graphicLoader.filter = wrongFilter;
			if (_avatar) _avatar.graphicLoader.filter = wrongFilter;
		}		
		
		public override function onMouseEvent(e:TouchEvent):void
		{
				if (e.getTouch(this, TouchPhase.HOVER) || e.getTouch(this, TouchPhase.BEGAN) || e.getTouch(this, TouchPhase.MOVED) 
				|| e.getTouch(_avatar, TouchPhase.HOVER) || e.getTouch(_avatar, TouchPhase.BEGAN) || e.getTouch(_avatar, TouchPhase.MOVED)) {
					if (Map.instance.moving != this)
						if (Field.instance.mouseMode != MouseModes.Sell &&
							Field.instance.mouseMode != MouseModes.Rotate)
							highLight();
				
				} else {
					if (Map.instance.moving != this)
						if (Field.instance.mouseMode != MouseModes.Sell &&
							Field.instance.mouseMode != MouseModes.Rotate)
							deHightLight();
				}
				
				if (e.getTouch(this, TouchPhase.ENDED) || e.getTouch(_avatar, TouchPhase.ENDED)) {

					if (_tableDontMove)
					{
						_table.dontMove = false;
						
						_tableDontMove = false;
					}
					
					if (!_mapMoved) {
						
						switch (Field.instance.mouseMode)
						{
							case MouseModes.Select:
								
								if (moving)
									//toggleMove();
									Map.instance.endMove();
								else
									switch (workerClient.workerObject.state)
									{
										case WorkerEntityState.NeedWork:
											if (ResourceManager.instance.myOffice)
												GuiManager.instance.showTaskChoice(this);
											break;
										
										case WorkerEntityState.Working:
											if (ResourceManager.instance.myOffice)
											{
												GuiManager.instance.showTaskInfo(this, workerClient.workerObject.currTask, workerClient.currSkillJob(workerClient.workerObject.currTask.task));
												GuiManager.instance.moveTaskInfo(taskInfoCoords);
												
												_myTaskInfo = true;
											}
											else
											{
												var fCon : FriendsContoller = ControllerManager.instance.getController(ControllerNames.FriendsController) as FriendsContoller;
												
												if (fCon.currFriendManureNum >= int(ParamManager.instance.getConfigParam(ParamType.FertilizerNum)))
												{
													var sCase : StringCase = StringManager.instance.getCase(StringTypes.ManureLimit);
													
													GuiManager.instance.showAlert(sCase.title, sCase.message);
												}
												else if (!workerClient.manured)
												{	
													PlayerAvatarTaskManager.addTask(
														new PlayerAvatarManureTask(
															null,
															new WayPoint(this.cellX, this.cellY, false),
															workerClient
														),
														true
													);
												}
											}
											
											break;
										
										case WorkerEntityState.WorkDone:
											if (ResourceManager.instance.myOffice)
											{
												PlayerAvatarTaskManager.addTask(
													new PlayerAvatarConfirmJobTask(
														null,
														new WayPoint(this.cellX, this.cellY, false),
														workerClient
													),
													true
												);
											}
											break;
										
										default:
											super.onMouseEvent(e);
									}

								break;
							
							case MouseModes.Rotate:
								break;
							
							case MouseModes.Sell:
								break;
							
							default:
								if (Map.instance.moving === this)
								{
									//toggleMove();
								}
								else
									super.onMouseEvent(e);
						}
					} else {
						_mapMoved = false;
					}
					
					e.stopPropagation();
					
				}
				
				//default:
					//super.onMouseEvent(e);

		}

		protected function onGuiManagerEvent(e : GuiManagerEvent) : void
		{
			switch (e.type)
			{
				case GuiManagerEvent.TaskInfoClosed:
					_myTaskInfo = false;
					break;
			}
		}
		
		private var _tableDontMove : Boolean = false;
		
		/*public override function toggleMove(first_ : Boolean = false) : Boolean
		{
			var app : Boolean;
			
			if (!moving)
			{
				if (cellClient.canMoveX || cellClient.canMoveY || first_)
				{
					_startPos = new Point(cellClient.cellObject.x, cellClient.cellObject.y); 
					
					_wasX = cellClient.cellObject.x;
					_wasY = cellClient.cellObject.y;
					
					//cellHightLighter.visible = true;
					//cellHightLighter.hightLight(cellClient.checkPos(cellClient.cellObject.x, cellClient.cellObject.y), cellClient.cellObject.rotation);
					
					moving = !moving;
					
					app = false;
					
					if (moving)
						Map.instance.startMove(this);
					else
						app = Map.instance.endMove();
					
					if (_avatar.state != WorkerAvatarState.Standing)
						stand();
				}
				
				return app;
			}
			else
			{
				var pos : Point = Map.instance.mouseCell;
				
				if (pos == null)
					return false;
				
				if (cellClient.checkPos(pos.x, pos.y))
				{
					//cellHightLighter.visible = false;
					
					moving = !moving;
					
					app = false;
					
					_wasX = pos.x;
					_wasY = pos.y;

					Map.instance._boughtX = _table.cellX;
					Map.instance._boughtY = _table.cellY;
					
					if (moving)
						Map.instance.startMove(this);
					else
						app = Map.instance.endMove();
					
					if (_table != null)
					{
						var trueX : int = _sprite.x / Map.CellWidth;
						var trueY : int = _sprite.y / Map.CellHeight;
						
//						cellClient.move(trueX, trueY, !app);
						cellClient.move(_table.cellX, _table.cellY, !app);
						
						setCoords(trueX, trueY);
						
						moveToTable();
					}
					else
					{
						cellClient.move(pos.x, pos.y, !app);
					
						setCoords(pos.x, pos.y);
					}
					
				}
			
				return app;
			}
			
			return false;
		}*/
		
		protected override function setCoords(mapX_:int, mapY_:int):void
		{
			super.setCoords(mapX_, mapY_);
			
			_sprite.moveBy(0, 0, _tableHeight);
//			_sprite.moveTo((mapX_) * Map.CellWidth + 3, (mapY_) * Map.CellHeight + 3, _tableHeight);
			
			_wasX = mapX_;
			_wasY = mapY_;
			_sprite.d += 50;
		}
		
		/*protected override function onMapEvent(e:MapEvent):void
		{
			switch (e.type)
			{
				case MapEvent.MapZoomed:
				case MapEvent.MapMoved:
					if (_myTaskInfo)
						GuiManager.instance.moveTaskInfo(taskInfoCoords);
					break;
				
				case MapEvent.MapClicked:
					
					if (moving && _table != null)
					{
						//toggleMove();

						Map.instance.skipOne = true;
					}
					else if (moving)
					{
						Map.instance.skipOne = true;
						
						var stringCase : StringCase = StringManager.instance.getCase(StringTypes.CannotMove);
						
						GuiManager.instance.showAlert(stringCase.title, stringCase.message);
					}
					
					break;
				
				case MapEvent.CellMouse:
					
					if (!moving)
						return;
					
					var newPos : Point = _startPos.clone();
					
					if (cellClient.canMoveX || _firstMove)
					{
						newPos.x = e.coords.x;
					}
					
					if (cellClient.canMoveY || _firstMove)
					{
						newPos.y = e.coords.y;
					}
					
					//cellHightLighter.visible = true;
					//cellHightLighter.hightLight(cellClient.checkPos(newPos.x, newPos.y), cellClient.cellObject.rotation);
					
					var mo : MapObject = (cellClient as WorkerClient).isThereWorkspace(newPos.x, newPos.y); 
					
					if (mo != null)
					{
						var wse : WorkspaceEntity = Map.instance.findWS(mo.storeObject.storeObject.storeId);
						
						if (wse != null)
							if(wse.empty || wse.worker == this)
							{
								if (_table != null)
									_table.worker = null;
								
								_table = null;
								
								wse.worker = this;
								_table = wse;
								
								//cellHightLighter.hightLight(true, cellClient.cellObject.rotation);
							}
							else
							{
								setCoords(newPos.x, newPos.y);
								
								//cellHightLighter.hightLight(false, cellClient.cellObject.rotation);
								
								_wasX = newPos.x;
								_wasY = newPos.y;
							}
					}
					else
					{
						if (_table != null)
							_table.worker = null;
						
						_table = null;
						
						setCoords(newPos.x, newPos.y);
						
						_wasX = newPos.x;
						_wasY = newPos.y;
					}
					
					break;
				
				default:
					super.onMapEvent(e);
			}
		}*/
		
		public override function remove():void
		{
			super.remove();
			
			if (_table)
			{
				_table.worker = null;
				_table.avatar = null;
				_table.avatarState = null;
			}
			
			if (_avatar) {
				_avatar.stop();
				_avatar.remove();
			}
		}
		
		public override function sell():void
		{
			if (_table)
				_table.worker = null;
			
			super.sell();
		}
		
		protected override function correctSprite() : void
		{
			super.correctSprite();
			
			y += 60//_tableHeight;
			
			_sprite.setSize(cellClient.cellObject.xLength * Map.CellWidth - 6, cellClient.cellObject.yLength * Map.CellHeight - 6, WorkerStuffHeight);
		}
		
		protected override function onEntityUpdated(e:EntityClientEvent):void
		{
			_stateImage.state = workerClient.workerObject.state;

			manured = workerClient.manured; 
		}
		
		protected function set manured(val_ : Boolean) : void
		{
			if (val_)
			{
				graphicLoader.filter = glowFilterRed;
			}
			else
			{
				//_avatar.filters = null;
				graphicLoader.filter = null;
			}
		}
		
		protected function get glowFilterPink() : FragmentFilter
		{
			return BlurFilter.createGlow(0xfb7ff7, 5, 5, 0.3);
			//return new BloomFilter(2.5, 1,1,1, 1);
		}
		
		protected function get glowFilterOrange() : FragmentFilter
		{
			return BlurFilter.createGlow(0xfbfb44, 5, 5, 0.3);
			//return new BloomFilter(2.5, 1,1,1, 1);
		}
		
		protected function get glowFilterRed() : FragmentFilter
		{
			return BlurFilter.createGlow(0xfb4444, 5, 5, 0.3);
			//return new BloomFilter(2.5, 1,1,1, 1);
		}
		
		protected function get glowFilterGreen() : FragmentFilter
		{
			return BlurFilter.createGlow(0x22ff22, 5, 5, 0.3);
			//return new BloomFilter(2.5, 1,1,1, 1);
		}
		
		protected function get taskInfoCoords() : Point
		{
			return GuiManager.instance.globalToLocal(localToGlobal(new Point(0, 0)));
		}
		
		public function get workerClient() : WorkerEntityClient
		{
			return entityClient as WorkerEntityClient;
		}
		
		protected override function onMapUpdated(e : MapClientEvent) : void
		{
			return;
		}
			
		public override function set mapClient(value:MapClient):void
		{
			super.mapClient = value;
		}
		
		protected function applyWS(mo_ : MapObject) : void
		{
			if (_table != null)
				_table.worker = null;
			
			var wse : WorkspaceEntity = Map.instance.findWS(mo_.storeObject.storeObject.storeId);
			
			if (wse != null)
			{
				wse.worker = this;
				_table = wse;
			}
			trace("f")
		}
		
		public function trueCoords(x_ : int, y_ : int, apply_ : Boolean = false) : void
		{
			setCoords(x_, y_);
			
			if (apply_ && (cellClient.cellObject.x != x_ || cellClient.cellObject.y != y_))
				//cellClient.move(_table.cellX, _table.cellY, true);
				cellClient.move(x_, y_, true);
		}
		
		public function trueRot(rot_ : int, apply_ : Boolean = false) : void
		{
			if (graphicLoader.loaded == false)
				return;
			
			rotate(rot_);
		}
		
		public override function rotate(rot_:int=-1):void
		{
			if (rot_ == -1)
			{
				throw new Error("Rot == -1 in WorkerEntity not allowed");
			}
			else
			{
				setRotation(rot_);
			}
		}
		
		protected override function onGraphicLoaded(e:GraphicLoaderEvent):void
		{
			super.onGraphicLoaded(e);
			
			if (_table != null)
			{
				_table.applyW();
				
				if (workerClient.workerObject.state == WorkerEntityState.Working)
				{
					(graphicLoader as WorkerGraphicLoader).needToPlayAnimation = true;
				}
			}
		}
		
		public override function set entityClient(entClient_:EntityClient):void
		{
			super.entityClient = entClient_;
		
			workerClient.addEventListener(WorkerClientEvent.WorkDone, onClientEvent);
			workerClient.addEventListener(WorkerClientEvent.WorkStarted, onClientEvent);
			workerClient.addEventListener(WorkerClientEvent.WorkAccepted, onClientEvent);
			
			workerClient.addEventListener(WorkerClientEvent.Manured, onClientEvent);
			workerClient.addEventListener(WorkerClientEvent.UnManured, onClientEvent);
			
			workerClient.addEventListener(WorkerClientEvent.SkillUp, onSkillUp);
		}
		
		public function cancelTask() : void
		{
			workerClient.cancelTask();
		}
		
		public function startTask(task_ : TaskData) : void
		{
			if (!workerClient.startTask(task_))
			{
				GuiManager.instance.noMoneyWindow.visible = true;
			}
		}
		
		protected function onClientEvent(e : WorkerClientEvent) : void
		{
			_stateImage.state = workerClient.workerObject.state;
			
			switch (e.type)
			{
				case WorkerClientEvent.WorkDone:
				case WorkerClientEvent.WorkAccepted:
					(graphicLoader as WorkerGraphicLoader).needToPlayAnimation = false;
					_avatar.graphicLoader.needToPlayAnimation = false;
					_avatar.state = WorkerAvatarState.Sitting;					
				break;
				
				case WorkerClientEvent.WorkStarted:
					(graphicLoader as WorkerGraphicLoader).needToPlayAnimation = true;
					_avatar.graphicLoader.needToPlayAnimation = true;	
					_avatar.state = WorkerAvatarState.Sitting;
				break;
				
				case WorkerClientEvent.Manured:
					
					manured = true;
					
					var sCase : StringCase = StringManager.instance.getCase(StringTypes.ManureAlert);
					
					GuiManager.instance.manureWindow(sCase.title, sCase.message);
					
					break;
				
				case  WorkerClientEvent.UnManured:
					
					manured = false;
					
					break;
			}
		}
		
		override public function get filter():FragmentFilter {
			return super.filter;
		}
		
		override public function set filter(filter:FragmentFilter):void {
			graphicLoader.filter = filter;
			if (_avatar) _avatar.graphicLoader.filter = filter;
		}
		
	}
}