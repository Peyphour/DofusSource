package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithRecipient;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithSource;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class ChatApi
   {
       
      
      public function ChatApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getChannelsId() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getDisallowedChannelsId() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getChatColors() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyMood() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getMessagesByChannel(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getParagraphByChannel(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHistoryMessagesByChannel(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getMessagesStoredMax() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function addParagraphToHistory(param1:int, param2:Object) : void
      {
      }
      
      [Untrusted]
      public function removeLinesFromHistory(param1:int, param2:int) : void
      {
      }
      
      [Untrusted]
      public function setMaxMessagesStored(param1:int) : void
      {
      }
      
      [Untrusted]
      public function getMaxMessagesStored() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function newBasicChatSentence(param1:uint, param2:String, param3:uint = 0, param4:Number = 0, param5:String = "") : BasicChatSentence
      {
         return null;
      }
      
      [Untrusted]
      public function newChatSentenceWithSource(param1:uint, param2:String, param3:uint = 0, param4:Number = 0, param5:String = "", param6:Number = 0, param7:String = "", param8:Object = null) : ChatSentenceWithSource
      {
         return null;
      }
      
      [Untrusted]
      public function newChatSentenceWithRecipient(param1:uint, param2:String, param3:uint = 0, param4:Number = 0, param5:String = "", param6:Number = 0, param7:String = "", param8:String = "", param9:Number = 0, param10:Object = null) : ChatSentenceWithRecipient
      {
         return null;
      }
      
      [Untrusted]
      public function getTypeOfChatSentence(param1:Object) : String
      {
         return null;
      }
      
      [Untrusted]
      public function searchChannel(param1:String) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getHistoryByIndex(param1:String, param2:uint) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getRedChannelId() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getStaticHyperlink(param1:String) : String
      {
         return null;
      }
      
      [Untrusted]
      public function newChatItem(param1:ItemWrapper) : String
      {
         return null;
      }
      
      [Untrusted]
      public function addAutocompletionNameEntry(param1:String, param2:int) : void
      {
      }
      
      [Untrusted]
      public function getAutocompletion(param1:String, param2:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getGuildLink(param1:*, param2:String = null) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getAllianceLink(param1:*, param2:String = null, param3:String = null, param4:String = null) : String
      {
         return null;
      }
      
      [Trusted]
      public function changeCssHandler(param1:String) : void
      {
      }
      
      [Trusted]
      public function logChat(param1:String, param2:String) : void
      {
      }
      
      [Trusted]
      public function launchExternalChat() : void
      {
      }
      
      [Untrusted]
      public function clearConsoleChat() : void
      {
      }
      
      [Untrusted]
      public function isExternalChatOpened() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function setExternalChatChannels(param1:Array) : void
      {
      }
      
      [Trusted]
      public function addHtmlLink(param1:String, param2:String) : String
      {
         return null;
      }
      
      [Trusted]
      public function addSpan(param1:String, param2:Object) : void
      {
      }
      
      [Trusted]
      public function escapeChatString(param1:String) : String
      {
         return null;
      }
      
      [Trusted]
      public function unEscapeChatString(param1:String) : String
      {
         return null;
      }
   }
}
