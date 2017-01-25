package com.ankamagames.atouin.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class MapMessage implements Message
   {
       
      
      private var _id:uint;
      
      private var _transitionType:String;
      
      public var renderRequestId:uint;
      
      public function MapMessage()
      {
         super();
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(param1:uint) : void
      {
         this._id = param1;
      }
      
      public function get transitionType() : String
      {
         return this._transitionType;
      }
      
      public function set transitionType(param1:String) : void
      {
         this._transitionType = param1;
      }
   }
}
