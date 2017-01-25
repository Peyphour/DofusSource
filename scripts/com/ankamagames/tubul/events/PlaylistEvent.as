package com.ankamagames.tubul.events
{
   import com.ankamagames.tubul.interfaces.ISound;
   import flash.events.Event;
   
   public class PlaylistEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const NEW_SOUND:String = "new_sound";
      
      public static const SOUND_ENDED:String = "sound_ended";
       
      
      public var newSound:ISound;
      
      public function PlaylistEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:PlaylistEvent = new PlaylistEvent(type,bubbles,cancelable);
         _loc1_.newSound = this.newSound;
         return _loc1_;
      }
   }
}
