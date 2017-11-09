package com.sigma.socialgame.view.game.map.objects
{
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.events.view.gui.GuiManagerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.common.MouseModes;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.gui.GuiManager;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import flash.geom.Point;

	public class DecorWallEntity extends WallEntity
	{
		public function DecorWallEntity()
		{
			super();
			name = "wall";
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
							case MouseModes.Select:
								
								if (Map.instance.canInteract(this))
									if (ResourceManager.instance.myOffice)
										if (!moving)
										{
											GuiManager.instance.showEntityMenu(this);
										}
										else
											//toggleMove();
								
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
				}
		}
		
		protected override function setCoords(mapX_:int, mapY_:int):void
		{
			super.setCoords(mapX_, mapY_);
			
			if (mapX_ == MapRotation.NorthWest)
				_sprite.moveBy(2, 1, 0);
			else
				_sprite.moveBy(1, 2, 0);
		}
	}
}