package com.ankamagames.berilia.components.messages
{
   import flash.display.InteractiveObject;
   
   public class DeleteTabMessage extends ComponentMessage
   {
       
      
      private var _deletedIndex:int;
      
      public function DeleteTabMessage(param1:InteractiveObject, param2:int)
      {
         super(param1);
         this._deletedIndex = param2;
      }
      
      public function get deletedIndex() : int
      {
         return this._deletedIndex;
      }
   }
}
