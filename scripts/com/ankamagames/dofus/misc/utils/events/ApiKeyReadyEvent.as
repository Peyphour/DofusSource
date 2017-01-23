package com.ankamagames.dofus.misc.utils.events
{
   import flash.events.Event;
   
   public class ApiKeyReadyEvent extends Event
   {
      
      public static const READY:String = "READY";
       
      
      private var _haapiKeyType:uint;
      
      private var _haapiKey:String;
      
      public function ApiKeyReadyEvent(param1:uint, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         this._haapiKeyType = param1;
         this._haapiKey = param2;
         super(READY,param3,param4);
      }
      
      public function get haapiKeyType() : uint
      {
         return this._haapiKeyType;
      }
      
      public function get haapiKey() : String
      {
         return this._haapiKey;
      }
   }
}
