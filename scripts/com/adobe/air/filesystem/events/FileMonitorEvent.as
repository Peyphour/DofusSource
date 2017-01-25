package com.adobe.air.filesystem.events
{
   import flash.events.Event;
   import flash.filesystem.File;
   
   public class FileMonitorEvent extends Event
   {
      
      public static const CHANGE:String = "onFileChange";
      
      public static const MOVE:String = "onFileMove";
      
      public static const REMOVE_VOLUME:String = "onVolumeRemove";
      
      public static const CREATE:String = "onFileCreate";
      
      public static const ADD_VOLUME:String = "onVolumeAdd";
       
      
      public var file:File;
      
      public function FileMonitorEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:FileMonitorEvent = new FileMonitorEvent(type,bubbles,cancelable);
         _loc1_.file = this.file;
         return _loc1_;
      }
   }
}
