package com.ankamagames.dofus.uiApi
{
   public class SoundApi
   {
       
      
      public function SoundApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function activateSounds(param1:Boolean) : void
      {
      }
      
      [Untrusted]
      public function soundsAreActivated() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function updaterAvailable() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function setBusVolume(param1:uint, param2:uint) : void
      {
      }
      
      [Untrusted]
      public function playSoundById(param1:String) : void
      {
      }
      
      [Untrusted]
      public function playStopablesoundById(param1:String) : void
      {
      }
      
      [Untrusted]
      public function stopStopablesoundById(param1:String) : void
      {
      }
      
      [Untrusted]
      public function fadeBusVolume(param1:uint, param2:Number, param3:uint) : void
      {
      }
      
      [Untrusted]
      public function playSound(param1:uint) : void
      {
      }
      
      [Untrusted]
      public function playLookSound(param1:String, param2:uint) : void
      {
      }
      
      [Trusted]
      public function playIntroMusic() : void
      {
      }
      
      [Trusted]
      public function switchIntroMusic(param1:Boolean = true) : void
      {
      }
      
      [Trusted]
      public function stopIntroMusic() : void
      {
      }
      
      [Untrusted]
      public function playSoundAtTurnStart() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function playSoundForGuildMessage() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isSoundMainClient() : Boolean
      {
         return false;
      }
   }
}
