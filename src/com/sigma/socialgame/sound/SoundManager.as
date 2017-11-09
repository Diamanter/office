package com.sigma.socialgame.sound
{
	import com.sigma.socialgame.events.sound.SoundFactoryEvent;
	import com.sigma.socialgame.events.sound.SoundManagerEvent;
	import com.sigma.socialgame.model.param.MusicState;
	import com.sigma.socialgame.model.param.ParamManager;
	import com.sigma.socialgame.model.param.ParamType;
	import com.sigma.socialgame.model.param.SoundState;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundManager extends EventDispatcher
	{
		private var _soundFactory : SoundFactory;
		
		private var _backMusic : SoundChannel;
		
		private static var _instance : SoundManager;
		
		private var _musicOn : Boolean = true;
		private var _soundOn : Boolean = true;
		
		public function SoundManager()
		{
			_instance = this;
		}
		
		public function init() : void
		{
			_soundFactory = new SoundFactory();
			
			_soundFactory.addEventListener(SoundFactoryEvent.SoundLoaded, onSoundLoaded);
			_soundFactory.init();
		}
		
		public function playMusic() : void
		{
			_backMusic = _soundFactory.back.play(0, 3000);
		}
		
		public function playEvent(event : String) : void
		{
			if (_soundOn)
				if (_soundFactory.sounds[event]) _soundFactory.sounds[event].play();
		}
		
		protected function onSoundLoaded(e : SoundFactoryEvent) : void
		{
			playMusic();
			
			if (ParamManager.instance.getSyncParam(ParamType.MusicState) == MusicState.On)
				musicOn = true;
			else
				musicOn = false;
			
			if (ParamManager.instance.getSyncParam(ParamType.SoundState) == SoundState.On)
				soundOn = true;
			else
				soundOn = false;
			
			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.SoundManagerInited));
		}
		
		public static function get instance() : SoundManager
		{
			return _instance;
		}

		public function get musicOn():Boolean
		{
			return _musicOn;
		}

		public function set musicOn(value:Boolean):void
		{
			_musicOn = value;
			
			var volume : Number = (_musicOn ? 1.0 : 0.0);
			
			var soundTrans : SoundTransform = _backMusic.soundTransform;
			soundTrans.volume = volume;
			_backMusic.soundTransform = soundTrans;
		}

		public function get soundOn():Boolean
		{
			return _soundOn;
		}

		public function set soundOn(value:Boolean):void
		{
			_soundOn = value;
		}


	}
}