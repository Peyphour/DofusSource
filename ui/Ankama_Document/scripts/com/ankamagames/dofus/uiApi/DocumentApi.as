package com.ankamagames.dofus.uiApi
{
   public class DocumentApi
   {
       
      
      public function DocumentApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getDocument(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getType(param1:uint) : uint
      {
         return 0;
      }
   }
}
