package com.ankamagames.tubul.events
{
   import com.ankamagames.tubul.interfaces.ISound;
   import flash.events.Event;
   
   public class SoundCompleteEvent extends Event
   {
      
      public static const SOUND_COMPLETE:String = "sound_complete";
       
      
      public var sound:ISound;
      
      public function SoundCompleteEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:SoundCompleteEvent = new SoundCompleteEvent(type,bubbles,cancelable);
         _loc1_.sound = this.sound;
         return _loc1_;
      }
   }
}
