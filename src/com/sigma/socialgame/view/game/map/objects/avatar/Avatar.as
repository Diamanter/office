package com.sigma.socialgame.view.game.map.objects.avatar
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.way.Way;
	import com.sigma.socialgame.controller.map.way.WayPoint;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Avatar extends Sprite
	{
		public static const Height : int = Map.CellHeight * 2;
		public static const Speed : int = 3.2;
		public static const Epsilon : int = 4;
		
		protected var _mapX : int = 0;
		protected var _mapY : int = 0;
		
		protected var _dir : int;

		protected var _targets : Vector.<WayPoint>;
		protected var _callbacks : Vector.<Function>;

		protected var _currInd : int;
		protected var _currWayPoint : WayPoint;
		protected var _currTarget : WayPoint;
		protected var _currWay : Way;
		
		protected var _stop : Boolean = false;
		
		protected var _sprite : IsoSprite;
		
		public function Avatar()
		{
			super();
			
			_dir = -1;
			
			_targets = new Vector.<WayPoint>();
			_callbacks = new Vector.<Function>();
			_currWayPoint = new WayPoint();
			
			_sprite = new IsoSprite({name:"avatar"});
			_sprite.setSize(Map.CellWidth - 6, Map.CellHeight - 6, Height);
			_sprite.moveTo(0, 0, 0);
			//_sprite.invalidatePosition(
			//_sprite.getRootNode(
			//_sprite.autoUpdate = true;
		}

		public function apply() : void
		{
		}
		
		public function remove() : void
		{
			Map.instance.removeNode(_sprite);
		}
		
		public function addWayPoint(wayPoint_ : WayPoint, callback_ : Function) : void
		{
			_targets.push(wayPoint_);
			_callbacks.push(callback_);
		}
		
		public function move() : void
		{
			/*if (_targets.length == 0)
				return;
			
			if (_currTarget == null)
			{
				_currTarget = _targets.shift();
				
				if (_currTarget.x == _mapX && _currTarget.y == _mapY)
				{
					(_callbacks.shift())();
					
					_currTarget = null;
					
					return;
				}
				
				_currWay = mapController.buildWay(new Point(_mapX, _mapY), new Point(_currTarget.x, _currTarget.y));

				if (_currWay.way.length == 1)
				{
					(_callbacks.shift())();
					
					_currTarget = null;
					
					return;
				}
				
				_currInd = 1;
				
				_currTarget.x = _currWay.way[_currWay.way.length - 1].x;
				_currTarget.y = _currWay.way[_currWay.way.length - 1].y;
				
				_currWayPoint.x = _currWay.way[_currInd].x * Map.CellWidth;
				_currWayPoint.y = _currWay.way[_currInd].y * Map.CellHeight;
				
				addEventListener(Event.ENTER_FRAME, makeStep);
				
				startMove();
			}
			else
			{
				addEventListener(Event.ENTER_FRAME, makeStep);
				
				startMove();
			}*/
		}
		
		protected function makeNextTarget() : void
		{
			/*if (_targets.length == 0)
			{
				removeEventListener(Event.ENTER_FRAME, makeStep);
				
				_currTarget = null;
				
				stopMove();
				
				return;
			}
			
			_currTarget = _targets.shift();
			
			if (_currTarget.x == _mapX && _currTarget.y == _mapY)
			{
				(_callbacks.shift())();
				
				makeNextTarget();
				
				return;
			}
			
			_currWay = mapController.buildWay(new Point(_mapX, _mapY), new Point(_currTarget.x, _currTarget.y));
			
			_currInd = 1;
			
			_currWayPoint.x = _currWay.way[1].x * Map.CellWidth;
			_currWayPoint.y = _currWay.way[1].y * Map.CellHeight;
			*/
		}

		public function stop() : void
		{
			_stop = true;
		}
		
		protected function makeStep(e : Event) : void
		{
			/*if (_stop)
			{
				removeEventListener(Event.ENTER_FRAME, makeStep);
				
				_stop = false;
				
				stopMove();
				
				_currTarget = null;
				
				return;
			}
			
			var delta : Vector3D = new Vector3D(_currWayPoint.x - _sprite.x + 3, _currWayPoint.y - _sprite.y + 3);
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
			
			var isNear : Boolean = (Math.abs(delta.x) < Avatar.Epsilon) && (Math.abs(delta.y) < Avatar.Epsilon); 
			if (isNear)
			{
				_mapX = _currWayPoint.x / Map.CellWidth;
				_mapY = _currWayPoint.y / Map.CellHeight;
				
				if (_currTarget.x == _mapX && _currTarget.y == _mapY)
				{
					(_callbacks.shift())();
					
					makeNextTarget();
				}
				else
				{
					makeNextWayPoint();
				}
			}*/
		}
		
		protected function makeNextWayPoint() : void
		{
			_currInd++;
			
			_currWayPoint.x = _currWay.way[_currInd].x * Map.CellWidth;
			_currWayPoint.y = _currWay.way[_currInd].y * Map.CellWidth;
		}
		
		public function get mapX():int
		{
			return _mapX;
		}

		public function set mapX(value:int):void
		{
			_mapX = value;
			
			_sprite.moveTo((mapX) * Map.CellWidth + 3, (mapY) * Map.CellHeight + 3, 0);
		}

		public function get mapY():int
		{
			return _mapY;
		}

		public function set mapY(value:int):void
		{
			_mapY = value;
			
			_sprite.moveTo((mapX) * Map.CellWidth + 3, (mapY) * Map.CellHeight + 3, 0);
		}

		public function get dir():int
		{
			return _dir;
		}

		public function set dir(val : int) : void
		{
			_dir = val;
			
			dirChanged();
		}
		
		protected function dirChanged() : void
		{
			
		}
		
		protected function startMove() : void
		{
			
		}
		
		protected function stopMove() : void
		{
			
		}
		
		public function get avatarIsoSprite() : IsoSprite
		{
			return _sprite;
		}
		
		public function get mapController() : MapController
		{
			return ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
		}
	}
}