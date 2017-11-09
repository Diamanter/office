package com.sigma.socialgame.view.game.map.objects
{
	import as3isolib.display.IsoSprite;
	
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.GraphicStates;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.avatar.Avatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.WorkerAvatar;
	import com.sigma.socialgame.view.game.map.objects.graphic.CellHighlighter;
	import com.sigma.socialgame.view.game.map.objects.graphic.WorkspaceGraphicLoader;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.components.WorkerState;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class WorkspaceEntity extends CellEntity
	{
		public static const IconHeight : int = Map.CellHeight / 16;
		public static const IconSize : int = Map.CellHeight / 16;
		public static const TableHeight : int = 60;
		public static const ChairHeight : int = 89;
		
		private var _worker : WorkerEntity = null;
		private var _avatar : WorkerAvatar = null;
		private var _avatarState : WorkerState = null;
		private var _statusIcon : IsoSprite = null;
		
		private var _bottomChairSprite : IsoSprite = null;
		private var _topChairSprite : IsoSprite = null;
		private var _tableSprite : IsoSprite = null;
		
		public function WorkspaceEntity()
		{
			super();
			
			_bottomChairSprite = new IsoSprite({name:"tableBottomChair"});
			_topChairSprite = new IsoSprite({name:"tableTopChair"});			
			_tableSprite = new IsoSprite({name:"table"});
			_statusIcon = new IsoSprite({name:"tableIcon"});
			hFilter.adjustBrightness(0.3);
		}
		
		public override function apply(init_ : Boolean):void
		{
			//cellHightLighter = new CellHighlighter();
			//cellHightLighter.mapObject = cellClient.mapObject;
			//cellHightLighter.visible = false;
			
			graphicLoader = new WorkspaceGraphicLoader(this);
			graphicLoader.mapObject = cellClient.mapObject;
			
			graphicLoader.addEventListener(GraphicLoaderEvent.Loaded, onGraphicLoaded);
			graphicLoader.load();
			
			//wsGraphic.mcTable.addChild(cellHightLighter);
			//cellHightLighter.y = Map.CellHeight;
			
			setCoords(cellClient.cellObject.x, cellClient.cellObject.y);
			
			//Map.instance.addEventListener(MapEvent.CellMouse, onMapEvent);
			//Map.instance.addEventListener(MapEvent.MapClicked, onMapEvent);

			correctSprite();
		}
		
		private function placeAvatar() : void
		{
			if (_avatar == null) return;
			var rot:int = getAvatarRot();
			_avatar.rotate(rot);
			_avatar.avatarIsoSprite.moveTo(_bottomChairSprite.x, _bottomChairSprite.y, ChairHeight + (rot>2 ? -1 : 0));
			_avatar.avatarIsoSprite.render();
		}
		
		private function placeWorkspaceSprites(): void
		{
			_topChairSprite.sprites = null;
			if (wsGraphic.needToDivideChair)
			{
				_topChairSprite.sprites = [wsGraphic.mcTopChair];
			}
	
			var localX : int = cellClient.cellObject.x;
			var localY : int = cellClient.cellObject.y;
			
			localX = (localX) * Map.CellWidth + 3;
			localY = (localY) * Map.CellHeight + 3;
			
			var tableOffset : Array = [0, 0];
			var chairOffset : Array = [0, 0];
			//var highlighterOffset : Array = [0, 0];
			var rotation : int = cellClient.cellObject.rotation;

			var localLoader : WorkspaceGraphicLoader = graphicLoader as WorkspaceGraphicLoader;
			
			switch (rotation)
			{
				case MapRotation.NorthWest:
					_bottomChairSprite.sprites = [localLoader.mcBottomChair];
					_tableSprite.sprites = [localLoader.mcTable];
					
					tableOffset = [Map.CellWidth, 0];
					//highlighterOffset = [2, 1];
				break;
				case MapRotation.NorthEast:
					_bottomChairSprite.sprites = [localLoader.mcBottomChair];
					_tableSprite.sprites = [localLoader.mcTable];
					
					chairOffset = [0, Map.CellWidth];										
					//highlighterOffset = [1, 2];
				break;				
				case MapRotation.SouthEast:
					_bottomChairSprite.sprites = [localLoader.mcBottomChair];
					_tableSprite.sprites = [localLoader.mcTable];
					
					chairOffset = [Map.CellWidth, 0];
					//highlighterOffset = [2, 1];
				break;
				case MapRotation.SouthWest:
					_bottomChairSprite.sprites = [localLoader.mcBottomChair];
					_tableSprite.sprites = [localLoader.mcTable];
					
					tableOffset = [0, Map.CellWidth];
					//highlighterOffset = [1, 2];
				break;				
			}		
			
			//var vec : Vector3D = Map.instance.getCellCoords(highlighterOffset[0], highlighterOffset[1]);
			
			//cellHightLighter.x = vec.x;
			//cellHightLighter.y = vec.y;
			
			if (wsGraphic.needToDivideChair)
			{
				_topChairSprite.setSize(Map.CellWidth / 5.0, Map.CellHeight / 5.0, Avatar.Height + 10);
				_topChairSprite.moveTo(localX + chairOffset[0], localY + chairOffset[1], ChairHeight);
				_topChairSprite.d -= 250;
			}
			
			_bottomChairSprite.setSize(Map.CellWidth - 6, Map.CellHeight - 6, ChairHeight);			
			_bottomChairSprite.moveTo(localX + chairOffset[0], localY + chairOffset[1], 0);
			_bottomChairSprite.d -= 140;
			
			_tableSprite.setSize(Map.CellWidth - 6, Map.CellHeight - 6, TableHeight);			
			_tableSprite.moveTo(localX + tableOffset[0], localY + tableOffset[1], 0);
			_tableSprite.d -= 120;
			
			_statusIcon.d += 150;
		}
		
		public override function remove():void
		{
			super.remove();
			
			if (_bottomChairSprite != null)
			{
				Map.instance.removeNode(_bottomChairSprite);
			}
			
			if (_topChairSprite != null)
			{
				Map.instance.removeNode(_topChairSprite);
			}
			
			if (_tableSprite != null)
			{
				Map.instance.removeNode(_tableSprite);
			}
		}
		
		/*public override function toggleMove(first_ : Boolean = false) : Boolean
		{
			if (_dontMove)
			{
				_dontMove = false;
				
				return false;
			}
			
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
					
					var currPoint : Point = Map.instance.mouseCell; 
					trace(currPoint, ":");
					Map.instance.renderScene();
					
					if (currPoint != null)
						if (_wasX != currPoint.x || _wasY != currPoint.y)
						{
							var newMEvent : MapEvent = new MapEvent(MapEvent.CellMouse);
							newMEvent.coords = Map.instance.mouseCell;
							Map.instance.dispatchEvent(newMEvent);
						}
					
					if (moving)
						Map.instance.startMove(this);
					else
						return Map.instance.endMove();
				}
			}
			else
			{
				var pos : Point = Map.instance.mouseCell;
				trace(":",pos);
					Map.instance.renderScene();
				if (pos == null)
					return false;
				
				if (cellClient.checkPos(pos.x, pos.y))
				{
					//cellHightLighter.visible = false;
					
					moving = !moving;
					
					_wasX = pos.x;
					_wasY = pos.y;
					
					Map.instance._boughtX = _wasX;
					Map.instance._boughtY = _wasY;
					
					if (moving)
						Map.instance.startMove(this);
					else
						app = Map.instance.endMove();
					
					cellClient.move(pos.x, pos.y, !app);
					
					setCoords(pos.x, pos.y);
					placeWorkspaceSprites();
					placeAvatar();
					setAvatarStateIconPos();
					
					applyWCoord(pos.x, pos.y, !app);
//					applyWCoord(pos.x, pos.y, true);
				}
				
				return app;
			}
			
			return false;
		}*/
		
		public override function sell():void
		{
			if (_worker != null)
				return;
//				MapEntityFacade.removeToStore(_worker.mapClient.mapObject.mapObject.storeObject);
			
			super.sell();
		}
		
		protected override function deHightLight() : void
		{
			wsGraphic.filter = null;
			if (_worker) _worker.filter = null;
			if (Map.instance.mouseWorkspace == this) { 
				Map.instance.mouseWorkspace = null;
			}
		}
		
		protected override function highLight() : void
		{
			if (!Map.instance.canInteract(this))
				return;
			
			Map.instance.mouseWorkspace = this;

			if (wsGraphic.filter!=bloomFilter) wsGraphic.filter = bloomFilter;
		}
		
		override protected function wrongLight() : void
		{
			if (wsGraphic.filter!=wrongFilter) { 
				wsGraphic.filter = wrongFilter;
				if (_worker) _worker.filter = wrongFilter;
			}
		}		
		
		public override function onMouseEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (!touch) touch = e.getTouch(wsGraphic.mcTable);
			if (!touch && wsGraphic.mcBottomChair) touch = e.getTouch(wsGraphic.mcBottomChair);
			if (!touch && wsGraphic.mcTopChair) touch = e.getTouch(wsGraphic.mcTopChair);
			
				if (touch && (touch.phase==TouchPhase.HOVER || touch.phase==TouchPhase.MOVED || touch.phase==TouchPhase.BEGAN)) {
					if (Map.instance.moving != this)
						if (Field.instance.mouseMode != MouseModes.Sell || _worker == null)
							highLight();
				} else {
					if (Map.instance.moving != this)
						if (Field.instance.mouseMode != MouseModes.Sell || _worker == null)
							deHightLight();
				}
				
				if (touch && touch.phase==TouchPhase.ENDED) {
					if (!_mapMoved) {
						switch (Field.instance.mouseMode)
						{
							case MouseModes.Select:
								
								if (Map.instance.canInteract(this))
									if (ResourceManager.instance.myOffice)
										if (Map.instance.moving == null)
										{
											if (_worker == null)
											{
												GuiManager.instance.showEntityMenuRotate(this);
											}
											else
											{
												GuiManager.instance.showEntityMenuNoSell(this);
											}
										}
										//else
										//{
											//toggleMove();
											//Map.instance.endMove();
										//}
								
								break;
							
							/*default:
								if (Map.instance.moving === this)
								{
									//toggleMove();
									Map.instance.endMove();
								}
								else
									super.onMouseEvent(e);*/
						}
					} else {
						_mapMoved = false;
					}
				}
		}
		
		private var _dontMove : Boolean = false;		
		/*protected override function onMapEvent(e : MapEvent) : void
		{
			switch (e.type)
			{
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
					
					setCoords(newPos.x, newPos.y);
					
					applyWCoord(newPos.x, newPos.y);
					
					_wasX = newPos.x;
					_wasY = newPos.y;
					
					placeWorkspaceSprites();
					placeAvatar();
					setAvatarStateIconPos();
					
					break;
				
				default:
					super.onMapEvent(e);
			}
		}*/
		
		override public function move(x_:int, y_:int):Boolean {
			setCoords(x_, y_);			
			applyWCoord(x_, y_);
			
			cellClient.cellObject.x = x_;
			cellClient.cellObject.y = y_;
			//trace("move", cellX, cellY)
			
			placeWorkspaceSprites();
			placeAvatar();
			setAvatarStateIconPos();
			
			var correct:Boolean = cellClient.checkPos(x_, y_);
			correct ? deHightLight() :	wrongLight();
			
			Map.instance.removeNode(_bottomChairSprite);
			Map.instance.removeNode(_topChairSprite);
			Map.instance.removeNode(_tableSprite);			
			Map.instance.removeNode(_statusIcon);
			
			Map.instance.addNode(_bottomChairSprite);
			Map.instance.addNode(_topChairSprite);
			Map.instance.addNode(_tableSprite);			
			Map.instance.addNode(_statusIcon);
			
			return correct;
		}
		
		public function get worker():WorkerEntity
		{
			return _worker;
		}

		public function set worker(value:WorkerEntity):void
		{
			_worker = value;

			if (_worker != null)
			{
				applyWCoord(cellClient.cellObject.x, cellClient.cellObject.y);
				applyWRot();
			}
		}

		protected function applyWCoord(x_ : int, y_ : int, apply_ : Boolean = false) : void
		{
			if (_worker == null)
				return;
			
			var coords : Point = getWorkerPos(x_, y_);
			_worker.trueCoords(coords.x, coords.y, apply_);
		}
		
		protected function applyWRot(apply_ : Boolean = false) : void
		{
			if (_worker == null)
				return;
			
			var rot : int = getWorkerRot();
			
			_worker.trueRot(rot, apply_);
		}
		
		public function getWorkerPos(x_ : int, y_ : int) : Point
		{
			var vec3 : Vector3D = new Vector3D(x_, y_);
			
			switch (cellClient.cellObject.rotation)
			{
				case MapRotation.NorthWest:
					
					vec3.x += 1;
					
					break;
				
				case MapRotation.SouthWest:
					
					vec3.y += 1;
					
					break;
			}
			
			return new Point(vec3.x, vec3.y);
		}
		
		protected override function setRotation(rot_:int):void
		{
			var state : String;
			
			var invert : int = 1;
			
			switch (rot_)
			{
				case MapRotation.NorthWest:
					state = GraphicStates.NW;
				break;
				
				case MapRotation.NorthEast:
					if (cellClient.cellObject.sides == 1)
					{
						state = GraphicStates.NW;						
						invert = -1;
					}
					else
					{
						state = GraphicStates.NE;
						invert = 1;
					}
				break;
				
				case MapRotation.SouthEast:
					if (cellClient.cellObject.sides == 1)
					{
						state = GraphicStates.NW;
						invert = 1;
					}
					else if (cellClient.cellObject.sides == 2)
					{
						state = GraphicStates.NE;
						invert = -1;
					}
					else if (cellClient.cellObject.sides == 4)
					{
						state = GraphicStates.SE;
						invert = 1;
					}
				break;
				
				case MapRotation.SouthWest:
					if (cellClient.cellObject.sides == 1)
					{
						state = GraphicStates.NW;
						invert = -1;
					}
					else if (cellClient.cellObject.sides == 2)
					{
						state = GraphicStates.NW;	
						invert = -1;
					}
					else
					{
						state = GraphicStates.SW;	
						invert = 1;
					}
				break;
			}
			
			if (graphicLoader.state != state)
				graphicLoader.selectState(state);
			
			placeWorkspaceSprites();
			placeAvatar();
			setAvatarStateIconPos();
			
			correctSprite();

			wsGraphic.mcBottomChair.scaleX = -invert;
			wsGraphic.mcTopChair.scaleX = -invert;
			wsGraphic.mcTable.scaleX = -invert;
			
			if (_worker != null)
			{
				var realPos : Point = getWorkerPos(cellClient.cellObject.x, cellClient.cellObject.y);
			
				worker.trueCoords(realPos.x, realPos.y, true);
				worker.trueRot(getWorkerRot(), true);
			}
		}
		
		public function applyW() : void
		{
			if (_worker != null)
			{
				var realPos : Point = getWorkerPos(cellClient.cellObject.x, cellClient.cellObject.y);
				
				worker.trueCoords(realPos.x, realPos.y, true);
				worker.trueRot(getWorkerRot(), true);
			}
		}
		
		public function getWorkerRot() : int
		{
			switch (cellClient.cellObject.rotation)
			{
				case MapRotation.NorthWest:
					return MapRotation.SouthEast;
					break;
				
				case MapRotation.NorthEast:
					return MapRotation.SouthWest;
					break;
				
				case MapRotation.SouthEast:
					return MapRotation.NorthWest;
					break;
				
				case MapRotation.SouthWest:
					return MapRotation.NorthEast;
					break;
			}
			
			return -1;
		}
		
		public function getAvatarRot() : int
		{
			switch (cellClient.cellObject.rotation)
			{
				case MapRotation.NorthWest:
					return MapRotation.NorthWest;
					break;
				
				case MapRotation.NorthEast:
					return MapRotation.NorthEast;
					break;
				
				case MapRotation.SouthEast:
					return MapRotation.SouthEast;
					break;
				
				case MapRotation.SouthWest:
					return MapRotation.SouthWest;
					break;
			}
			
			return -1;
		}
		
		public function get empty() : Boolean
		{
			return _worker == null;
		}

		public function get dontMove():Boolean
		{
			return _dontMove;
		}

		public function set dontMove(value:Boolean):void
		{
			_dontMove = value;
		}

		public function get avatar():WorkerAvatar
		{
			return _avatar;
		}
		
		protected override function onGraphicLoaded(e:GraphicLoaderEvent):void
		{
			super.onGraphicLoaded(e);
			
			placeWorkspaceSprites();
			placeAvatar();
			setAvatarStateIconPos();
			Map.instance.addNode(_bottomChairSprite);
			Map.instance.addNode(_topChairSprite);
			Map.instance.addNode(_tableSprite);			
		}
		
		public function set avatar(value:WorkerAvatar):void
		{
			_avatar = value;
			
			placeAvatar();
		}
		
		public function get avatarState():WorkerState
		{
			return _avatarState;
		}
		
		public function set avatarState(value : WorkerState): void
		{
			if (_avatarState != null)
				Map.instance.removeNode(_statusIcon);
			
			_avatarState = value;
			
			if (_avatarState != null)
			{
				_statusIcon.sprites = [_avatarState];
				Map.instance.addNode(_statusIcon);
				setAvatarStateIconPos();
			}
		}
		
		protected function setAvatarStateIconPos() : void
		{
			_statusIcon.setSize(IconSize, IconSize, IconHeight);
			var iconHeight : int = (_avatar == null) ? ChairHeight : ChairHeight + Avatar.Height;
			
			_statusIcon.moveTo(_bottomChairSprite.x, _bottomChairSprite.y, iconHeight-90);
		}		
		
		protected function get wsGraphic() : WorkspaceGraphicLoader
		{
			return graphicLoader as WorkspaceGraphicLoader;
		}
		
		override public function set touchable(value:Boolean):void {
			super.touchable = value;
			wsGraphic.touchable = value;
		}
		
	}
}