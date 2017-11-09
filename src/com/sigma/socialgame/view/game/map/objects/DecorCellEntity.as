package com.sigma.socialgame.view.game.map.objects
{
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
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DecorCellEntity extends CellEntity
	{
		public function DecorCellEntity()
		{
			super();
			_sprite.name = "decor";
		}
		
		public override function onMouseEvent(e:TouchEvent):void
		{
				if (e.getTouch(this, TouchPhase.HOVER) || e.getTouch(this, TouchPhase.BEGAN) || e.getTouch(this, TouchPhase.MOVED)) {
					//if (Map.instance.moving != this)
						//if (Field.instance.mouseMode != MouseModes.Rotate)
							highLight();
				} else { 
					//if (Map.instance.moving != this)
						//if (Field.instance.mouseMode != MouseModes.Rotate)
							deHightLight();
				}

				if (e.getTouch(this, TouchPhase.HOVER)) {
					
					switch (Field.instance.mouseMode)
					{
						case MouseModes.Select:

							if (Map.instance.canInteract(this))
								if (ResourceManager.instance.myOffice)
									if (!moving)
									{
										GuiManager.instance.showEntityMenuRotate(this);
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
				}
		}
	}
}