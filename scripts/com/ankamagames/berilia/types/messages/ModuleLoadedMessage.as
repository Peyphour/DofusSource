package com.ankamagames.berilia.types.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class ModuleLoadedMessage implements Message
   {
       
      
      private var _moduleName:String;
      
      public function ModuleLoadedMessage(param1:String)
      {
         super();
         this._moduleName = param1;
      }
      
      public function get moduleName() : String
      {
         return this._moduleName;
      }
   }
}
