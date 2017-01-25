package com.ankamagames.berilia.components.messages
{
   import flash.display.InteractiveObject;
   
   public class VideoBufferChangeMessage extends ComponentMessage
   {
       
      
      private var _state:uint;
      
      public function VideoBufferChangeMessage(param1:InteractiveObject, param2:uint)
      {
         super(param1);
         this._state = param2;
      }
      
      public function get state() : uint
      {
         return this._state;
      }
   }
}
