package com.ankamagames.berilia.types.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class UiXmlParsedMessage implements Message
   {
       
      
      private var _url:String;
      
      public function UiXmlParsedMessage(param1:String)
      {
         super();
         this._url = param1;
      }
      
      public function get url() : String
      {
         return this._url;
      }
   }
}
