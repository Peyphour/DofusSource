package com.ankamagames.jerakine.logger.targets
{
   class LoggerHistoryElement
   {
       
      
      private var m_level:int;
      
      private var m_message:String;
      
      private var m_subMessage:String;
      
      function LoggerHistoryElement(param1:int, param2:String, param3:String = "")
      {
         super();
         this.m_level = param1;
         this.m_message = param2;
         this.m_subMessage = param3;
      }
      
      public function get level() : int
      {
         return this.m_level;
      }
      
      public function get message() : String
      {
         return this.m_message;
      }
      
      public function get subMessage() : String
      {
         return this.m_subMessage;
      }
   }
}
