package com.ankama.codegen.client.model
{
   import flash.utils.Dictionary;
   
   public class ApiKey
   {
       
      
      public var key:String = null;
      
      public var account_id:Number = 0;
      
      public var ip:String = null;
      
      public var added_date:Date = null;
      
      public var meta:Array;
      
      public var data:Dictionary;
      
      public var access:Array;
      
      public var refresh_token:String = null;
      
      public var expiration_date:Date = null;
      
      public function ApiKey()
      {
         this.meta = new Array();
         this.data = new Dictionary();
         this.access = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ApiKey {\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  account_id: ").concat(this.account_id).concat("\n");
         _loc1_.concat("  ip: ").concat(this.ip).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("  meta: ").concat(this.meta).concat("\n");
         _loc1_.concat("  data: ").concat(this.data).concat("\n");
         _loc1_.concat("  access: ").concat(this.access).concat("\n");
         _loc1_.concat("  refresh_token: ").concat(this.refresh_token).concat("\n");
         _loc1_.concat("  expiration_date: ").concat(this.expiration_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
