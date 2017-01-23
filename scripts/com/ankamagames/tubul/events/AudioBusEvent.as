package com.ankamagames.tubul.events
{
   import com.ankamagames.tubul.interfaces.ISound;
   import flash.events.Event;
   
   public class AudioBusEvent extends Event
   {
      
      public static const ADD_SOUND_IN_BUS:String = "add_sound_in_bus";
      
      public static const REMOVE_SOUND_IN_BUS:String = "remove_sound_in_bus";
       
      
      public var sound:ISound;
      
      public function AudioBusEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:AudioBusEvent = new AudioBusEvent(type,bubbles,cancelable);
         _loc1_.sound = this.sound;
         return _loc1_;
      }
   }
}
