package com.sigma.socialgame.view.game.map
{
	import as3isolib.data.INode;
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;
	
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.common.math.IsometricMath;
	import com.sigma.socialgame.controller.ControllerManager;
	import com.sigma.socialgame.controller.ControllerNames;
	import com.sigma.socialgame.controller.facade.MapEntityFacade;
	import com.sigma.socialgame.controller.map.clients.MapClient;
	import com.sigma.socialgame.controller.map.clients.CellClient;
	import com.sigma.socialgame.controller.map.clients.WorkerClient;
	import com.sigma.socialgame.controller.map.MapController;
	import com.sigma.socialgame.controller.map.objects.CellObject;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.controller.map.objects.WallObject;
	import com.sigma.socialgame.controller.sell.SellController;
	import com.sigma.socialgame.controller.shop.clients.ShopClient;
	import com.sigma.socialgame.controller.store.StoreController;
	import com.sigma.socialgame.controller.store.objects.StoreObject;
	import com.sigma.socialgame.events.controller.MapControllerEvent;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.events.view.MapEvent;
	import com.sigma.socialgame.model.common.id.objectid.ObjectPlaces;
	import com.sigma.socialgame.model.common.id.objectid.ObjectTypes;
	import com.sigma.socialgame.model.common.id.storeid.StoreIdentifier;
	import com.sigma.socialgame.sound.SoundEvents;
	import com.sigma.socialgame.sound.SoundManager;
	import com.sigma.socialgame.view.game.Field;
	import com.sigma.socialgame.view.game.map.objects.CellEntity;
	import com.sigma.socialgame.view.game.map.objects.GameEntity;
	import com.sigma.socialgame.view.game.map.objects.WallEntity;
	import com.sigma.socialgame.view.game.map.objects.WorkerEntity;
	import com.sigma.socialgame.view.game.map.objects.WorkspaceEntity;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatar;
	import com.sigma.socialgame.view.game.map.objects.avatar.PlayerAvatarState;
	import com.sigma.socialgame.view.game.map.objects.avatar.tasks.PlayerAvatarTaskManager;
	import com.sigma.socialgame.view.game.map.objects.build.Cell;
	import com.sigma.socialgame.view.game.map.objects.build.Wall;
	import com.sigma.socialgame.view.game.map.MapRenderer;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.GuiManager;
	import com.sigma.socialgame.view.gui.SkinManager;
	import com.sigma.socialgame.view.game.MyOfficeGame;
	
	import starling.core.*;
	import starling.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Image;
	import flash.display.StageDisplayState;
	import starling.events.Event;
	import flash.events.EventPhase;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.IsoView;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	
	public class Map extends Sprite
	{
		public static const TAG : String = "Map";
		
		public static const CellWidth : Number = 64.0;
		public static const CellHeight : Number = 64.0;
		public static const CellLength : Number = 76.2941;
		
		private var _width : int;
		private var _height : int;
		
		private var _cells : Vector.<Vector.<Cell>>;
		private var _walls : Vector.<Vector.<Wall>>;
		
		private var _mapCont : Sprite;
		private var _scene : IsoScene;
		private var _view : IsoView;
		
		private var _workspaces : Vector.<WorkspaceEntity>;
		
		private static var _instance : Map;
		
		private var _moving : GameEntity;
		private var _playerAvatar : PlayerAvatar;
		//		[Embed(source="../data/image/Background.png")]
		private var _backClass : Class;
		
		//		[Embed(source="../data/image/building.swf")]
		private var _buildingClass : Class;
		
		private var _backImage : Image;
		private var _back : Sprite;		
		private var _building : Image;
		
		private var _left : Number;
		private var _right : Number;
		private var _top : Number;
		private var _bottom : Number;
		
		private var _currLeft : Number;
		private var _currRight : Number;
		private var _currTop : Number;
		private var _currBottom : Number;
		
		private var _mouseWorkspace : WorkspaceEntity;
		private var _mouseWorker : WorkerEntity;
		private var _mouseCell : CellEntity;
		private var _mouseWall : WallEntity;
		
		private var nativeStage:flash.display.Stage;
		
		public function Map()
		{
			_instance = this;
		}
		
		public function init() : void
		{
			nativeStage = Starling.current.nativeStage;
			Logger.message("Initing Map.", TAG, LogLevel.Info, LogModule.View);
			
			_width = mapController.width;
			_height = mapController.height;
			
			_top = getCellCoords(-1, -1).y;
			_left = getCellCoords(0, _height).x;
			_right = getCellCoords(_width, 0).x;
			_bottom = getCellCoords(_width, _height).y;
			
			_minScale = MyOfficeGame.instance.dim.x / (getCellCoords(_width + 5, 0).x - getCellCoords(0, _height + 5).x);
			_maxScale = MyOfficeGame.instance.dim.x / (getCellCoords(6, 0).x - getCellCoords(0, 6).x);
			
			scaleX = (_maxScale + _minScale) / 2;
			scaleY = scaleX;
			
			x = MyOfficeGame.instance.dim.x / 2;
			y = MyOfficeGame.instance.dim.y / 4;
			
			correctZoom();
			
			initBack();
			correctBack();
			createBuilding();
			initBuilding();
			
			_walls = new Vector.<Vector.<Wall>>();
			
			_mapCont = new Sprite();
			
			_scene = new IsoScene();
			_scene.hostContainer = _mapCont;
			_scene.layoutRenderer = new MapRenderer();			
			
			_workspaces = new Vector.<WorkspaceEntity>();
			
			var dim : Array = [_width, _height];
			var isoSprite : IsoSprite;
			var coords : Point;
			
			for (i = 0; i < 2; i++)
			{
				_walls[i] = new Vector.<Wall>();
				
				for (j = 0; j < dim[i]; j++)
				{
					isoSprite = new IsoSprite();
					
					_walls[i][j] = new Wall(i);
					
					_walls[i][j].wall = 1 - i;
					_walls[i][j].mapX = j;
					
					_walls[i][j].alpha = 1.0;
					
					coords = getWallSpaceCoords(1 - i, j);
					
					if (i == 1)
						vec3 = getWallCoords(MapRotation.NorthEast, 1);
					else
						vec3 = getWallCoords(MapRotation.NorthWest, 1);
					
					isoSprite.sprites = [_walls[i][j]];
					isoSprite.moveTo(coords.x, coords.y, -1);
					isoSprite.setSize(0, 0, 1);
					
					_walls[i][j].x = vec3.x;
					_walls[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			_cells = new Vector.<Vector.<Cell>>();
			
			var i : int;
			var j : int;
			
			for (i = 0; i < _width; i++)
			{
				_cells[i] = new Vector.<Cell>();
				
				for (j = 0; j < _height; j++)
				{
					isoSprite = new IsoSprite();
					
					_cells[i][j] = new Cell();
					
					_cells[i][j].mapX = i;
					_cells[i][j].mapY = j;
					
					_cells[i][j].alpha = 1.0;
					
					coords = getCellSpaceCoords(i, j);
					
					isoSprite.sprites = [_cells[i][j]];
					isoSprite.moveTo(coords.x, coords.y, -1);
					isoSprite.setSize(0, 0, 1);
					
					vec3 = getCellCoords(1, 1);
					
					_cells[i][j].x = vec3.x;
					_cells[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			var newCellEntity : CellEntity;
			var newWallEntity : WallEntity;
			
			for each (var wallObj : WallObject in mapController.wallObjects)
			{
				newWallEntity = MapFactory.createWallEntity(wallObj);
				
				if (newWallEntity == null)
					continue;
				
				newWallEntity.apply(true);
			}
			
			var laterInit : Vector.<CellObject> = new Vector.<CellObject>();
			var cellObj : CellObject;
			
			for each (cellObj in mapController.cellObjects)
			{
				if (cellObj.storeObject.storeObject.object.type == ObjectTypes.Worker)
				{
					laterInit.push(cellObj);
					
					continue;
				}
				
				newCellEntity = MapFactory.createCellEntity(cellObj);
				
				if (newCellEntity == null)
					continue;
				
				if (cellObj.storeObject.storeObject.object.type == ObjectTypes.Workspace)
					_workspaces.push(newCellEntity);
				
				newCellEntity.apply(true);
			}
			
			for each (cellObj in laterInit)
			{
				newCellEntity = MapFactory.createCellEntity(cellObj);
				
				if (newCellEntity == null)
					continue;
				
				newCellEntity.apply(true);
			}
			
			nativeStage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			nativeStage.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			nativeStage.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
			
			mapController.addEventListener(MapControllerEvent.DimenstionChanged, onDimChanged);
			mapController.addEventListener(MapControllerEvent.NewCellObject, onObjectAdded);
			mapController.addEventListener(MapControllerEvent.NewWallObject, onObjectAdded);
			
			//_currCell = mouseCell;
			//_currWall = mouseWall;
			
			addChild(_mapCont);
			
			vec3 = getCellCoords(-1, -1);
			
			_mapCont.x = vec3.x;
			_mapCont.y = vec3.y;
			
			loadAvatar();
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			nativeStage.addEventListener("resize", onResize);
			nativeStage.addEventListener(flash.events.MouseEvent.RIGHT_CLICK, onRightClick);
			
			onResize();
			
			Logger.message("Map inited.", TAG, LogLevel.Info, LogModule.View);
		}
		
		protected function onRightClick(e:Object=null) : void
		{
			if (_mouseWorkspace) {
				if (_mouseWorkspace.worker) {
					GuiManager.instance.showEntityMenuNoSell(_mouseWorkspace);
				} else {
					GuiManager.instance.showEntityMenuRotate(_mouseWorkspace);
				}
			}
		}
		protected function onResize(e:Object=null) : void
		{
			Starling.current.viewPort = new Rectangle(0, 0, nativeStage.stageWidth, nativeStage.stageHeight);
			stage.stageWidth = nativeStage.stageWidth;
			stage.stageHeight = nativeStage.stageHeight;
			
			_building.x = _mapCont.x = (stage.stageWidth-807)/2;
			
			correctPos();
			correctBack();
			
			Starling.current.showStatsAt("right","bottom");
			GuiManager.instance.onResize();
			if (MyOfficeGame.instance.loaded) {
				var scale:Number = stage.stageHeight / 730;
				MyOfficeGame.instance.scaleX = MyOfficeGame.instance.scaleY = scale;
				MyOfficeGame.instance.x = Starling.current.stage.stageWidth/2 - 807*scale/2;
				MyOfficeGame.instance.y = Starling.current.stage.stageHeight/2 - 730*scale/2;
			}
		}
		
		protected function loadAvatar() : void
		{
			_playerAvatar = new PlayerAvatar();
			_playerAvatar.graphicLoader.addEventListener(GraphicLoaderEvent.Loaded, onAvatarLoaded);
			_playerAvatar.graphicLoader.load();
			PlayerAvatarTaskManager.Initialize(_playerAvatar);
		}
		
		protected function onAvatarLoaded(e : GraphicLoaderEvent) : void
		{
			var empty : Point = findEmptyCell();
			
			_playerAvatar.mapX = empty.x;
			_playerAvatar.mapY = empty.y;
			
			_playerAvatar.apply();			
			_playerAvatar.dir = MapRotation.SouthWest;
			_playerAvatar.state = PlayerAvatarState.Standing;
			
			_scene.render();
		}		
		
		public function reload() : void
		{
			_width = mapController.width;
			_height = mapController.height;
			
			_top = getCellCoords(-1, -1).y;
			_left = getCellCoords(0, _height).x;
			_right = getCellCoords(_width, 0).x;
			_bottom = getCellCoords(_width, _height).y;
			
			_minScale = MyOfficeGame.instance.dimNormal.x / (getCellCoords(_width + 5, 0).x - getCellCoords(0, _height + 5).x);
			_maxScale = MyOfficeGame.instance.dimNormal.x / (getCellCoords(6, 0).x - getCellCoords(0, 6).x);
			
			scaleX = (_maxScale + _minScale) / 2;
			scaleY = scaleX;
			
			x = MyOfficeGame.instance.dim.x / 2;
			y = MyOfficeGame.instance.dim.y / 4;
			
			correctZoom();
			
			correctBack();
			initBuilding();
			
			_walls = new Vector.<Vector.<Wall>>();
			
			removeChild(_mapCont);
			_mapCont = new Sprite();
			
			_scene.removeAllChildren();
			_scene.hostContainer = null;
			
			_scene = new IsoScene();
			_scene.hostContainer = _mapCont;
			
			_workspaces = new Vector.<WorkspaceEntity>();
			
			var dim : Array = [_width, _height];
			var isoSprite : IsoSprite;
			var coords : Point;
			
			for (i = 0; i < 2; i++)
			{
				_walls[i] = new Vector.<Wall>();
				
				for (j = 0; j < dim[i]; j++)
				{
					isoSprite = new IsoSprite();
					
					_walls[i][j] = new Wall(i);
					
					_walls[i][j].wall = 1 - i;
					_walls[i][j].mapX = j;
					
					_walls[i][j].alpha = 1.0;
					
					coords = getWallSpaceCoords(1 - i, j);
					
					if (i == 1)
						vec3 = getWallCoords(MapRotation.NorthEast, 1);
					else
						vec3 = getWallCoords(MapRotation.NorthWest, 1);
					
					isoSprite.sprites = [_walls[i][j]];
					isoSprite.moveTo(coords.x, coords.y, 0);
					
					_walls[i][j].x = vec3.x;
					_walls[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			_cells = new Vector.<Vector.<Cell>>();
			
			var i : int;
			var j : int;
			
			for (i = 0; i < _width; i++)
			{
				_cells[i] = new Vector.<Cell>();
				
				for (j = 0; j < _height; j++)
				{
					isoSprite = new IsoSprite();
					
					_cells[i][j] = new Cell();
					
					_cells[i][j].mapX = i;
					_cells[i][j].mapY = j;
					
					_cells[i][j].alpha = 1.0;
					
					coords = getCellSpaceCoords(i, j);
					
					isoSprite.sprites = [_cells[i][j]];
					isoSprite.moveTo(coords.x, coords.y, 0);
					
					vec3 = getCellCoords(1, 1);
					
					_cells[i][j].x = vec3.x;
					_cells[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			var newCellEntity : CellEntity;
			var newWallEntity : WallEntity;
			
			for each (var wallObj : WallObject in mapController.wallObjects)
			{
				newWallEntity = MapFactory.createWallEntity(wallObj);
				
				if (newWallEntity == null)
					continue;
				
				newWallEntity.apply(true);
			}
			
			var laterInit : Vector.<CellObject> = new Vector.<CellObject>();
			var cellObj : CellObject;
			
			for each (cellObj in mapController.cellObjects)
			{
				if (cellObj.storeObject.storeObject.object.type == ObjectTypes.Worker)
				{
					laterInit.push(cellObj);
					
					continue;
				}
				
				newCellEntity = MapFactory.createCellEntity(cellObj);
				
				if (newCellEntity == null)
					continue;
				
				if (cellObj.storeObject.storeObject.object.type == ObjectTypes.Workspace)
					_workspaces.push(newCellEntity);
				
				newCellEntity.apply(true);
			}
			
			for each (cellObj in laterInit)
			{
				newCellEntity = MapFactory.createCellEntity(cellObj);
				
				if (newCellEntity == null)
					continue;
				
				newCellEntity.apply(true);
			}
			
			//_currCell = mouseCell;
			//_currWall = mouseWall;
			
			addChild(_mapCont);
			
			vec3 = getCellCoords(-1, -1);
			
			_mapCont.x = vec3.x;
			_mapCont.y = vec3.y;
			
			_playerAvatar.remove();
			
			var empty : Point = findEmptyCell();
			
			_playerAvatar.mapX = empty.x;
			_playerAvatar.mapY = empty.y;
			
			_playerAvatar.apply();
			
			_scene.render();
		}
		
		protected function findEmptyCell() : Point
		{
			var i : int;
			var j : int;
			
			for (i = mapController.width - 1; i >= 0; i--)
			{
				for (j = mapController.height - 1; j >= 0; j--)
				{
					if (mapController.cells[i][j].onlyTrim)
					{
						return new Point(i, j);
					}
				}
			}
			
			return new Point(2, 2);
		}
		
		private var _wasMapContX : int;
		private var _wasMapContY : int;
		
		private var _wasBackX : int;
		private var _wasBackY : int;
		
		public function iWantScreenShot() : void
		{
			_wasBackX = _back.x;
			_wasBackY = _back.y;
			
			_back.x = 0;
			_back.y = 0;
			
			_wasMapContX = x;
			_wasMapContY = y;
			
			x = 0;
			y = 0;
		}
		
		/*public function get screenShot() : IBitmapDrawable
		{
			return this;
		}*/
		
		public function iDontWantScreenShot() : void
		{
			_back.x = _wasBackX;
			_back.y = _wasBackY;
			
			x = _wasMapContX;
			y = _wasMapContY;
		}
		
		public function get screenShotBias() : Point
		{
			return new Point(_mapCont.width / 2 + 50, 265 + 100);
		}
		
		public function get screenShotDim() : Point
		{
			return new Point(_mapCont.width + 100, _mapCont.height + 200);
		}
		
		protected function onObjectAdded(e : MapControllerEvent) : void
		{
			switch (e.type)
			{
				case MapControllerEvent.NewCellObject:
					
					var newCellEntity : CellEntity = MapFactory.createCellEntity(e.cellObject);
					
					if (newCellEntity == null)
						return;
					
					if (e.cellObject.storeObject.storeObject.object.type == ObjectTypes.Workspace)
						_workspaces.push(newCellEntity);
					
					newCellEntity.apply(true);
					
					break;
				
				case MapControllerEvent.NewWallObject:
					
					var newWallEntity : WallEntity = MapFactory.createWallEntity(e.wallObject);
					
					if (newWallEntity == null)
						return;
					
					newWallEntity.apply(true);
					
					break;
			}
		}
		
		protected function onDimChanged(e : MapControllerEvent) : void
		{
			var i : int;
			var j : int;
			
			var isoSprite : IsoSprite;
			var coords : Point;
			var vec3 : Vector3D;
			
			for (i = 0; i < _width; i++)
			{
				for (j = _height; j < e.height; j++)
				{
					isoSprite = new IsoSprite();
					
					_cells[i][j] = new Cell();
					
					_cells[i][j].mapX = i;
					_cells[i][j].mapY = j;
					
					_cells[i][j].alpha = 1.0;
					
					coords = getCellSpaceCoords(i, j);
					
					isoSprite.sprites = [_cells[i][j]];
					isoSprite.moveTo(coords.x, coords.y, 0);
					
					vec3 = getCellCoords(1, 1);
					
					_cells[i][j].x = vec3.x;
					_cells[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			for (i = _width; i < e.width; i++)
			{
				_cells[i] = new Vector.<Cell>;
				
				for (j = 0; j < e.height; j++)
				{
					isoSprite = new IsoSprite();
					
					_cells[i][j] = new Cell();
					
					_cells[i][j].mapX = i;
					_cells[i][j].mapY = j;
					
					_cells[i][j].alpha = 1.0;
					
					coords = getCellSpaceCoords(i, j);
					
					isoSprite.sprites = [_cells[i][j]];
					isoSprite.moveTo(coords.x, coords.y, 0);
					
					vec3 = getCellCoords(1, 1);
					
					_cells[i][j].x = vec3.x;
					_cells[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			var dimWas : Array = [_width, _height];
			var dimNew : Array = [e.width, e.height];
			
			for (i = 0; i < 2; i++)
			{
				for (j = dimWas[i]; j < dimNew[i]; j++)
				{
					isoSprite = new IsoSprite();
					
					_walls[i][j] = new Wall(i);
					
					_walls[i][j].wall = 1 - i;
					_walls[i][j].mapX = j;
					
					_walls[i][j].alpha = 1.0;
					
					coords = getWallSpaceCoords(1 - i, j);
					
					if (i == 1)
						vec3 = getWallCoords(MapRotation.NorthEast, 1);
					else
						vec3 = getWallCoords(MapRotation.NorthWest, 1);
					
					isoSprite.sprites = [_walls[i][j]];
					isoSprite.moveTo(coords.x, coords.y, 0);
					
					_walls[i][j].x = vec3.x;
					_walls[i][j].y = vec3.y;
					
					//_scene.addChild(isoSprite);
				}
			}
			
			/*			var defaultCell : String = "pol3";
			var defaultWall : String = "wall1";
			
			var defaultCellObj : ObjectData;
			var defaultWallObj : ObjectData;
			
			for each (var obj : ObjectData in ResourceManager.instance.objects)
			{
			if (obj.objectId.id == defaultCell)
			defaultCellObj = obj;
			
			if (obj.objectId.id == defaultWall)
			defaultWallObj = obj;
			
			if (defaultCellObj != null && defaultWallObj != null)
			break;
			}
			
			var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
			
			var newMO : MapObject;
			var newGe : GameEntity;
			
			var storeObject : StoreObject;
			
			for (i = 0; i < _width; i++)
			{
			for (j = _height; j < e.height; j++)
			{
			storeObject = sCon.addStoreObject(defaultCellObj);
			
			newMO = MapEntityFacade.addCellObjectFromStore(storeObject.storeObject, i, j);
			
			trace("add object: " + newMO.mapObject.storeObject.storeId.storeId);
			
			newGe = MapFactory.createCellEntity(newMO as CellObject);
			
			newGe.apply();
			}
			}
			
			for (i = _width; i < e.width; i++)
			{
			for (j = 0; j < e.height; j++)
			{
			storeObject = sCon.addStoreObject(defaultCellObj);
			
			newMO = MapEntityFacade.addCellObjectFromStore(storeObject.storeObject, i, j);
			
			trace("add object: " + newMO.mapObject.storeObject.storeId.storeId);
			
			newGe = MapFactory.createCellEntity(newMO as CellObject);
			
			newGe.apply();
			}
			}
			
			for (i = 0; i < 2; i++)
			{
			for (j = dimWas[i]; j < dimNew[i]; j++)
			{
			storeObject = sCon.addStoreObject(defaultWallObj);
			
			newMO = MapEntityFacade.addWallObjectFromStore(storeObject.storeObject, i, j);
			
			newGe = MapFactory.createWallEntity(newMO as WallObject);
			
			newGe.apply();
			}
			}
			*/			
			_width = e.width;
			_height = e.height;
			
			_top = getCellCoords(-1, -1).y;
			_left = getCellCoords(0, _height).x;
			_right = getCellCoords(_width, 0).x;
			_bottom = getCellCoords(_width, _height).y;
			
			_minScale = MyOfficeGame.instance.dim.x / (getCellCoords(_width + 5, 0).x - getCellCoords(0, _height + 5).x);
			_maxScale = MyOfficeGame.instance.dim.x / (getCellCoords(6, 0).x - getCellCoords(0, 6).x);
			
			correctZoom();
			
			initBuilding();
		}
		
		protected function initBack() : void
		{
			_backImage = new Image(SkinManager.instance.getSkinTexture(GuiIds.Background));
			_back = new Sprite();
			
			_back.addChild(_backImage);
			
			_backImage.x -= _backImage.width / 2;
			_backImage.y -= _backImage.height / 2;
			
			addChild(_back);
			
			_backWidth = _backImage.width;
			_backHeight = _backImage.height;
			
			_backMinScale = ((_right - _left) * _minScale * _backSpeedFactor + _backWidth) / _backWidth;
			_backMaxScale = ((_right - _left) * _maxScale * _backSpeedFactor + _backWidth) / _backWidth * _backZoomFactor;
		}
		
		private var _backSpeedFactor : Number = 0.3;
		private var _backZoomFactor : Number = 1.0;
		
		private var _backWidth : Number;
		private var _backHeight : Number;
		
		private var _backMaxScale : Number;
		private var _backMinScale : Number;
		
		protected function correctBack() : void
		{
			if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL)
			{
			}
			else
			{
			}
			
			_back.scaleX = _backMinScale + ((scaleX - _minScale) / (_minScale - _maxScale)) * (_backMinScale - _backMaxScale);
			_back.scaleY = _backMinScale + ((scaleY - _minScale) / (_minScale - _maxScale)) * (_backMinScale - _backMaxScale);
			
			_back.scaleX /= scaleX;
			_back.scaleY /= scaleY;
			
			var local : Point = globalToLocal(new Point(MyOfficeGame.instance.dim.x / 2, MyOfficeGame.instance.dim.y / 2));
			var delta : Point = new Point((_right + _left) / 2 - local.x, (_top + _bottom) / 2 - local.y);
			
			_back.x = local.x + delta.x * _backSpeedFactor;
			_back.y = local.y + delta.y * _backSpeedFactor;
		}
		
		protected function createBuilding() : void
		{
			_building = new Image(SkinManager.instance.getSkinTexture(GuiIds.Building));
			
			addChild(_building);
		}
		
		protected function initBuilding() : void
		{
			_building.pivotX = _building.width/2;

			//_building.scaleX = 0.9;
			//_building.scaleY = 0.9;
			
			var vec3 : Vector3D = getCellCoords(-1, -1);
			
			_building.x = vec3.x;
			_building.y = vec3.y;
			
			vec3 = getCellCoords(_width, 0);
			
			var scale : Number = vec3.x * 2 / (_building.width - 30);
			
			_building.scaleX = scale;
			_building.scaleY = scale;
		}
		
		public function findWS(storeId : StoreIdentifier) : WorkspaceEntity
		{
			for each (var ws : WorkspaceEntity in _workspaces)
			{
				if (ws.mapClient.mapObject.storeObject.storeObject.storeId.equals(storeId))
				{
					return ws;
				}
			}
			
			return null;
		}
		
		public function renderScene() : void
		{
			_scene.render();
		}
		
		public function swap(node : INode) : void
		{
			/*for (var i:int=0;i<_scene.numChildren;i++) {
				var o:Object = _scene.getChildAt(i);
			}*/
			_scene.render(false);
			//trace(_scene.getChildIndex(node));
		}
		
		protected function onEnterFrame(e : starling.events.Event) : void
		{
			//_scene.render();
		}
		
		public function addNode(node : IsoSprite) : void
		{
			var children:Array = _scene.children;
			var l:int = children.length;
			var i:int=0;
			if (node.name=="wall") {
				while (i<l && children[i].name=="wall" && node.d > (children[i] as IsoSprite).d) i++;
				_scene.addChildAt(node, i);
			} else if (node.name=="cell") {
				while (i<l && children[i].name=="wall") i++;
				while (i<l && children[i].name=="cell" && node.d >= (children[i] as IsoSprite).d) i++;
				_scene.addChildAt(node, i);
				trace("--", i, node.d, children[i-1].d, children[i-1].name);
			} else {
				while (i<l && children[i].name=="wall") i++;
				while (i<l && children[i].name=="cell") i++;
				while (i<l && node.d > children[i].d) i++;
				_scene.addChildAt(node, i);
				trace("--", i, node.d, children[i-1].d, children[i-1].name);
			}
			trace(i, _scene.children.length, node.name, node.screenX, node.screenY)
		}
		
		public function removeNode(node : INode) : void
		{
			_scene.removeChild(node);
		}
		
		private var _mDown : Boolean;
		private var _mMoved : Boolean;
		
		private var _wasMX : int;
		private var _wasMY : int;
		
		private var _wasX : int;
		private var _wasY : int;
		
		private var _minScale : Number;
		private var _maxScale : Number;
		
		private var _currCell : Point;
		private var _currWall : Point;
		
		public function zoomIn() : void
		{
			zoom(3);
		}
		
		public function zoomOut() : void
		{
			zoom(-3);
		}
		
		protected function zoom(delta : int) : void
		{
			scaleX += delta * 0.05;
			scaleY += delta * 0.05;
			
			if (scaleX > _maxScale)
				scaleX = _maxScale = 1.0;
			
			if (scaleY > _maxScale)
				scaleY = _maxScale = 1.0;
			
			if (scaleX < _minScale)
				scaleX = _minScale;
			
			if (scaleY < _minScale)
				scaleY = _minScale;
			
			correctZoom();
			correctPos();
			correctBack();
			
			dispatchEvent(new MapEvent(MapEvent.MapZoomed));
		}
		
		public var skipOne : Boolean = false;
		
		protected function onMouseEvent(e : MouseEvent) : void
		{
			if (!root.touchable) return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_WHEEL:
					
					zoom(e.delta);
					
					break;
				
				case MouseEvent.MOUSE_DOWN:
					
					_mDown = true;
					
					_wasMX = e.stageX;
					_wasMY = e.stageY;
					
					_wasX = x;
					_wasY = y;
					
					break;
				
				case MouseEvent.MOUSE_UP:
				case MouseEvent.RELEASE_OUTSIDE:
					
					_mDown = false;
					
					if (_mMoved)
						e.stopPropagation();
					else
						if (e.eventPhase != EventPhase.BUBBLING_PHASE)
						{
							dispatchEvent(new MapEvent(MapEvent.MapClicked));
						}
					
					if (skipOne)
					{
						e.stopPropagation();
						
						skipOne = false;
					}
					
					_mMoved = false;
					
					break;
				
				case MouseEvent.MOUSE_MOVE:
					
					if (_mDown)
					{
						if (!_mMoved && (Math.abs(e.stageX - _wasMX) > 5 || Math.abs(e.stageY - _wasMY) > 5)) {
							_mMoved = true;
							if (_mouseWorkspace) _mouseWorkspace.mapMoved = true;
							if (_mouseWorker) _mouseWorker.mapMoved = true;
							if (_mouseCell) _mouseCell.mapMoved = true;
							if (_mouseWall) _mouseWall.mapMoved = true;
							dispatchEvent(new MapEvent(MapEvent.MapMoved));
						}
							
						x = _wasX + (e.stageX - _wasMX);
						y = _wasY + (e.stageY - _wasMY);
						
						correctPos();
						correctBack();
						//_scene.render();
						//e.updateAfterEvent();
					}
					
					
					var mEvent : MapEvent;
					
					if (_currCell == null)
					{
						if (_mouseCell) _currCell = new Point(mouseCell.cellX, mouseCell.cellY);
						
						if (_currCell != null)
						{
							mEvent = new MapEvent(MapEvent.CellMouse);
							mEvent.coords = _currCell;
							dispatchEvent(mEvent);
						}
					}
					else
					{
						if (_mouseCell) var newCell : Point = new Point(mouseCell.cellX, mouseCell.cellY);
						
						if (newCell != null)
							if (!newCell.equals(_currCell))
							{
								_currCell = newCell;
								
								mEvent = new MapEvent(MapEvent.CellMouse);
								mEvent.coords = _currCell;
								dispatchEvent(mEvent);
							}
					}
					
					if (_currWall == null)
					{
						if (_mouseWall) _currWall = new Point(_mouseWall.wallX, 0);
						
						if (_currWall != null)
						{
							mEvent = new MapEvent(MapEvent.WallMouse);
							mEvent.coords = _currWall;
							dispatchEvent(mEvent);
						}
					}
					else
					{
						if (_mouseWall) var newWall : Point = new Point(_mouseWall.wallX, 0);
						
						if (newWall != null)
							if (!newWall.equals(_currWall))
							{
								_currWall = newWall;
								
								mEvent = new MapEvent(MapEvent.WallMouse);
								mEvent.coords = _currWall;
								dispatchEvent(mEvent);
							}
					}
					break;
			}
		}
		
		protected function correctZoom() : void
		{
			_currLeft = _left * scaleX;
			_currRight = _right * scaleX;
			
			_currTop = _top * scaleY;
			_currBottom = _bottom * scaleY;
			
		}
		
		protected function correctPos() : void
		{
			var width_ : int = MyOfficeGame.instance.dim.x; 
			var height_ : int = MyOfficeGame.instance.dim.y; 
			
			if (x + _currLeft > width_ / 2)
				x = width_ / 2 - _currLeft;
			
			if (x + _currRight < width_ / 2)
				x = width_ / 2 - _currRight;
			
			if (y + _currTop > height_ / 2)
				y = height_ / 2 - _currTop;
			
			if (y + _currBottom < height_ / 2)
				y = height_ / 2 - _currBottom;
		}
		
		private var _boughtMove : Boolean = false;
		private var _boughtCorrect : Boolean = false;
		public var _boughtClient : ShopClient;
		private var _boughtEntity : GameEntity;
		
		public var _wasBought : Boolean;
		
		public var _movingX : int;
		public var _movingY : int;
		
		public function startMove(ge_ : GameEntity) : void
		{
			_moving = ge_;
			_moving.moving = true;
			renderScene();
			for each (var ws : WorkspaceEntity in _workspaces) {
				ws.touchable = false;
				if (ws.worker!=null) ws.worker.touchable = false;
				if (ws.avatar!=null) ws.avatar.touchable = false;
			}
		}
		
		public function endMove(x_:int=-1, y_:int=-1) : Boolean
		{
			trace("endmove", typeof _moving, _boughtMove, _wasBought, _boughtClient)
			if (!_boughtCorrect) return false;
			
			var moving:GameEntity = _moving;
			
			if (_moving) _moving.moving = false;
			_moving = null;
			_boughtCorrect = false;
			
			for each (var ws : WorkspaceEntity in _workspaces) {
				ws.touchable = true;
				if (ws.worker!=null) ws.worker.touchable = true;
				if (ws.avatar!=null) ws.avatar.touchable = true;
			}
			
			if (x_!=-1) {
				trace("::", x_, y_)
				_movingX = x_;
				_movingY = y_;
			}
			
			dispatchEvent(new MapEvent(MapEvent.EndMove));
			
			if (_boughtMove)
			{
				GuiManager.instance.hideCancelBuyButton();
				
				var ret : Boolean = false;
				
				if (_wasBought)
				{
					if (_boughtClient != null) 
						if (moving is WorkerEntity) (moving as WorkerEntity).shopClient = _boughtClient;
						else _boughtClient.applyBuyMove(_movingX, _movingY);
					
					SoundManager.instance.playEvent(SoundEvents.Buy);
					
					_wasBought = false;
					
					ret = true;
				}
				
				_boughtMove = false;
				
				return ret;
			} else if (moving is CellEntity) {
				_mapController.moveCellObject((moving as CellEntity).cellClient.cellObject, true);
			}
			
			return false;
		}
/*		<type>CMD</type>
  <commands>
    <command type="buymove" thing="workspace4" currency="coins" id="14166689" x="2" y="2"/>
  </commands>
		<commands>
    <command type="buymove" thing="wallGoldStar" currency="coins" id="14166690" x="4" y="NE"/>
  </commands>
	*/	
		public function buyAgain() : void
		{
			Map.instance.addMapEntity(_boughtClient.buyAgain(), _boughtClient);
		}
		
		public function cancelBuy() : void
		{
			if (_moving) _moving.moving = false;
			_boughtClient = null;
			_moving = null;
			_boughtCorrect = false;
			
			for each (var ws : WorkspaceEntity in _workspaces) {
				ws.touchable = true;
				if (ws.worker!=null) ws.worker.touchable = true;
				if (ws.avatar!=null) ws.avatar.touchable = true;
			}
			
			if (_boughtMove)
			{
				var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
				
				if (_boughtClient != null && _boughtClient.wasBought)
				{
					MapEntityFacade.removeToStore(_boughtEntity.mapClient.mapObject.mapObject.storeObject);
					sCon.removeStoreObjectByData(_boughtEntity.mapClient.mapObject.mapObject.storeObject);
				}
				else
				{
					MapEntityFacade.removeToStore(_boughtEntity.mapClient.mapObject.mapObject.storeObject);
				}
				
				if (_boughtEntity.mapClient.mapObject.mapObject.storeObject.object.type == ObjectTypes.Workspace)
				{
					_workspaces.splice(_workspaces.indexOf(_boughtEntity), 1);
				}
				
				_boughtEntity.remove();
				
				_boughtMove = false;
				_boughtEntity = null;
				moving = null;
				
				GuiManager.instance.hideCancelBuyButton();
				
				dispatchEvent(new MapEvent(MapEvent.EndMove));
			}
		}
		
		public function addMapEntity(storeObject_ : StoreObject, shopClient_ : ShopClient) : void
		{
			if (storeObject_ == null)
			{
				return;
			}
			
			GuiManager.instance.showCancelBuyButton();
			
			if (_boughtMove)
			{
				var sCon : StoreController = ControllerManager.instance.getController(ControllerNames.StoreController) as StoreController;
				
				MapEntityFacade.removeToStore(_boughtEntity.mapClient.mapObject.mapObject.storeObject);
				
				if (_boughtClient != null && _boughtClient.wasBought)
				{
					sCon.removeStoreObjectByData(_boughtEntity.mapClient.mapObject.mapObject.storeObject);
				}
				
				if (_boughtEntity.mapClient.mapObject.mapObject.storeObject.object.type == ObjectTypes.Workspace)
				{
					_workspaces.splice(_workspaces.indexOf(_boughtEntity), 1);
				}
				
				_boughtEntity.remove();
			}
			
			var newMO : MapObject;
			var newGe : GameEntity;
			
			switch (storeObject_.storeObject.object.place)
			{
				case ObjectPlaces.Cell:

					newMO = MapEntityFacade.addCellObjectFromStore(storeObject_.storeObject);
					
					//trace("add object: " + newMO.mapObject.storeObject.storeId.storeId, storeObject_.storeObject);
					
					newGe = MapFactory.createCellEntity(newMO as CellObject);
					
					break;
				
				case ObjectPlaces.Wall:

					newMO = MapEntityFacade.addWallObjectFromStore(storeObject_.storeObject);
					
					newGe = MapFactory.createWallEntity(newMO as WallObject);
					
					break;
			}
			
			_boughtEntity = newGe;
			
			if (_boughtEntity.mapClient.mapObject.mapObject.storeObject.object.type == ObjectTypes.Workspace)
			{
				_workspaces.push(_boughtEntity);
			}
			
			newGe.apply(false);

			newGe.touchable = false;
			
			//newGe.toggleMove(true);
			
			_boughtMove = true;
			_boughtClient = shopClient_;
			
			startMove(newGe);
			
			dispatchEvent(new MapEvent(MapEvent.StartMove));
		}
		
		private var _mapController : MapController;
		
		public function sellObject(gEntity_ : GameEntity) : void
		{
			SoundManager.instance.playEvent(SoundEvents.Buy);
			
			var sCon : SellController = ControllerManager.instance.getController(ControllerNames.SellController) as SellController;
			
			sCon.sell(gEntity_.mapClient.mapObject.mapObject.storeObject);
			
			if (gEntity_.mapClient.mapObject.mapObject.storeObject.object.type == ObjectTypes.Workspace)
			{
				_workspaces.splice(_workspaces.indexOf(gEntity_), 1);
			}
			
			gEntity_.remove();
		}
		
		public function get canBuy() : Boolean
		{
			if (_moving == null || _boughtMove)
				return true;
			
			return false;
		}
		
		public function get playerAvatar() : PlayerAvatar
		{
			return _playerAvatar;
		}
		
		public function get mapController() : MapController
		{
			if (_mapController == null)
				_mapController = ControllerManager.instance.getController(ControllerNames.MapController) as MapController;
			
			return _mapController;
		}
		
		public function getCellSpaceCoords(mapX_ : int, mapY_ : int) : Point
		{
			return new Point((mapX_) * CellWidth, (mapY_) * CellHeight);
		}
		
		public function getWallSpaceCoords(wall_ : int, wallX_ : int) : Point
		{
			var point : Point;
			
			if (wall_ == 1)
			{
				point = new Point((wallX_) * CellWidth, 0);
			}
			else
			{
				point = new Point(0, (wallX_) * CellHeight);
			}
			
			return point;
		}
		
		var vec3 : Vector3D = new Vector3D();
		public function getCellCoords(cellX_ : int, cellY_ : int) : Vector3D
		{
			vec3.x = (cellX_) * CellWidth;
			vec3.y = (cellY_) * CellHeight;
			vec3.z = 0.0;
			
			vec3 = IsometricMath.toIsometric(vec3);
			
			return vec3;
		}
		
		public function getWallCoords(wall_ : int, wallX_ : int) : Vector3D
		{
			if (wall_ == MapRotation.NorthWest)
			{
				vec3.x = wallX_ * CellWidth;
				vec3.y = 0.0;
				vec3.z = 0.0;
			}
			else
			{
				vec3.x = 0.0;
				vec3.y = wallX_ * CellHeight;
				vec3.z = 0.0;
			}
			
			vec3 = IsometricMath.toIsometric(vec3);
			
			return vec3;
		}
		
		public function getMapWallCoords(wall_ : int, wallX_ : int) : Vector3D
		{
			
			if (wall_ == MapRotation.NorthWest)
			{
				vec3.x = wallX_ * CellWidth;
				vec3.y = -CellHeight;
				vec3.z = 0.0;
			}
			else
			{
				vec3.x = -CellWidth;
				vec3.y = wallX_ * CellHeight;
				vec3.z = 0.0;
			}
			
			vec3 = IsometricMath.toIsometric(vec3);
			
			return vec3;
		}
		
		public function set mouseCell(cell : CellEntity) : void
		{
			_mouseCell = cell;
			if (cell && _moving && !(_moving is WallEntity) && (_movingX!=cell.cellX || _movingY!=cell.cellY)) {
				_movingX = cell.cellX;
				_movingY = cell.cellY;
				_boughtCorrect = _moving.move(_movingX, _movingY);
				_scene.render();
				//trace(_movingX, _movingY);
			}
		}
		
		public function get mouseCell() : CellEntity
		{
			/*var i : int;
			var j : int;
			
			vec3.x = (nativeStage.mouseX - x)/scaleX;
			vec3.y = (nativeStage.mouseY - y - 4.0)/scaleY;
			vec3.z = 0.0;
			
			vec3 = IsometricMath.fromIsometric(vec3);
			
			//trace((nativeStage.mouseX - x)/scaleX, (nativeStage.mouseY - y - 4.0)/scaleY, vec3.x/77+1, vec3.y/77+1);
			
			var vx:int = vec3.x/77+1;
			var vy:int = vec3.y/77+1;
			
			trace(vx, vy, vec3.x)
			if (vx > 0 && vx <= _width && vy > 0 && vy <= _height) return new Point(vx, vy);
			*/
			
			/*vec3.x = CellWidth;
			vec3.y = CellWidth;
			vec3 = IsometricMath.toIsometric(vec3);
			trace(vec3);*/
			
			
			/*for (i = 0; i < _width; i++)
			{
				for (j = 0; j < _height; j++)
				{
					if (_cells[i][j].hitTestPoint(nativeStage.mouseX, nativeStage.mouseY, true))
					{
						return new Point(_cells[i][j].mapX, _cells[i][j].mapY);
					}
				}
			}*/
			
			return _mouseCell;
		}
		
		public function set mouseWorkspace(workspace : WorkspaceEntity) : void
		{
			_mouseWorkspace = workspace;
		}
		
		public function get mouseWorkspace() : WorkspaceEntity
		{
			return _mouseWorkspace;
		}
		
		public function set mouseWorker(worker : WorkerEntity) : void
		{
			_mouseWorker = worker;
		}
		
		public function get mouseWorker() : WorkerEntity
		{
			return _mouseWorker;
		}
		
		public function set mouseWall(wall : WallEntity) : void
		{
			_mouseWall = wall;
			if (wall && _moving && (_moving is WallEntity) && (_movingX!=wall.wallX || _movingY!=wall.getRotation())) {
				_movingX = wall.wallX;
				_movingY = wall.getRotation();
				_boughtCorrect = _moving.move(_movingX, _movingY);
				//trace(_movingX, _movingY);
				_scene.render();
				//trace(_movingX, _movingY);
			}
		}
		
		public function get mouseWall() : WallEntity
		{
			/*var i : int;
			var j : int;
			
			var dim : Array = [_width, _height];
			
			for (i = 0; i < 2; i++)
			{
				for (j = 0; j < dim[i]; j++)
				{
					if (_walls[i][j].hitTestPoint(nativeStage.mouseX, nativeStage.mouseY, true))
					{
						return new Point(_walls[i][j].wall, _walls[i][j].mapX);
					}
				}
			}
			
			return null;*/
			return _mouseWall;
		}
		
		public function get mapMoved() : Boolean
		{
			return _mMoved;
		}
		
		public static function get instance() : Map
		{
			return _instance;
		}
		
		public function get moving():GameEntity
		{
			return _moving;
		}
		
		public function set moving(value:GameEntity):void
		{
			_moving = value;
		}
		
		public function canInteract(ge_ : GameEntity) : Boolean
		{
			return _moving === ge_ || _moving == null;
		}
	}
}