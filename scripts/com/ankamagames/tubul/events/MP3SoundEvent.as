package com.ankamagames.tubul.events
{
   import com.ankamagames.tubul.interfaces.ISound;
   import flash.events.Event;
   
   public class MP3SoundEvent extends Event
   {
      
      public static const SOON_END_OF_FILE:String = "SOON_END_OF_FILE";
       
      
      public var sound:ISound;
      
      public function MP3SoundEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:MP3SoundEvent = new MP3SoundEvent(type,bubbles,cancelable);
         _loc1_.sound = this.sound;
         return _loc1_;
      }
   }
}
