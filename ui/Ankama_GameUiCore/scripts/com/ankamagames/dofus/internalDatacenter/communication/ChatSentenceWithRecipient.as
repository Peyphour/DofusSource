package com.ankamagames.dofus.internalDatacenter.communication
{
   public class ChatSentenceWithRecipient extends ChatSentenceWithSource
   {
       
      
      public function ChatSentenceWithRecipient()
      {
         super();
      }
      
      public function get receiverName() : String
      {
         return null;
      }
      
      public function get receiverId() : Number
      {
         return 0;
      }
   }
}
