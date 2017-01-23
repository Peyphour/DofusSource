package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.dofus.datacenter.ambientSounds.PlaylistSound;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.playlists.Playlist;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.jerakine.BalanceManager.BalanceManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.VolumeFadeEffect;
   import flash.utils.getQualifiedClassName;
   
   public class FightMusicManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(FightMusicManager));
       
      
      private var _fightMusics:Vector.<AmbientSound>;
      
      private var _bossMusics:Vector.<AmbientSound>;
      
      private var _fightMusic:PlaylistSound;
      
      private var _bossMusic:PlaylistSound;
      
      private var _hasBoss:Boolean;
      
      private var _fightMusicsId:Array;
      
      private var _fightMusicBalanceManager:BalanceManager;
      
      private var _actualFightMusic:ISound;
      
      private var _fightMusicPlaylist:Playlist;
      
      private var _bossMusicPlaylist:Playlist;
      
      public function FightMusicManager()
      {
         super();
         this.init();
      }
      
      public function prepareFightMusic() : void
      {
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.PREPARE_FIGHT_MUSIC);
      }
      
      public function isBossBattle() : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc3_:GameFightMonsterInformations = null;
         var _loc4_:Monster = null;
         this._hasBoss = false;
         var _loc1_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(_loc1_)
         {
            for each(_loc2_ in _loc1_.getEntitiesDictionnary())
            {
               if(_loc2_ is GameFightMonsterInformations)
               {
                  _loc3_ = _loc2_ as GameFightMonsterInformations;
                  _loc4_ = Monster.getMonsterById(_loc3_.creatureGenericId);
                  if(_loc4_.isBoss)
                  {
                     this._hasBoss = true;
                  }
               }
            }
         }
      }
      
      public function startFightPlaylist(param1:Number = -1, param2:Number = 1) : void
      {
         var _loc3_:PlaylistSound = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Uri = null;
         var _loc7_:VolumeFadeEffect = null;
         var _loc8_:Array = null;
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         if(this._hasBoss && this._bossMusic)
         {
            _loc3_ = this._bossMusic;
         }
         else
         {
            _loc3_ = this._fightMusic;
         }
         if(_loc3_)
         {
            _loc4_ = SoundUtil.getBusIdBySoundId(String(_loc3_.id));
            _loc5_ = SoundUtil.getConfigEntryByBusId(_loc4_);
            _loc6_ = new Uri(_loc5_ + _loc3_.id + ".mp3");
            if(SoundManager.getInstance().manager is ClassicSoundManager)
            {
               this._actualFightMusic = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc6_);
            }
            if(SoundManager.getInstance().manager is RegSoundManager)
            {
               this._actualFightMusic = new SoundDofus(String(_loc3_.id));
            }
            this._actualFightMusic.busId = _loc4_;
            this._actualFightMusic.volume = 1;
            this._actualFightMusic.currentFadeVolume = 0;
            _loc7_ = new VolumeFadeEffect(param1,param2,TubulSoundConfiguration.TIME_FADE_IN_MUSIC);
            _loc8_ = new Array();
            if(this._hasBoss && this._bossMusicPlaylist)
            {
               _loc8_ = this.createPlaylistSounds(this._bossMusicPlaylist);
            }
            else if(this._fightMusicPlaylist)
            {
               _loc8_ = this.createPlaylistSounds(this._fightMusicPlaylist);
            }
            if(_loc8_.length > 0)
            {
               RegConnectionManager.getInstance().send(ProtocolEnum.ADD_SOUNDS_PLAYLIST,_loc8_);
            }
            this._actualFightMusic.play(true,0,_loc7_);
         }
      }
      
      public function stopFightMusic() : void
      {
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.STOP_FIGHT_MUSIC);
      }
      
      public function setFightSounds(param1:Vector.<AmbientSound>, param2:Vector.<AmbientSound>, param3:Playlist, param4:Playlist) : void
      {
         var _loc6_:AmbientSound = null;
         this._fightMusics = param1;
         this._bossMusics = param2;
         this._fightMusicPlaylist = param3;
         this._bossMusicPlaylist = param4;
         var _loc5_:String = "";
         if(this._fightMusics.length == 0 && this._bossMusics.length == 0 && (!this._fightMusicPlaylist || this._fightMusicPlaylist.sounds.length == 0) && (!this._bossMusicPlaylist || this._bossMusicPlaylist.sounds.length == 0))
         {
            _loc5_ = "Ni musique de combat, ni musique de boss ???";
         }
         else
         {
            _loc5_ = "Cette map contient les musiques de combat : ";
            for each(_loc6_ in this._fightMusics)
            {
               _loc5_ = _loc5_ + (_loc6_.id + ", ");
            }
            _loc5_ = " et les musiques de boss d\'id : ";
            for each(_loc6_ in this._bossMusics)
            {
               _loc5_ = _loc5_ + (_loc6_.id + ", ");
            }
         }
         _log.info(_loc5_);
      }
      
      public function selectValidSounds() : void
      {
         var _loc1_:int = 0;
         var _loc3_:PlaylistSound = null;
         var _loc4_:AmbientSound = null;
         var _loc2_:int = 0;
         if(this._fightMusicPlaylist && this._fightMusicPlaylist.sounds.length > 0)
         {
            _loc2_ = this._fightMusicPlaylist.sounds.length;
            _loc1_ = int(Math.random() * _loc2_);
            for each(_loc3_ in this._fightMusicPlaylist.sounds)
            {
               if(_loc1_ == 0)
               {
                  this._fightMusic = _loc3_;
                  break;
               }
               _loc1_--;
            }
         }
         else
         {
            for each(_loc4_ in this._fightMusics)
            {
               _loc2_++;
            }
            _loc1_ = int(Math.random() * _loc2_);
            for each(_loc4_ in this._fightMusics)
            {
               if(_loc1_ == 0)
               {
                  this._fightMusic = _loc4_;
                  break;
               }
               _loc1_--;
            }
         }
         if(this._bossMusicPlaylist && this._bossMusicPlaylist.sounds.length > 0)
         {
            _loc2_ = this._bossMusicPlaylist.sounds.length;
            _loc1_ = int(Math.random() * _loc2_);
            for each(_loc3_ in this._bossMusicPlaylist.sounds)
            {
               if(_loc1_ == 0)
               {
                  this._bossMusic = _loc3_;
                  break;
               }
               _loc1_--;
            }
         }
         else
         {
            for each(_loc4_ in this._bossMusics)
            {
               _loc2_++;
            }
            _loc1_ = int(Math.random() * _loc2_);
            for each(_loc4_ in this._bossMusics)
            {
               if(_loc1_ == 0)
               {
                  this._bossMusic = _loc4_;
                  break;
               }
               _loc1_--;
            }
         }
      }
      
      private function init() : void
      {
         this._fightMusicsId = TubulSoundConfiguration.fightMusicIds;
         this._fightMusicBalanceManager = new BalanceManager(this._fightMusicsId);
      }
      
      private function createPlaylistSounds(param1:Playlist) : Array
      {
         var _loc3_:PlaylistSound = null;
         var _loc4_:ISound = null;
         var _loc5_:Uri = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1.sounds)
         {
            if(!(this._fightMusic && _loc3_.id == this._fightMusic.id || this._bossMusic && _loc3_.id == this._bossMusic.id))
            {
               _loc6_ = SoundUtil.getConfigEntryByBusId(_loc3_.channel);
               _loc5_ = new Uri(_loc6_ + _loc3_.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  _loc4_ = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc5_);
                  _loc4_.busId = _loc3_.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  _loc4_ = new SoundDofus(String(_loc3_.id));
               }
               _loc7_ = param1.iteration;
               if(_loc7_ <= 0)
               {
                  _loc7_ = 1;
               }
               _loc4_.setLoops(_loc7_);
               _loc4_.volume = _loc3_.volume / 100;
               _loc4_.currentFadeVolume = 0;
               _loc2_.push(_loc4_.id);
            }
         }
         return _loc2_;
      }
   }
}
