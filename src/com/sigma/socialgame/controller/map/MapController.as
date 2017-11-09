package com.sigma.socialgame.controller.map
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.Controller;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.map.clients.CellClient;
	import com.sigma.socialgame.controller.map.clients.WallClient;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapCell;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.controller.map.objects.MapWall;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.controller.map.way.Way;
	import com.sigma.socialgame.controller.wallet.objects.WalletObject;
	import com.sigma.socialgame.events.controller.MapControllerEvent;
	import com.sigma.socialgame.events.model.ResourceSynchronizerEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.model.objects.config.object.WallObjectData;
	import com.sigma.socialgame.model.objects.sync.map.CellMapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.MapObjectData;
	import com.sigma.socialgame.model.objects.sync.map.WallMapObjectData;
	import com.sigma.socialgame.model.objects.sync.store.StoreObjectData;
	import com.sigma.socialgame.view.game.map.Map;	
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class MapController extends Controller
	{
		public static const TAG : String = "MapController";
		
		private var _cells : Vector.<Vector.<MapCell>>;
		private var _cellObjects : Vector.<CellObject>;
		
		private var _walls : Vector.<Vector.<MapWall>>;
		private var _wallObjects : Vector.<WallObject>;

		private var _cellClients : Dictionary;
		private var _wallClients : Dictionary;
		
		private var _mapWidth : int;
		private var _mapHeight : int;
		
		public function MapController()
		{
			super(ControllerNames.MapController);
		}
		
		public override function init():void
		{
			Logger.message("Initing map controller.", TAG, LogLevel.Info, LogModule.Controller);
			
			_cells = new Vector.<Vector.<MapCell>>();
			_cellObjects = new Vector.<CellObject>();
			
			_walls = new Vector.<Vector.<MapWall>>();
			_wallObjects = new Vector.<WallObject>();
			
			_cellClients = new Dictionary();
			_wallClients = new Dictionary();
			
			dispatchEvent(new MapControllerEvent(MapControllerEvent.Inited));
			
			Logger.message("Map controller inited.", "MapConrtoller", LogLevel.Info, LogModule.Controller);
		}
		
		public override function start() : void
		{
			Logger.message("Starting map controller.", TAG, LogLevel.Info, LogModule.Controller);
			
			_mapWidth = ResourceManager.instance.mapWidth;
			_mapHeight = ResourceManager.instance.mapHeight;
			
			Logger.message("\nWidth: " + _mapWidth + "\nHeight: " + _mapHeight, "", LogLevel.Debug, LogModule.Controller);
			
			var i : int;
			var j : int;
			
			for (i = 0; i < _mapWidth; i++)
			{
				_cells[i] = new Vector.<MapCell>();
				
				for (j = 0; j < _mapHeight; j++)
				{
					_cells[i][j] = new MapCell();
					
					_cells[i][j].x = i;
					_cells[i][j].y = j;
				}
			}
			
			var dim : Vector.<int> = new Vector.<int>();
			
			dim[0] = _mapWidth;
			dim[1] = _mapHeight;
			
			for (i = 0; i < 2; i++)
			{
				_walls[i] = new Vector.<MapWall>();
				
				for (j = 0; j < dim[i]; j++)
				{
					_walls[i][j] = new MapWall();
					
					_walls[i][j].wall = i;
					_walls[i][j].x = j;
				}
			}
			
			for each (var cellOD : CellMapObjectData in ResourceManager.instance.mapCells)
			{
				if (cellOD) addCellObject(cellOD, true);
			}
			
			for each (var wallOD : WallMapObjectData in ResourceManager.instance.mapWalls)
			{
				if (wallOD) addWallObject(wallOD, true);
			}
			
			Logger.message("Map controller started.", TAG, LogLevel.Info, LogModule.Controller);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.CellObjectChanged, onCellSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.CellObjectRemoved, onCellSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.CellObjectAdded, onCellSyncEvent);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.WallObjectChanged, onWallSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.WallObjectRemoved, onWallSyncEvent);
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.WallObjectAdded, onWallSyncEvent);
			
			ResourceManager.instance.addEventListener(ResourceSynchronizerEvent.MapDimChanged, onDimChanged);
			
			dispatchEvent(new MapControllerEvent(MapControllerEvent.Started));
		}
		
		public override function reload():void
		{
			_cells = new Vector.<Vector.<MapCell>>();
			_cellObjects = new Vector.<CellObject>();
			
			_walls = new Vector.<Vector.<MapWall>>();
			_wallObjects = new Vector.<WallObject>();
			
			_cellClients = new Dictionary();
			_wallClients = new Dictionary();
			
			_mapWidth = ResourceManager.instance.mapWidth;
			_mapHeight = ResourceManager.instance.mapHeight;
			
			Logger.message("\nWidth: " + _mapWidth + "\nHeight: " + _mapHeight, "", LogLevel.Debug, LogModule.Controller);
			
			var i : int;
			var j : int;
			
			for (i = 0; i < _mapWidth; i++)
			{
				_cells[i] = new Vector.<MapCell>();
				
				for (j = 0; j < _mapHeight; j++)
				{
					_cells[i][j] = new MapCell();
					
					_cells[i][j].x = i;
					_cells[i][j].y = j;
				}
			}
			
			var dim : Vector.<int> = new Vector.<int>();
			
			dim[0] = _mapWidth;
			dim[1] = _mapHeight;
			
			for (i = 0; i < 2; i++)
			{
				_walls[i] = new Vector.<MapWall>();
				
				for (j = 0; j < dim[i]; j++)
				{
					_walls[i][j] = new MapWall();
					
					_walls[i][j].wall = i;
					_walls[i][j].x = j;
				}
			}
			
			for each (var cellOD : CellMapObjectData in ResourceManager.instance.mapCells)
			{
				addCellObject(cellOD, true);
			}
			
			for each (var wallOD : WallMapObjectData in ResourceManager.instance.mapWalls)
			{
				addWallObject(wallOD, true);
			}
		}
		
		public function howManyWorkers() : int
		{
			var res : int = 0;
			
			for each (var mo : MapObject in _cellObjects)
			{
				if (mo.storeObject.storeObject.object.type == ObjectTypes.Worker)
				{
					res++;
				}
			}
			
			return res;
		}
		
		public function findCellObjectBySOD(storeObject_ : StoreObjectData) : CellObject
		{
			for each (var cellobj : CellObject in _cellObjects)
			{
				if (cellobj.mapObject.storeObject.storeId.equals(storeObject_.storeId))
				{
					return cellobj;
				}
			}
			
			return null;
		}
		
		public function findWallObjectBySOD(storeObject_ : StoreObjectData) : WallObject
		{
			for each (var wallobj : WallObject in _wallObjects)
			{
				if (wallobj.mapObject.storeObject.storeId.equals(storeObject_.storeId))
				{
					return wallobj;
				}
			}
			
			return null;
		}
		
		public function findCellObject(cellObj_ : CellMapObjectData) : CellObject
		{
			for each (var cellobj : CellObject in _cellObjects)
			{
				if (cellobj.mapObject.storeObject.storeId.equals(cellObj_.storeObject.storeId))
				{
					return cellobj;
				}
			}
			
			return null;
		}
		
		public function findWallObject(wallObj_ : WallMapObjectData) : WallObject
		{
			for each (var wallobj : WallObject in _wallObjects)
			{
				if (wallobj.mapObject.storeObject.storeId.equals(wallObj_.storeObject.storeId))
				{
					return wallobj;
				}
			}
			
			return null;
		}
		
		protected function onCellSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			trace("sync", e)
			var cellObj : CellObject;// = findCellObject(e.cellObject);
			var client : CellClient;// = _cellClients[cellObj];
			
			var mcEvent : MapControllerEvent;
			var newCellObject : CellObject;
			
			switch (e.type)
			{
				case ResourceSynchronizerEvent.CellObjectChanged:
					
					cellObj = findCellObject(e.cellObject);
					client = _cellClients[cellObj];
					
					if (client != null)
					{
						client.updated();
					}
					
					clearCellObject(cellObj);
					applyCellObject(cellObj);
					
					break;
				
				case ResourceSynchronizerEvent.CellObjectRemoved:
					
					cellObj = findCellObject(e.cellObject);
					client = _cellClients[cellObj];
					
					if (client != null)
					{
						client.removed();
						
						removeCellClientByObj(cellObj);
					}
					
					removeCellObject(cellObj);
					
					break;
				
				case ResourceSynchronizerEvent.CellObjectAdded:
					
					newCellObject = addCellObject(e.cellObject, true);
					
					var newMCE : MapControllerEvent = new MapControllerEvent(MapControllerEvent.NewCellObject);
					newMCE.cellObject = newCellObject;
					dispatchEvent(newMCE);
					
					break;
			}
		}
		
		public function getDoor() : WallObject
		{
			var wallObjectData : WallObjectData = null;
			for each (var wallObject : WallObject in _wallObjects)
			{
				wallObjectData = wallObject.storeObject.storeObject.object as WallObjectData;
				if ((wallObjectData != null) && wallObjectData.isDoor)
				{
					return wallObject;
				}
			}
			
			return null;
		}
		
		protected function onWallSyncEvent(e : ResourceSynchronizerEvent) : void
		{
			var wallObj : WallObject;// = findWallObject(e.wallObject);
			var client : WallClient;// = _wallClients[wallObj];
			
			var mcEvent : MapControllerEvent;
			var newWallObject : WallObject;
			
			switch (e.type)
			{
				case ResourceSynchronizerEvent.WallObjectChanged:
					
					wallObj = findWallObject(e.wallObject);
					client = _wallClients[wallObj];
					
					if (client != null)
					{
						client.updated();
					}
					
					clearWallObject(wallObj);
					applyWallObject(wallObj);
					
					break;
				
				case ResourceSynchronizerEvent.WallObjectRemoved:
					
					wallObj = findWallObject(e.wallObject);
					client = _wallClients[wallObj];
					
					if (client != null)
					{
						client.removed();
						
						removeWallClientByObj(wallObj);
					}
					
					removeWallObject(wallObj);
					
					break;
				
				case ResourceSynchronizerEvent.WallObjectAdded:
					
					newWallObject = addWallObject(e.wallObject, true);
					
					var newMCE : MapControllerEvent = new MapControllerEvent(MapControllerEvent.NewWallObject);
					newMCE.wallObject = newWallObject;
					dispatchEvent(newMCE);
					
					break;
			}
		}
		
		public function get cellObjects() : Vector.<CellObject>
		{
			return _cellObjects;
		}
		
		public function get wallObjects() : Vector.<WallObject>
		{
			return _wallObjects;
		}
		
		public function get cells() : Vector.<Vector.<MapCell>>
		{
			return _cells;
		}
		
		public function get walls() : Vector.<Vector.<MapWall>>
		{
			return _walls;
		}
		
		public function get width() : int
		{
			return _mapWidth;
		}
		
		public function get height() : int
		{
			return _mapHeight;
		}
		
		public function onDimChanged(e : ResourceSynchronizerEvent) : void
		{
			var i : int;
			var j : int;
			
			for (i = 0; i < _mapWidth; i++)
			{
				for (j = _mapHeight; j < e.height; j++)
				{
					cells[i][j] = new MapCell();
					
					cells[i][j].x = i;
					cells[i][j].y = j;
				}
			}
			
			for (i = _mapWidth; i < e.width; i++)
			{
				cells[i] = new Vector.<MapCell>();
				
				for (j = 0; j < e.height; j++)
				{
					cells[i][j] = new MapCell();
					
					cells[i][j].x = i;
					cells[i][j].y = j;
				}
			}
			
			var dimWas : Array = [_mapWidth, _mapHeight];
			var dimNew : Array = [e.width, e.height];
			
			for (i = 0; i < 2; i++)
			{
				for (j = dimWas[i]; j < dimNew[i]; j++)
				{
					walls[i][j] = new MapWall();
					
					walls[i][j].wall = i;
					walls[i][j].x = j;
				}
			}
			
			_mapWidth = e.width;
			_mapHeight = e.height;
			
			var mcEvent : MapControllerEvent = new MapControllerEvent(MapControllerEvent.DimenstionChanged);
			mcEvent.width = e.width;
			mcEvent.height = e.height;
			dispatchEvent(mcEvent);
		}
		
		public function getCellClientByStoreId_(storeId_ : StoreIdentifier) : CellClient
		{
			var cellObject : CellObject;
			
			for each (var cellObj : CellObject in _cellObjects)
			{
				if (cellObj.mapObject.storeObject.storeId.equals(storeId_))
				{
					cellObject = cellObj;
					
					break;
				}
			}
			
			if (cellObject == null)
			{
				Logger.message("Could not find CellObject by specified StoreId: " + storeId_.toString(), TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			if (_cellClients[cellObject] != null)
			{
				Logger.message("Map client to specified cell object allready exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				Logger.message(cellObject.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var newClient : CellClient = MapClientFactory.createCellClient(cellObject);
			
			_cellClients[cellObject] = newClient;
			
			return newClient;
		}
		
		public function getCellClient(cellObj_ : CellObject) : CellClient
		{
			if (_cellClients[cellObj_] != null)
			{
				Logger.message("Map client to specified cell object allready exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				Logger.message(cellObj_.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var newClient : CellClient = MapClientFactory.createCellClient(cellObj_);
			
			_cellClients[cellObj_] = newClient;
			
			return newClient;
		}
		
		public function getWallClientByStoreId_(storeId_ : StoreIdentifier) : WallClient
		{
			var wallObject : WallObject;
			
			for each (var wallObj : WallObject in _wallObjects)
			{
				if (wallObj.mapObject.storeObject.storeId.equals(storeId_))
				{
					wallObject = wallObj;
					
					break;
				}
			}
			
			if (wallObject == null)
			{
				Logger.message("Could not find WallObject by specified StoreId: " + storeId_.toString(), TAG, LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			if (_wallClients[wallObject] != null)
			{
				Logger.message("Map client to specified wall object allready exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				Logger.message(wallObject.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var newClient : WallClient = MapClientFactory.createWallClient(wallObject);
			
			_wallClients[wallObject] = newClient;
			
			return newClient;
		}
		
		public function getWallClient(wallObj_ : WallObject) : WallClient
		{
			if (_wallClients[wallObj_] != null)
			{
				Logger.message("Map client to specified wall object allready exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				Logger.message(wallObj_.toString(), "", LogLevel.Error, LogModule.Controller);
				
				return null;
			}
			
			var newClient : WallClient = MapClientFactory.createWallClient(wallObj_);
			
			_wallClients[wallObj_] = newClient;
			
			return newClient;
		}
	
		protected function removeCellClientByObj(cellObject_ : CellObject) : void
		{
			var cc : CellClient = _cellClients[cellObject_];
			
			if (cc != null)
			{
				cc.removed();
			
				delete _cellClients[cellObject_];
			}
		}
		
		protected function removeCellClient(cellClient_ : CellClient) : void
		{
			if (_cellClients[cellClient_.mapObject] == null)
			{
				Logger.message("Specified cell client doesn't exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				return;
			}
			
			removeCellClientByObj(cellClient_.mapObject as CellObject);
		}
		
		protected function removeWallClientByObj(wallObejct_ : WallObject) : void
		{
			var wc : WallClient = _wallClients[wallObejct_];
			
			if (wc != null)
			{
				wc.removed();
			
				delete _wallClients[wallObejct_];
			}
		}
		
		protected function removeWallClient(wallClient_ : WallClient) : void
		{
			if (_wallClients[wallClient_.mapObject] == null)
			{
				Logger.message("Specified wall client doesn't exist.", TAG, LogLevel.Error, LogModule.Controller);
				
				return;
			}
			
			removeWallClientByObj(wallClient_.mapObject as WallObject);
		}
		
		public function addCellObject(cod_ : CellMapObjectData, initial_ : Boolean = false, x_ : int = 0, y_ : int = 0) : CellObject
		{
			var newCellObj : CellObject = MapFactory.ctreateCellObject(cod_);
			
			_cellObjects.push(newCellObj);

			if (!initial_)
			{
				newCellObj.x = x_;
				newCellObj.y = y_;
				
				var mcEvent : MapControllerEvent = new MapControllerEvent(MapControllerEvent.CellObjectAdded);
				mcEvent.cellObject = newCellObj;
				dispatchEvent(mcEvent);
			}
			
			applyCellObject(newCellObj);
			
			return newCellObj;
		}
		
		public function addWallObject(wod_ : WallMapObjectData, initial_ : Boolean = false, wall_ : int = MapRotation.NorthWest, x_ : int = 0) : WallObject
		{
			var newWallObj : WallObject = MapFactory.ctreateWallObject(wod_);
			
			_wallObjects.push(newWallObj);
			
			if (!initial_)
			{
				newWallObj.wall = wall_;
				newWallObj.x = x_;
				
				var mcEvent : MapControllerEvent = new MapControllerEvent(MapControllerEvent.WallObjectAdded);
				mcEvent.wallObject = newWallObj;
				dispatchEvent(mcEvent);
			}
			
			applyWallObject(newWallObj);
			
			return newWallObj;
		}
		
		public function moveCellObject(cellObj_ : CellObject, send : Boolean) : void
		{
			clearCellObject(cellObj_);
			applyCellObject(cellObj_);
			
			if (send)
				ResourceManager.instance.moveCell(cellObj_.mapObject.storeObject.storeId, cellObj_.x, cellObj_.y);
		}
		
		public function rotateCellObject(cellObj_ : CellObject) : void
		{
			clearCellObject(cellObj_);
			applyCellObject(cellObj_);
			
			ResourceManager.instance.rotate(cellObj_.mapObject.storeObject.storeId, cellObj_.rotation);
		}
		
		public function removeCellObjectBySOD(storeObject_ : StoreObjectData) : void
		{
			var co : CellObject = findCellObjectBySOD(storeObject_);
			
			removeCellObject(co);
		}
		
		public function removeWallObjectBySOD(storeObject_ : StoreObjectData) : void
		{
			var wo : WallObject = findWallObjectBySOD(storeObject_);
			
			removeWallObject(wo);
		}
		
		public function removeCellObject(cellObj_ : CellObject) : void
		{
			var cc : Object = _cellClients[cellObj_];
			
			if (cc != null)
				(cc as CellClient).removed();
				
			clearCellObject(cellObj_);

			removeCellClientByObj(cellObj_);
			
			_cellObjects.splice(_cellObjects.indexOf(cellObj_), 1);
			
			dispatchEvent(new MapControllerEvent(MapControllerEvent.CellObjectRemoved));
		}
		
		public function moveWallObject(wallObj_ : WallObject, send : Boolean) : void
		{
			clearWallObject(wallObj_);
			applyWallObject(wallObj_);
			
			if (send)
				ResourceManager.instance.moveWall(wallObj_.mapObject.storeObject.storeId, wallObj_.x, wallObj_.wall);
		}
		
		public function removeWallObject(wallObj_ : WallObject) : void
		{
			var wc : Object = _wallClients[wallObj_];
			
			if (wc != null)
				(wc as WallClient).removed();
			
			clearWallObject(wallObj_);

			removeWallClientByObj(wallObj_);
			
			_wallObjects.splice(_wallObjects.indexOf(wallObj_), 1);
				
			dispatchEvent(new MapControllerEvent(MapControllerEvent.WallObjectRemoved));
		}
		
		protected function clearCellObject(cellObj_ : CellObject) : void
		{
			var i : int;
			var j : int;
			
			for (i = 0; i < _mapWidth; i++)
			{
				for (j = 0; j < _mapHeight; j++)
				{
					if (_cells[i][j].contains(cellObj_))
						_cells[i][j].removeObject(cellObj_);
				}
			}
		}
		
		protected function applyCellObject(cellObj_ : CellObject) : void
		{
			var i : int;
			var j : int;
			
			for (i = cellObj_.x; i < cellObj_.x + cellObj_.xLength; i++)
			{
				for (j = cellObj_.y; j < cellObj_.y + cellObj_.yLength; j++)
				{
					trace(i,j,cellObj_)
					if (i>=_cells.length || j>=_cells[i].length) trace(111);
					_cells[i][j].addObject(cellObj_);
				}
			}
		}
		
		protected function applyWallObject(wallObj_ : WallObject) : void
		{
			var i : int;
			
			for (i = wallObj_.x; i < wallObj_.x + (wallObj_.mapObject.storeObject.object as WallObjectData).width; i++)
			{
				_walls[wallObj_.wall][i].addObject(wallObj_);
			}
		}
		
		protected function clearWallObject(wallObj_ : WallObject) : void
		{
			var i : int;
			var j : int;
			
			var dim : Vector.<int> = new Vector.<int>();
			
			dim[0] = _mapWidth;
			dim[1] = _mapHeight;
			
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < dim[i]; j++)
				{
					if (_walls[i][j].contains(wallObj_))
						_walls[i][j].removeObject(wallObj_);
				}
			}
		}

		public function buildWay(start_ : Point, end_ : Point) : Way
		{
			return WayFactory.createWay(start_, end_);
		}
		
		public override function toString() : String
		{
			var i : int;
			var j : int;

			var str : String = "";
			
			str += "Cells: \n";
			
			for (i = 0; i < _mapWidth; i++)
			{
				for (j = 0; j < _mapHeight; j++)
				{
					str += (cells[i][j].empty == true ? 0 : 1) + " "; 
				}
				
				str += "\n";
			}
			
			str += "Walls: \n\\ ";
			
			for (i = 0; i < _mapHeight; i++)
			{
				str += (walls[1][i].empty == true ? 0 : 1) + " ";
			}
			
			str += "\n";
			
			for (i = 0; i < _mapWidth; i++)
			{
				str += (walls[0][i].empty == true ? 0 : 1) + "\n";
			}
			
			return str;
		}
	}
}