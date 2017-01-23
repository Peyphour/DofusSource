package com.ankamagames.berilia.managers
{
   import flash.errors.IllegalOperationError;
   
   public class SecureCenter
   {
      
      public static const ACCESS_KEY:Object = new Object();
       
      
      public function SecureCenter()
      {
         super();
      }
      
      public static function destroy(param1:*) : void
      {
         if(param1 && "destroy" in param1)
         {
            param1.destroy();
         }
      }
      
      public static function checkAccessKey(param1:Object) : void
      {
         if(param1 != ACCESS_KEY)
         {
            throw new IllegalOperationError("Wrong access key");
         }
      }
   }
}
