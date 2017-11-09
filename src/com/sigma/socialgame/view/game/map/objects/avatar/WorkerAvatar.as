package com.sigma.socialgame.view.game.map.objects.avatar
{
	import as3isolib.display.IsoSprite;
	
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;
	import com.sigma.socialgame.view.game.map.objects.WorkspaceEntity;
	import com.sigma.socialgame.view.game.map.objects.graphic.WorkerAvatarGraphicLoader;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import starling.display.Sprite;
	import flash.utils.getTimer;

	public class WorkerAvatar extends Avatar
	{
		private var _graphicLoader : WorkerAvatarGraphicLoader;
		
		private var _table : WorkspaceEntity;
		private var _onTable : Boolean = false;
		private var _workerStuff : WorkerEntity = null;
		
		public function WorkerAvatar(sex_ : String, workerStuff_ : WorkerEntity)
		{
			super();
			
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
			//addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			//addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			//addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			//addEventListener(MouseEvent.CLICK, onMouseEvent);			
			
			_workerStuff = workerStuff_;
			_graphicLoader = new WorkerAvatarGraphicLoader(sex_);
		}
		
		private function onMouseEvent (e : TouchEvent) : void
		{
			if ((e.type == TouchPhase.HOVER) && !_onTable) return;
			_workerStuff.onMouseEvent(e);
		}
		
		public override function apply() : void
		{
			_sprite.sprites = [this];
			
			super.apply();
			
			addChild(_graphicLoader);
			
			_graphicLoader.avatarState = WorkerAvatarState.Standing;
			_graphicLoader.dir = MapRotation.NorthWest;
			
			var vec3 : Vector3D = Map.instance.getCellCoords(1, 1);
			
			x = vec3.x;
			y = vec3.y;
			
			Map.instance.addNode(_sprite);
			_sprite.d += 50;
		}

		public function rotate(rot_ : int) : void
		{
			dir = rot_;
		}
		
		protected override function dirChanged():void
		{
			_graphicLoader.dir = dir;
		}
		
		protected override function startMove():void
		{
			_graphicLoader.needToPlayAnimation = true;
			_graphicLoader.avatarState = WorkerAvatarState.Walking;
		}
		
		protected override function stopMove():void
		{
			trace("stop move")
			_table.move(_mapX, _mapY);
			Map.instance.renderScene();
			_graphicLoader.needToPlayAnimation = false;
			_graphicLoader.avatarState = WorkerAvatarState.Sitting;
		}
		
		public function get state() : String
		{
			return _graphicLoader.state;
		}
		
		public function set state(value : String) : void
		{
			_graphicLoader.avatarState = value;
		}
		
		public function sit(table_:WorkspaceEntity) : void
		{
			_table = table_;
			state = WorkerAvatarState.Sitting;			
			_onTable = true;
			_stop = true;
		}
		
		public function get graphicLoader() : WorkerAvatarGraphicLoader
		{
			return _graphicLoader;
		}
		
		public function stand() : void
		{
			if (_onTable)
			{
				_onTable = false;
			}
			else
				stop();
			
			state = WorkerAvatarState.Standing;			
			var vec3 : Vector3D = Map.instance.getCellCoords(1, 1);
			
			x = vec3.x;
			y = vec3.y;
		}
		public override function move() : void
		{
			if (_targets.length == 0)
				return;
			
			if (_currTarget != null) return;
			
			state = WorkerAvatarState.Walking;
			_currTarget = _targets.shift();
			
			if (_currTarget.x == _mapX && _currTarget.y == _mapY)
			{
				(_callbacks.shift())();
				
				_currTarget = null;
				
				return;
			}
			
			_currWay = mapController.buildWay(new Point(_mapX, _mapY), new Point(_currTarget.x, _currTarget.y));
			if (_currWay.way.length == 0)
			{
				(_callbacks.shift())();
				
				_currTarget = null;
				
				return;
			}
			
			if (_currTarget.needToAddAtEnd)
			{
				_currWay.way.push(new WayPoint(_currTarget.x, _currTarget.y));
			}
			
			_currInd = 0;
			
			_currTarget.x = _currWay.way[_currWay.way.length - 1].x;
			_currTarget.y = _currWay.way[_currWay.way.length - 1].y;
			
			_currWayPoint.x = _currWay.way[_currInd].x * Map.CellWidth;
			_currWayPoint.y = _currWay.way[_currInd].y * Map.CellHeight;
			
			addEventListener(Event.ENTER_FRAME, makeStep);
			
			startMove();
			trace("start move")
		}
		
		/*public function nextTarget() : void
		{
			makeNextTarget();
		}
		
		protected override function makeNextTarget() : void
		{
			trace (_targets.length)
			if (_targets.length == 0)
			{
				removeEventListener(Event.ENTER_FRAME, makeStep);
				
				_currTarget = null;
				
				stopMove();
				
				return;
			}
			
			_currTarget = _targets.shift();
			
			if (_currTarget.x == _mapX && _currTarget.y == _mapY)
			{
				if (_callbacks && _callbacks.length) (_callbacks.shift())();
				
				makeNextTarget();
				
				return;
			}
			
			_currWay = mapController.buildWay(new Point(_mapX, _mapY), new Point(_currTarget.x, _currTarget.y));
			
			if (_currWay.way.length == 0)
			{
				(_callbacks.shift())();
				
				makeNextTarget();
			}
			
			if (_currTarget.needToAddAtEnd)
			{
				_currWay.way.push(new WayPoint(_currTarget.x, _currTarget.y));
			}
			
			_currInd = 0;
			
			_currWayPoint.x = _currWay.way[_currInd].x * Map.CellWidth;
			_currWayPoint.y = _currWay.way[_currInd].y * Map.CellHeight;
		}*/
		
		protected override function makeStep(e : Event) : void
		{
			//if (state == PlayerAvatarState.Interacting) return;
			
			if (_stop)
			{
				removeEventListener(Event.ENTER_FRAME, makeStep);
				
				_stop = false;
				
				stopMove();
				
				_currTarget = null;
				
				return;
			}
			
			var delta : Vector3D = new Vector3D(_currWayPoint.x - _sprite.x + 3, _currWayPoint.y - _sprite.y + 3);			
			var isNear : Boolean = (Math.abs(delta.x) < PlayerAvatar.Epsilon) && (Math.abs(delta.y) < PlayerAvatar.Epsilon); 
			var needRender : Boolean = false;
			if (isNear)
			{
				_mapX = _currWayPoint.x / Map.CellWidth;
				_mapY = _currWayPoint.y / Map.CellHeight;
				
				var targetReached : Boolean = (_currInd == _currWay.way.length - 1);
				if (targetReached)
				{
					if (_callbacks && _callbacks.length>0) (_callbacks.shift())();
					needRender = true;
				}
				else
				{
					makeNextWayPoint();
					needRender = true;
				}
				if (needRender) {
					//trace("render", _sprite.x, _sprite.y, _currWayPoint.x, _currWayPoint.y);
					//Map.instance.swap(_sprite);
					_sprite.z = 0;
					_sprite.d += 50;
					Map.instance.removeNode(_sprite);
					Map.instance.addNode(_sprite);
				}
				return;
			}
			
			var direction : Vector3D = new Vector3D(delta.x, delta.y);
			direction.normalize();
			
			if (Math.abs(direction.x) > Math.abs(direction.y))
			{
				direction.x /= Math.abs(direction.x);
				direction.y = 0;
			}
			else
			{
				direction.y /= Math.abs(direction.y);
				direction.x = 0;
			}
			_sprite.x += direction.x * Speed;
			_sprite.y += direction.y * Speed;
			_sprite.render(false);

			
			var newDir : int;
			
			if (direction.x > 0)
				newDir = MapRotation.SouthEast;
			else if (direction.x < 0)
				newDir = MapRotation.NorthWest;
			else if (direction.y > 0)
				newDir = MapRotation.SouthWest;
			else if (direction.y < 0)
				newDir = MapRotation.NorthEast;
			
			if (newDir != _dir)
			{
				_dir = newDir;
				dirChanged();
			}
		}
		
		protected override function makeNextWayPoint() : void
		{
			_currInd++;
			
			_currWayPoint.x = _currWay.way[_currInd].x * Map.CellWidth;
			_currWayPoint.y = _currWay.way[_currInd].y * Map.CellWidth;
		}		
	}
}