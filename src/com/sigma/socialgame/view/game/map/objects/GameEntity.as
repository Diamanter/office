package com.sigma.socialgame.view.game.map.objects
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.controller.entity.clients.EntityClient;
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.events.controller.EntityClientEvent;
	import com.sigma.socialgame.events.controller.MapClientEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.view.game.map.Map;
	import com.sigma.socialgame.view.game.map.objects.graphic.CellHighlighter;
	import com.sigma.socialgame.view.game.map.objects.graphic.GraphicLoader;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import starling.filters.BloomFilter;
	import starling.filters.BleachFilter;

	public class GameEntity extends Sprite
	{
		public static const TAG : String = "GameEntity";
		
		private var _mapClient : MapClient;
		private var _entClient : EntityClient;
		
		private var _graphicLoader : GraphicLoader;
		//private var _cellHightLight : CellHighlighter;
		
		private var _moving : Boolean = false;
		private var _removed : Boolean;
		
		protected var _sprite : IsoSprite;
		protected var hFilter:ColorMatrixFilter = new ColorMatrixFilter(new <Number>[1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0]);
		protected var wrongFilter:ColorMatrixFilter = new ColorMatrixFilter(new <Number>[2,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,0.5,0]);
		protected var bloomFilter:BloomFilter = new BloomFilter(3.5, 3, 1.5, 0.9);
		protected var bleachFilter:BleachFilter = new BleachFilter(0.5);
		
		public function GameEntity()
		{
			super();
			
			_sprite = new IsoSprite();
			_sprite.name = "entity";
			
			_removed = false;
			
			hFilter.resolution = 2;
			hFilter.adjustContrast(0.3);
			hFilter.adjustSaturation(0.7);
		}
		
		public function onMouseEvent(e : TouchEvent) : void
		{
			Logger.message("Using abstract function \"onMouseEvent\"", TAG, LogLevel.Warning, LogModule.View);
			Logger.message(e.type, "", LogLevel.Debug, LogModule.View);
		}
		
		public function apply(init_ : Boolean) : void
		{
			_sprite.sprites = [this];
			
			//cellHightLighter = new CellHighlighter();
			//cellHightLighter.mapObject = _mapClient.mapObject;
			//cellHightLighter.visible = false;
			
			//addChild(cellHightLighter);
			
			_graphicLoader = new GraphicLoader();
			_graphicLoader.mapObject = _mapClient.mapObject;
			_graphicLoader.addEventListener(GraphicLoaderEvent.Loaded, onGraphicLoaded);
			_graphicLoader.load();
			
			addChild(_graphicLoader);
			addEventListener(TouchEvent.TOUCH, onMouseEvent);
	
			//Map.instance.addNode(_sprite);
		}
		
		protected var _firstMove : Boolean = false;
		
		/*public function toggleMove(first_ : Boolean = false) : Boolean
		{
			_firstMove = first_;
			
			moving = !moving;
			
			if (moving)
				Map.instance.startMove(this);
			else
				return Map.instance.endMove();
			
			return false;
		}*/
		
		public function rotate(rot_ : int = -1) : void
		{
			Logger.message("Using abstract function \"rotate\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		public function sell() : void
		{
			Logger.message("Using abstract function \"sell\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function onGraphicLoaded(e : GraphicLoaderEvent) : void
		{
			Logger.message("Using abstract function \"onGraphicLoaded\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function setCoords(mapX_ : int, mapY_: int) : void
		{
			Logger.message("Using abstract function \"setCoords\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function setRotation(rot_ : int) : void
		{
			Logger.message("Using abstract function \"setRotation\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function onMapUpdated(e : MapClientEvent) : void
		{
			Logger.message("Using abstract function \"onMapUpdated\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function onMapRemoved(e : MapClientEvent) : void
		{
			Logger.message("Using abstract function \"onMapRemoved\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function onEntityUpdated(e : EntityClientEvent) : void
		{
			Logger.message("Using abstract function \"onEntityUpdated\"", TAG, LogLevel.Warning, LogModule.View);
		}
		
		protected function onEntityRemoved(e : EntityClientEvent) : void
		{
			Logger.message("Using abstract function \"onEntityRemoved\"", TAG, LogLevel.Warning, LogModule.View);
		}

		public function get entityClient() : EntityClient
		{
			return _entClient;
		}
		
		public function set entityClient(entClient_ : EntityClient) : void
		{
			_entClient = entClient_;
			
			if (_entClient) {			
				_entClient.addEventListener(EntityClientEvent.Updated, onEntityUpdated);
				_entClient.addEventListener(EntityClientEvent.Removed, onEntityRemoved);
			}
		}
		
		/*protected function get cellHightLighter() : CellHighlighter
		{
			return _cellHightLight;
		}*/
		
		/*protected function set cellHightLighter(cellHigh_ : CellHighlighter) : void
		{
			_cellHightLight = cellHigh_;
		}*/
		
		protected function get graphicLoader() : GraphicLoader
		{
			return _graphicLoader;
		}
		
		protected function set graphicLoader(grLoader_ : GraphicLoader) : void
		{
			_graphicLoader = grLoader_;
		}
		
		public function get mapClient():MapClient
		{
			return _mapClient;
		}

		protected function get removed() : Boolean
		{
			return _removed;
		}
		
		public function remove() : void
		{
			Map.instance.removeNode(_sprite);
			
			_removed = true;
			
			if (moving)
			{
				moving = false;
				
				if (Map.instance.moving === this)
					Map.instance.moving = null;
			}
			//toggleMove();
		}
		
		public function set mapClient(value:MapClient):void
		{
			_mapClient = value;
			
			if (_mapClient != null)
			{
				_mapClient.addEventListener(MapClientEvent.Updated, onMapUpdated);
				_mapClient.addEventListener(MapClientEvent.Removed, onMapRemoved);
			}
		}

		public function toString():String
		{
			return "EntClient: " + (_entClient == null ? _entClient : _entClient.toString()) + "\nMapClient: " + (_mapClient == null ? _mapClient : _mapClient.toString());
		}

		public function get moving():Boolean
		{
			return _moving;
		}

		public function set moving(value:Boolean):void
		{
			_moving = value;
		}
		public function move(x_ : int, y_ : int) : Boolean
		{
			return false;
		}		

	}
}