package com.sigma.socialgame.view.game.map.objects
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.geom.Point;

	public class TrimWallEntity extends WallEntity
	{
		public function TrimWallEntity()
		{
			super();
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
					
					switch (Field.instance.mouseMode)
					{
						case MouseModes.Select:
							
							if (Map.instance.canInteract(this))
								if (ResourceManager.instance.myOffice)
									if (moving)
										//toggleMove();
							
							break;
						
						default:
							if (Map.instance.moving === this)
							{
								//toggleMove();
							}
					}					

				
				}
		}
		
		protected static var tempInd : int = -20000;
		protected var wasInd : int;
		
		/*public override function toggleMove(first_:Boolean=false):Boolean
		{
			if (!moving)
			{
				//cellHightLighter.visible = true;
				//cellHightLighter.hightLight(wallClient.checkPos(wallClient.wallObject.wall, wallClient.wallObject.x), wallClient.wallObject.wall);
				
				_wasX = wallClient.wallObject.wall;
				_wasY = wallClient.wallObject.x;
				
				_firstMove = first_;
				
				moving = !moving;
				
				if (moving)
					Map.instance.startMove(this);
				else
					return Map.instance.endMove();
				
				if (_firstMove)
				{
					wasInd = wallClient.wallObject.storeObject.storeObject.storeId.storeId;
					wallClient.wallObject.storeObject.storeObject.storeId.storeId = tempInd--;
				}
				
				return false;
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
					
					_firstMove = first_;
					
					moving = !moving;

					var app : Boolean = false;
					
					if (wallClient.wallObject.storeObject.storeObject.storeId.storeId <= -20000)
						wallClient.wallObject.storeObject.storeObject.storeId.storeId = wasInd;
					
					if (moving)
						Map.instance.startMove(this);
					else
						app = Map.instance.endMove();
					
					wallClient.move(pos.x, pos.y, !app);
					
					_firstMove = false;
					
					setCoords(pos.x, pos.y);
					
					setRotation(pos.x);

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
		
		protected override function setCoords(mapX_ : int, mapY_ : int) : void
		{
			super.setCoords(mapX_, mapY_);
			
			if (_firstMove)
			{
				_sprite.moveBy(1, 1, 0);
				
/*				if (mapX_ == MapRotation.NorthWest)
					_sprite.moveTo(-Map.CellWidth + 1, (mapY_) * Map.CellHeight + 1, 0);
				else
					_sprite.moveTo((mapY_) * Map.CellWidth + 1, -Map.CellHeight + 1, 0);
*/			}
			else
			{
				_sprite.moveBy(1, 1, 0);
/*				if (mapX_ == MapRotation.NorthWest)
					_sprite.moveTo(-Map.CellWidth, (mapY_) * Map.CellHeight, 0);
				else
					_sprite.moveTo((mapY_) * Map.CellWidth, -Map.CellHeight, 0);
*/			}
		}
	}
}