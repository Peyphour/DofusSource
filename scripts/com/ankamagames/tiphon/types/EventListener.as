package com.ankamagames.tiphon.types
{
   import com.ankamagames.jerakine.interfaces.IFLAEventHandler;
   
   public class EventListener
   {
       
      
      public var listener:IFLAEventHandler;
      
      public var typesEvents:String;
      
      public function EventListener(param1:IFLAEventHandler, param2:String)
      {
         super();
         this.listener = param1;
         this.typesEvents = param2;
      }
   }
}
