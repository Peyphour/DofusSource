package com.ankamagames.berilia.types.event
{
   import com.ankamagames.berilia.types.data.Hook;
   import flash.events.Event;
   
   public class HookEvent extends Event
   {
      
      public static const DISPATCHED:String = "hooDispatched";
       
      
      private var _hook:Hook;
      
      public function HookEvent(param1:String, param2:Hook)
      {
         super(param1,false,false);
         this._hook = param2;
      }
      
      public function get hook() : Hook
      {
         return this._hook;
      }
   }
}
