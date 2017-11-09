package com.sigma.socialgame.view.game.map.objects
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.map.clients.CellClient;
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.events.controller.MapClientEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.GraphicStates;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	
	public class CellEntity extends GameEntity
	{
		public static const TAG : String = "CellEntity";

		public static const Height : int = 150;
		
		protected var _startPos : Point;
		
		private var _layer : int;
		
		public function CellEntity()
		{
			super();
			_sprite.name = "cell";
		}
		
		public function get layer():int
		{
			return _layer;
		}

		public function set layer(value:int):void
		{
			_layer = value;
		}

		public override function apply(init_ : Boolean):void
		{
			super.apply(init_);

			setCoords(cellClient.cellObject.x, cellClient.cellObject.y);
			
			//Map.instance.addEventListener(MapEvent.CellMouse, onMapEvent);
			//Map.instance.addEventListener(MapEvent.MapClicked, onMapEvent);

			correctSprite();
			Map.instance.addNode(_sprite);
		}
		
		/*public override function onMouseEvent(e:TouchEvent):void
		{
				if (e.getTouch(this, TouchPhase.HOVER) || e.getTouch(this, TouchPhase.BEGAN) || e.getTouch(this, TouchPhase.MOVED)) {
					if (Map.instance.moving != this)
						highLight();
				
				} else {
					if (Map.instance.moving != this)
						deHightLight();
				}
				
				if (e.getTouch(this, TouchPhase.ENDED)) {
					
					if (!_mapMoved) {
						switch (Field.instance.mouseMode)
						{
							case MouseModes.Rotate:
								
								if (Map.instance.canInteract(this))
									if (ResourceManager.instance.myOffice)
										rotate();
								
								break;
							
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
				
		}*/
		
		public override function sell():void
		{
			Map.instance.sellObject(this);
		}
		
		public override function remove():void
		{
			super.remove();
			
			//Map.instance.removeEventListener(MapEvent.MapClicked, onMapEvent);
			//Map.instance.removeEventListener(MapEvent.CellMouse, onMapEvent);
		}
		
		public override function rotate(rot_ : int = -1) : void
		{
			if (rot_ == -1)
			{
				if (cellClient.canRotate)
					if (cellClient.checkRot(MapRotation.next(cellClient.cellObject.rotation)))
					{
						cellClient.rotate(MapRotation.next(cellClient.cellObject.rotation));
						
						if (graphicLoader.loaded)
							setRotation(cellClient.cellObject.rotation);
					}
					else if (cellClient.checkRot(MapRotation.next(MapRotation.next(cellClient.cellObject.rotation))))
					{
						cellClient.rotate(MapRotation.next(MapRotation.next(cellClient.cellObject.rotation)));
						
						if (graphicLoader.loaded)
							setRotation(cellClient.cellObject.rotation);
					}
			}
			else
			{
				if (cellClient.canRotate)
					if (cellClient.checkRot(rot_))
					{
						cellClient.rotate(rot_);
						
						if (graphicLoader.loaded)
							setRotation(cellClient.cellObject.rotation);
					}
			}
			Map.instance.renderScene();
		}
		
		/*public override function toggleMove(first_ : Boolean = false) : Boolean
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
					
					var currPoint : Point = Map.instance.mouseCell; 
					
					if (currPoint != null)
						if (_wasX != currPoint.x || _wasY != currPoint.y)
						{
							var newMEvent : MapEvent = new MapEvent(MapEvent.CellMouse);
							newMEvent.coords = Map.instance.mouseCell;
							Map.instance.dispatchEvent(newMEvent);
						}
					
					return super.toggleMove(first_);
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
					
					var app : Boolean = super.toggleMove(first_);
					
					cellClient.move(pos.x, pos.y, !app);
					
					_firstMove = false;
					
					setCoords(pos.x, pos.y);
					
					return app;
				}
			}
			
			return false;
		}*/
		
		protected var _wasX : int;
		protected var _wasY : int;
		
		/*protected function onMapEvent(e : MapEvent) : void
		{
			trace(e)
			if (!_mapMoved) {
				switch (e.type)
				{
					case MapEvent.MapClicked:
						
						if (moving)
						{
							//toggleMove();
							
							Map.instance.skipOne = true;
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
						
						setCoords(newPos.x, newPos.y);
						
						_wasX = newPos.x;
						_wasY = newPos.y;
						
						break;
				}
			} else {
				_mapMoved = false;
			}
		}*/
		
		override public function move(x_:int, y_:int):Boolean {
			
			setCoords(x_, y_);			
			
			cellClient.cellObject.x = x_;
			cellClient.cellObject.y = y_;
			
			var correct:Boolean = cellClient.checkPos(x_, y_);
			correct ? deHightLight() :	wrongLight();
			
			Map.instance.removeNode(_sprite);
			
			Map.instance.addNode(_sprite);
			
			return correct;
		}
		
		protected override function setRotation(rot_ : int) : void
		{
			var state : String;
			
			switch (rot_)
			{
				case MapRotation.NorthWest:
					state = GraphicStates.NW;
					
					graphicLoader.scaleX = 1.0;
					break;
				
				case MapRotation.NorthEast:
					if (cellClient.cellObject.sides == 1)
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
				
				case MapRotation.SouthEast:
					if (cellClient.cellObject.sides == 1)
					{
						state = GraphicStates.NW;
						
						graphicLoader.scaleX = 1.0;
					}
					else if (cellClient.cellObject.sides == 2)
					{
						state = GraphicStates.NE;
						
						graphicLoader.scaleX = -1.0;
					}
					else if (cellClient.cellObject.sides == 4)
					{
						state = GraphicStates.SE;
						
						graphicLoader.scaleX = 1.0;
					}
					break;
				
				case MapRotation.SouthWest:
					if (cellClient.cellObject.sides == 1)
					{
						state = GraphicStates.NW;
						
						graphicLoader.scaleX = -1.0;
					}
					else if (cellClient.cellObject.sides == 2)
					{
						state = GraphicStates.NW;
						
						graphicLoader.scaleX = -1.0;
					}
					else
					{
						state = GraphicStates.SW;
						
						graphicLoader.scaleX = 1.0;
					}
					break;
			}
			
			if (graphicLoader.state != state)
				graphicLoader.selectState(state);
			
			correctSprite();
		}
		
		protected function correctSprite() : void
		{
			_sprite.setSize(cellClient.cellObject.xLength * Map.CellWidth - 6, cellClient.cellObject.yLength * Map.CellHeight - 6, Height);
			
			var vec3 : Vector3D = Map.instance.getCellCoords(cellClient.cellObject.xLength, cellClient.cellObject.yLength);
			
			x = vec3.x;
			y = vec3.y;
		}
		
		protected override function setCoords(mapX_ : int, mapY_ : int) : void
		{
			var coords : Point = Map.instance.getCellSpaceCoords(mapX_, mapY_);
			
			_sprite.moveTo(coords.x + 3, coords.y + 3, 0);
//			_sprite.moveTo((mapX_) * Map.CellWidth + 3, (mapY_) * Map.CellHeight + 3, 0);
		}
		
		protected override function onGraphicLoaded(e : GraphicLoaderEvent) : void
		{
			setRotation(cellClient.cellObject.rotation);
		}
		
		protected override function onMapUpdated(e : MapClientEvent) : void
		{
			setCoords(cellClient.cellObject.x, cellClient.cellObject.y);
			setRotation(cellClient.cellObject.rotation);
		}
		
		protected override function onMapRemoved(e : MapClientEvent) : void
		{
			remove();
			//TODO correct remove
		}
		
		protected function deHightLight() : void
		{
			graphicLoader.filter = null;			
			if (Map.instance.mouseCell == this) Map.instance.mouseCell = null;
		}
		
		protected function highLight() : void
		{
			Map.instance.mouseCell = this;
			graphicLoader.filter = hFilter;
		}
		
		protected function wrongLight() : void
		{
			if (graphicLoader.filter!=wrongFilter) graphicLoader.filter = wrongFilter;
		}		
		
		public function get cellClient() : CellClient
		{
			return mapClient as CellClient;
		}
		
		public function get cellX():int
		{
			return cellClient.cellObject.x;
		}
		
		public function get cellY():int
		{
			return cellClient.cellObject.y;
		}
		
		public function get cellRotation() : int
		{
			return cellClient.cellObject.rotation;
		}
		
		public function get cellWidth():int
		{
			return cellClient.cellObject.width;
		}
		
		public function get cellHeight():int
		{
			return cellClient.cellObject.height;
		}

		public override function set mapClient(value:MapClient):void
		{
			super.mapClient = value;
		}
		
		public override function toString() : String
		{
			return super.toString() + "\nCellClient: " + (cellClient == null ? cellClient : cellClient.toString());
		}
		
		protected var _mapMoved : Boolean = false;
		
		public function set mapMoved(value:Boolean):void {
			_mapMoved = value;
		}
	}
}