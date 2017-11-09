package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.common.map.MapRotation;
	import com.sigma.socialgame.controller.map.objects.MapObject;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.view.game.map.objects.WorkspaceEntity;
	
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FragmentFilter;
	import flash.errors.EOFError;
	import flash.events.MouseEvent;
	import starling.events.Touch;
	import starling.filters.BloomFilter;

	public class WorkspaceGraphicLoader extends GraphicLoader
	{
		private var _mcTable : WorkspacePartGraphicLoader;
		private var _mcBottomChair : WorkspacePartGraphicLoader;
		private var _mcTopChair : WorkspacePartGraphicLoader;
		
		private var _entity : WorkspaceEntity;
		
		public function WorkspaceGraphicLoader(entity_ : WorkspaceEntity)
		{
			_entity = entity_;
			
			_mcTable = new WorkspacePartGraphicLoader(WorkspacePartType.Table);
			_mcBottomChair = new WorkspacePartGraphicLoader(WorkspacePartType.Chair);
			_mcTopChair = new WorkspacePartGraphicLoader(WorkspacePartType.Chair);
			//_mcTopChair.touchable = false;
			//_mcBottomChair.touchable = false;
			
			var loaders : Array = [_mcTable, _mcBottomChair, _mcTopChair];
			
			for each (var localLoader : WorkspacePartGraphicLoader in loaders)
			{
				localLoader.addEventListener(GraphicLoaderEvent.Loaded, onWorkspacePartLoaded);
				localLoader.addEventListener(TouchEvent.TOUCH, onWorkspacePartMouseEvent);
				/*localLoader.addEventListener(MouseEvent.MOUSE_OVER, onWorkspacePartMouseEvent);
				localLoader.addEventListener(MouseEvent.MOUSE_OUT, onWorkspacePartMouseEvent);
				localLoader.addEventListener(MouseEvent.MOUSE_DOWN, onWorkspacePartMouseEvent);
				localLoader.addEventListener(MouseEvent.MOUSE_UP, onWorkspacePartMouseEvent);
				localLoader.addEventListener(MouseEvent.MOUSE_MOVE, onWorkspacePartMouseEvent);
				localLoader.addEventListener(MouseEvent.CLICK, onWorkspacePartMouseEvent);*/
			}

			super();
		}
		
		public override function set filter(value:FragmentFilter):void
		{
			_mcTable.filter = value;
			if (_mcBottomChair) _mcBottomChair.filter = value;
			if (_mcTopChair) _mcTopChair.filter = value;
		}
		
		public override function set mapObject(mapObj_:MapObject):void
		{
			_mcTable.mapObject = mapObj_;
			if (_mcBottomChair) _mcBottomChair.mapObject = mapObj_;
			if (_mcTopChair) _mcTopChair.mapObject = mapObj_;
		}
		
		private function onWorkspacePartMouseEvent(e : TouchEvent) : void
		{
			_entity.onMouseEvent(e);
		}
		
		public override function load():void
		{
			_loadCount = 0;
			
			_mcTable.load();
			_mcBottomChair.load();
			_mcTopChair.load();
		}
		
		private var _loadCount : int = 0;
		private function onWorkspacePartLoaded(e : GraphicLoaderEvent) : void
		{
			++_loadCount;
			if (_loadCount >= 3)
			{
				this.loaded = true;
				_loadCount = 0;
				dispatchEvent(new GraphicLoaderEvent(GraphicLoaderEvent.Loaded));
			}
		}

		public override function selectState(state_:String):void
		{
			if (_state == state_)
			{
				Logger.message("Specifide state: " + state_ + " for " + mapObject.toString() + "is already selected.", TAG, LogLevel.Warning, LogModule.View);
			}
			
			_mcTable.selectState(state_);

			if (_mcBottomChair) {
				_mcBottomChair.type = WorkspacePartType.BottomChairPart;
				_mcBottomChair.selectState(state_);
			}
			
			if (_mcTopChair) {
				_mcTopChair.type = WorkspacePartType.TopChairPart;
				_mcTopChair.selectState(state_);
				if (_mcTopChair.mcWorkspacePart) _mcTopChair.mcWorkspacePart.y += WorkspaceEntity.ChairHeight;
			}
			
			/*if (_mcTopChair.isError || _mcBottomChair.isError)
			{
				_mcTopChair.type = WorkspacePartType.Chair;
				_mcTopChair.selectState(state_);
				
				_mcBottomChair.type = WorkspacePartType.Chair;
				_mcBottomChair.selectState(state_);				
			}*/
		}

		public function get mcBottomChair():Sprite
		{
			return _mcBottomChair;
		}

		public function get mcTopChair():Sprite
		{
			return _mcTopChair;
		}
		
		public function get needToDivideChair() : Boolean
		{
			return (_mcTopChair.type == WorkspacePartType.TopChairPart);
		}
		
		public function get mcTable():Sprite
		{
			return _mcTable;
		}
		
		override public function set touchable(value:Boolean):void {
			super.touchable = value;
			_mcTable.touchable = value;
			if (_mcBottomChair) _mcBottomChair.touchable = value;
			if (_mcTopChair) _mcTopChair.touchable = value;
		}
	}
}