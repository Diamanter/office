package com.sigma.socialgame.view.game.map.objects.graphic
{
	import com.sigma.socialgame.common.logger.LogLevel;
	import com.sigma.socialgame.common.logger.LogModule;
	import com.sigma.socialgame.common.logger.Logger;
	import com.sigma.socialgame.events.view.GraphicLoaderEvent;
	import com.sigma.socialgame.model.ResourceManager;
	import com.sigma.socialgame.model.graphic.SWFLib;
	import com.sigma.socialgame.model.objects.config.object.skill.SkillData;
	import com.sigma.socialgame.model.objects.sync.store.WorkerStoreObjectData;
	import com.sigma.socialgame.view.gui.GuiIds;
	import com.sigma.socialgame.view.gui.SkinManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.animation.Juggler;
	import flash.net.getClassByAlias;
	import flash.geom.Vector3D;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class WorkerGraphicLoader extends GraphicLoader
	{
		private var _skill : SkillData;
		
		public function WorkerGraphicLoader()
		{
			super();
			_border = 25;
		}
		
		private var _needToPlayAnimation : Boolean = false;
		
		override public function load () : void {
			var states : Array = GraphicLoaderFactory.createStates(_mapObj.mapObject.storeObject.object);
			var classes : Array = GraphicLoaderFactory.createClasses(_mapObj.mapObject.storeObject.object, states, (_mapObj.mapObject.storeObject as WorkerStoreObjectData).currSkill);
			var newclass : Class;
			_textures = new Object();
			for (var i : int = 0; i < states.length; i++)
			{
				_textures[states[i]] = SkinManager.instance.getSkinTextures(classes[i]);
				if (_textures[states[i]].length==0) _textures[states[i]] = SkinManager.instance.getSkinTextures("worker_"+classes[i]);
			}
			_loaded = true;
			dispatchEvent(new GraphicLoaderEvent(GraphicLoaderEvent.Loaded));
		}
		
		public function set needToPlayAnimation(value_ : Boolean) : void
		{
			_needToPlayAnimation = value_;
			UpdateAnimation();
		}
		
		public function get needToPlayAnimation() : Boolean
		{
			return _needToPlayAnimation;
		}
		
		protected function UpdateAnimation() : void
		{
			if (mc == null)
				return;
			
			if (_needToPlayAnimation)
			{
				Starling.juggler.add(this.mc);
			}
			else
			{
				Starling.juggler.remove(this.mc);
				this.mc.currentFrame = 0;
			}			
		}
		
		public function get skill():SkillData
		{
			return _skill;
		}

		public function set skill(value:SkillData):void
		{
			_skill = value;
		}
		
		
	}
}