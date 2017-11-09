package com.sigma.socialgame.view.game.map.objects
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.controller.map.clients.WallClient;
	import com.sigma.socialgame.events.controller.MapClientEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.GraphicStates;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiIds;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class WallEntity extends GameEntity
	{
		public static const TAG : String = "WallEntity";
		private var _rot:int = 0;
		
		public function WallEntity()
		{
			super();
			_sprite.name = "wall";
		}
		
		public override function apply(init_ : Boolean):void
		{
			super.apply(init_);
	
			setCoords(wallClient.wallObject.wall, wallClient.wallObject.x);
			
			//Map.instance.addEventListener(MapEvent.MapClicked, onMapEvent);
			//Map.instance.addEventListener(MapEvent.WallMouse, onMapEvent);
			
			correctSprite(wallClient.wallObject.wall);
			Map.instance.addNode(_sprite);
		}
		
		public override function onMouseEvent(e:TouchEvent):void
		{
				if (e.getTouch(this, TouchPhase.HOVER) || e.getTouch(this, TouchPhase.BEGAN) || e.getTouch(this, TouchPhase.MOVED)) {
					if (Map.instance.moving != this)
						if (Field.instance.mouseMode != MouseModes.Rotate)
							highLight();
				} else { 
					if (Map.instance.moving != this)
						if (Field.instance.mouseMode != MouseModes.Rotate)
							deHightLight();
				}
				
				
				if (e.getTouch(this, TouchPhase.ENDED)) {
					
					if (!_mapMoved) {
						switch (Field.instance.mouseMode)
						{
							case MouseModes.Move:
								
								if (Map.instance.canInteract(this))
									if (ResourceManager.instance.myOffice)
										//toggleMove();
								
								break;
							
							case MouseModes.Sell:
								
								if (Map.instance.canInteract(this))
									if (ResourceManager.instance.myOffice)
										sell();
								
								break;
						}
					} else {
						_mapMoved = false;
					}
				}
		}
		
		protected var _wasX : int;
		protected var _wasY : int;
		
		/*public override function toggleMove(first_ : Boolean = false) : Boolean
		{
			if (!moving)
			{
				//cellHightLighter.visible = true;
				//cellHightLighter.hightLight(wallClient.checkPos(wallClient.wallObject.wall, wallClient.wallObject.x), wallClient.wallObject.wall);
				
				_wasX = wallClient.wallObject.wall;
				_wasY = wallClient.wallObject.x;
				
				var currPoint : Point = Map.instance.mouseWall; 
				
				var ret : Boolean = super.toggleMove(first_); 
				
				if (currPoint != null)
					if (_wasX != currPoint.x || _wasY != currPoint.y)
					{
						var newMEvent : MapEvent = new MapEvent(MapEvent.WallMouse);
						newMEvent.coords = Map.instance.mouseWall;
						Map.instance.dispatchEvent(newMEvent);
					}
				
				return ret;
			}
			else
			{
				var pos : Point = Map.instance.mouseWall;
				
				if (pos == null)
					return false;
				
				if (wallClient.checkPos(pos.x, pos.y))
				{
					//cellHightLighter.visible = false;
					
					_wasX = pos.x;
					_wasY = pos.y;

					Map.instance._boughtX = _wasX;
					Map.instance._boughtY = _wasY;
					
					var app : Boolean = super.toggleMove(first_);
					
					wallClient.move(pos.x, pos.y, !app);
					
					_firstMove = false;
					
					setCoords(pos.x, pos.y);
				
					setRotation(pos.x);
					
					return app;
				}
			}
			
			return false;
		}*/
		
		public override function remove():void
		{
			super.remove();
			
			//Map.instance.removeEventListener(MapEvent.MapClicked, onMapEvent);
		}
		
		public override function sell():void
		{
			Map.instance.sellObject(this);
		}
		
		public function deHightLight() : void
		{
			graphicLoader.filter = null;			
			if (Map.instance.mouseWall == this) Map.instance.mouseWall = null;
		}
		
		protected function wrongLight() : void
		{
			if (graphicLoader.filter!=wrongFilter) graphicLoader.filter = wrongFilter;
		}		
		
		public function highLight() : void
		{
			//if (!Map.instance.canInteract(this))
				//return;
			
			/*var matrix : Vector.<Number> = new Vector.<Number>();
			
			matrix = matrix.concat(new <Number>[2, 0, 0, 0, 100]); // red
			matrix = matrix.concat(new <Number>[0, 1, 0, 0, 100]); // green
			matrix = matrix.concat(new <Number>[0, 0, 1, 0, 100]); // blue
			matrix = matrix.concat(new <Number>[0, 0, 0, 1, 0]); // alpha
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);*/
			
			Map.instance.mouseWall = this;

			graphicLoader.filter = hFilter;
		}
		
		/*protected function onMapEvent(e : MapEvent) : void
		{
			switch (e.type)
			{
				case MapEvent.MapClicked:
					
					if (moving)
					{
						//toggleMove();
						
						Map.instance.skipOne = true;
					}
					
					break;
				
				case MapEvent.WallMouse:
					
					if (!moving)
						return;
					
					//cellHightLighter.visible = true;
					//cellHightLighter.hightLight(wallClient.checkPos(e.coords.x, e.coords.y), e.coords.x);
					
					setCoords(e.coords.x, e.coords.y);
					
					_wasX = e.coords.x;
					_wasY = e.coords.y;
					
					setRotation(e.coords.x);
					
					break;
			}
		}*/
		
		protected function correctSprite(wall_ : int) : void
		{
			var vec3 : Vector3D;
			
			if (wall_ == MapRotation.NorthWest)
			{
				_sprite.setSize(1, wallClient.wallObject.width * Map.CellHeight - 2, 100);
				vec3 = Map.instance.getWallCoords(MapRotation.NorthEast, wallClient.wallObject.width);
			}
			else
			{
				_sprite.setSize(wallClient.wallObject.width * Map.CellWidth - 2, 1, 100);
				vec3 = Map.instance.getWallCoords(MapRotation.NorthWest, wallClient.wallObject.width);
			}
		
			x = vec3.x;
			y = vec3.y+5;
		}
		
		protected override function setCoords(mapX_ : int, mapY_ : int) : void
		{
			var coords : Point = Map.instance.getWallSpaceCoords(mapX_, mapY_);
			
			_sprite.moveTo(coords.x, coords.y, 0);
		}
		
		override public function move(x_:int, y_:int):Boolean {
			
			trace(x_, y_)
			setCoords(x_, y_);			
			
			if (y_==1) {
				setRotation(1);
				wallClient.wallObject.x = x_;
			} else {
				setRotation(0);
				wallClient.wallObject.x = x_;
			}
			//wallClient.wallObject.y = y_;
			
			var correct:Boolean = wallClient.checkPos(x_, y_);
			correct ? deHightLight() :	wrongLight();
			
			Map.instance.removeNode(_sprite);
			
			Map.instance.addNode(_sprite);
			
			return correct;
		}
		
		public function getRotation() : int
		{
			return _rot;
		}
		
		protected override function setRotation(rot_ : int) : void
		{
			_rot = rot_;
			var state : String;
			
			switch (rot_)
			{
				case MapRotation.NorthWest:
					state = GraphicStates.NW;
					
					graphicLoader.scaleX = 1.0;
					break;
				
				case MapRotation.NorthEast:
					if (wallClient.wallObject.sides == 1)
					{
						state = GraphicStates.NW;
						
						graphicLoader.scaleX = -1.0;
					}
					else
					{
						state = GraphicStates.NE;
						
						graphicLoader.scaleX = 1.0;
					}
					break;
			}
			
			if (graphicLoader.state != state)
				graphicLoader.selectState(state);
			
			correctSprite(rot_);
		}
		
		protected override function onGraphicLoaded(e:GraphicLoaderEvent):void
		{
			setRotation(wallClient.wallObject.wall);
		}
		
		protected override function onMapUpdated(e : MapClientEvent) : void
		{
			setCoords(wallClient.wallObject.wall, wallClient.wallObject.x);
			setRotation(wallClient.wallObject.wall);
		}
		
		protected override function onMapRemoved(e : MapClientEvent) : void
		{
			remove();
		}
		
		public override function set mapClient(value:MapClient):void
		{
			super.mapClient = value;
		}
		
		protected function get wallClient():WallClient
		{
			return mapClient as WallClient;
		}
		
		public function get wall():int
		{
			return wallClient.wallObject.wall;
		}
		
		public function get wallX():int
		{
			return wallClient.wallObject.x;
		}
		
		public function get wallWidth():int
		{
			return wallClient.wallObject.width;
		}
		
		public override function toString():String
		{
			return super.toString() + "\nWallClient: " + (wallClient == null ? wallClient : wallClient.toString());
		}
		
		protected var _mapMoved : Boolean = false;
		
		public function set mapMoved(value:Boolean):void {
			_mapMoved = value;
		}
	}
}