package com.sigma.socialgame.view.game.map.objects
{
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.controller.map.clients.WorkerClient;
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarMoveTask;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarTaskManager;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarTaskPriority;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.geom.Point;
	import starling.events.Touch;

	public class TrimCellEntity extends CellEntity
	{
		public function TrimCellEntity()
		{
			super();
		}

		protected static var tempInd : int = -10000;
		protected var wasInd : int;
		
		/*public override function toggleMove(first_:Boolean=false):Boolean
		{
			if (!moving)
			{
				if (cellClient.canMoveX || cellClient.canMoveY || first_)
				{
					_startPos = new Point(cellClient.cellObject.x, cellClient.cellObject.y); 
					
					_wasX = cellClient.cellObject.x;
					_wasY = cellClient.cellObject.y;
					
					//cellHightLighter.visible = true;
					
					//cellHightLighter.hightLight(cellClient.checkPos(cellClient.cellObject.x, cellClient.cellObject.y), cellClient.cellObject.rotation);
					
					_firstMove = first_;
					
					moving = !moving;
					
					if (moving)
						Map.instance.startMove(this);
					else
						return Map.instance.endMove();
					
					if (_firstMove)
					{
						wasInd = cellClient.cellObject.storeObject.storeObject.storeId.storeId;
						cellClient.cellObject.storeObject.storeObject.storeId.storeId = tempInd--;
					}
					
					return false;
				}
				
				return false;
			}
			else
			{
				var pos : Point = Map.instance.mouseCell;
				
				if (pos == null)
					return false;
				
				if (cellClient.checkPos(pos.x, pos.y))
				{
					//cellHightLighter.visible = false;
					
					_wasX = pos.x;
					_wasY = pos.y;
					
					Map.instance._boughtX = _wasX;
					Map.instance._boughtY = _wasY;
					
					_firstMove = first_;
					
					moving = !moving;
					
					var app : Boolean = false;
					
					if (cellClient.cellObject.storeObject.storeObject.storeId.storeId <= -10000)
						cellClient.cellObject.storeObject.storeObject.storeId.storeId = wasInd;
					
					if (moving)
						Map.instance.startMove(this);
					else
						app = Map.instance.endMove();
					
					cellClient.move(pos.x, pos.y, !app);
					
					_firstMove = false;
					
					setCoords(pos.x, pos.y);
					
					if (Map.instance._boughtClient != null)
					{
						Map.instance._wasBought = (Map.instance._boughtClient.alreadyHave() == 0);
						Map.instance.buyAgain();
					}
					
					return app;
				}
			}
			
			return false;
		}*/
		
		public override function onMouseEvent(e:TouchEvent):void
		{
				if (e.getTouch(this, TouchPhase.HOVER) || e.getTouch(this, TouchPhase.BEGAN) || e.getTouch(this, TouchPhase.MOVED)) {
					if (Map.instance.moving != this)
						//if (Field.instance.mouseMode != MouseModes.Rotate)
							highLight();
				} else { 
					if (Map.instance.moving != this)
						//if (Field.instance.mouseMode != MouseModes.Rotate)
							deHightLight();
				}

				if (e.getTouch(this, TouchPhase.ENDED)) {					
					
					if (!_mapMoved) {
						if (Map.instance.moving==null) {		
							var waypoint : WayPoint = new WayPoint(this.cellClient.cellObject.x, this.cellClient.cellObject.y);
							PlayerAvatarTaskManager.addTask(new PlayerAvatarMoveTask(null, waypoint));
							
							if (Map.instance.canInteract(this))
								if (ResourceManager.instance.myOffice)
									if (Map.instance.moving == this)
										Map.instance.endMove();
										//toggleMove();
						} else {
							if (Map.instance.moving is WorkerEntity) {
								var movingWorkerEntity:WorkerEntity = Map.instance.moving as WorkerEntity;
								var mo : MapObject = (movingWorkerEntity.mapClient as WorkerClient).isThereWorkspace(cellClient.cellObject.x, cellClient.cellObject.y); 
								var ws : WorkspaceEntity = Map.instance.findWS(mo.storeObject.storeObject.storeId);
								//var wp : Point = ws.getWorkerPos(ws.cellX, ws.cellY);
								var correct:Boolean = mo != null && ws.empty;
								if (correct) {
									//trace(":::", ws.cellX, ws.cellY)
									//movingWorkerEntity.cellClient.move(pos.x, pos.y, false);
									Map.instance.mapController.moveCellObject(movingWorkerEntity.cellClient.cellObject, false);
									Map.instance.endMove(ws.cellX, ws.cellY);
									movingWorkerEntity.moveToTable(ws);
								}
							} else if (Map.instance.moving is CellEntity) {
								var movingCellEntity:CellEntity = Map.instance.moving as CellEntity;
								//movingCellEntity.cellClient.move(movingCellEntity.cellX, movingCellEntity.cellY, false);
								Map.instance.mapController.moveCellObject(movingCellEntity.cellClient.cellObject, false);
								Map.instance.endMove();
							}
						}
						
					} else {
						_mapMoved = false;
					}
				}
				
				/*case MouseEvent.CLICK:
					
					if (!Map.instance._wasBought)
					{
//						var waypoint : WayPoint = new WayPoint(this.cellClient.cellObject.x, this.cellClient.cellObject.y);
//						PlayerAvatarTaskManager.addTask(new PlayerAvatarMoveTask(null, waypoint));
					}
					
				*/
		}
		
		protected override function setCoords(mapX_ : int, mapY_ : int) : void
		{
			super.setCoords(mapX_, mapY_);
			
			if (_firstMove)
//				_sprite.moveTo((mapX_) * Map.CellWidth, (mapY_) * Map.CellHeight, -1);
				_sprite.moveBy(0, 0, -1);
			else
//				_sprite.moveTo((mapX_) * Map.CellWidth, (mapY_) * Map.CellHeight, -2);
				_sprite.moveBy(0, 0, -2);
		}
		
		protected override function correctSprite():void
		{
			super.correctSprite();
			
			_sprite.setSize(cellClient.cellObject.xLength * Map.CellWidth, cellClient.cellObject.yLength * Map.CellHeight, 1);
		}
		
		public override function set mapClient(value:MapClient):void
		{
			super.mapClient = value;
		}
	}
}