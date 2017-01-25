package com.ankamagames.tubul.events
{
   import com.ankamagames.tubul.interfaces.ISoundController;
   import flash.events.Event;
   
   public class FadeEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
       
      
      public var soundSource:ISoundController;
      
      public function FadeEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:FadeEvent = new FadeEvent(type,bubbles,cancelable);
         _loc1_.soundSource = this.soundSource;
         return _loc1_;
      }
   }
}
