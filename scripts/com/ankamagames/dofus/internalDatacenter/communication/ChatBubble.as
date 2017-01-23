package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class ChatBubble implements IDataCenter
   {
       
      
      private var _text:String;
      
      public function ChatBubble(param1:String)
      {
         super();
         this._text = param1;
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}
