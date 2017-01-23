package com.ankamagames.arena.dofusmodule.adapter
{
   import d2api.ConfigApi;
   import d2api.SoundApi;
   import d2api.SystemApi;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class OptionDofusCommunicator extends EventDispatcher implements IOptionCommunicator
   {
      
      public static const EVT_MUTE_ARENA:String = "com.ankamagames.arena.dofusmodule.adapter.OptionDofusCommunicator.EVT_MUTE_ARENA";
      
      public static const EVT_UNMUTE_ARENA:String = "com.ankamagames.arena.dofusmodule.adapter.OptionDofusCommunicator.EVT_UNMUTE_ARENA";
       
      
      private var _sysApi:SystemApi;
      
      private var _soundApi:SoundApi;
      
      private var _configApi:ConfigApi;
      
      private var _soundVolume:Number;
      
      private var _ambientVolume:Number;
      
      private var _musicVolume:Number;
      
      public function OptionDofusCommunicator(param1:SystemApi, param2:SoundApi, param3:ConfigApi)
      {
         super();
         this._sysApi = param1;
         this._soundApi = param2;
         this._configApi = param3;
      }
      
      public function destroy() : void
      {
         this._sysApi = null;
         this._soundApi = null;
         this._configApi = null;
      }
      
      public function getHostCurrentLanguage() : String
      {
         return this._sysApi.getCurrentLanguage();
      }
      
      public function isSoundActivated() : Boolean
      {
         return this._soundApi.soundsAreActivated();
      }
      
      public function setMusicVolume(param1:Number) : void
      {
         this._configApi.setConfigProperty("tubul","volumeMusic",param1);
      }
      
      public function setAmbianceVolume(param1:Number) : void
      {
         this._configApi.setConfigProperty("tubul","volumeAmbientSound",param1);
      }
      
      public function setSoundVolume(param1:Number) : void
      {
         this._configApi.setConfigProperty("tubul","volumeSound",param1);
      }
      
      public function getMusicVolume() : Number
      {
         return this._configApi.getConfigProperty("tubul","volumeMusic");
      }
      
      public function getAmbianceVolume() : Number
      {
         return this._configApi.getConfigProperty("tubul","volumeAmbientSound");
      }
      
      public function getSoundVolume() : Number
      {
         return this._configApi.getConfigProperty("tubul","volumeSound");
      }
      
      public function maximise() : void
      {
         this._musicVolume = this.getMusicVolume();
         this._ambientVolume = this.getAmbianceVolume();
         this._soundVolume = this.getSoundVolume();
         this.setMusicVolume(0);
         this.setAmbianceVolume(0);
         dispatchEvent(new Event(EVT_UNMUTE_ARENA));
      }
      
      public function minimise() : void
      {
         this.setMusicVolume(this._musicVolume);
         this.setAmbianceVolume(this._ambientVolume);
         dispatchEvent(new Event(EVT_MUTE_ARENA));
      }
   }
}
