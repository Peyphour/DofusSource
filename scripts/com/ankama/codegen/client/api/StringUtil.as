package com.ankama.codegen.client.api
{
   public class StringUtil
   {
       
      
      public function StringUtil()
      {
         super();
      }
      
      public static function containsIgnoreCase(param1:Array, param2:String) : Boolean
      {
         var _loc3_:String = null;
         for each(_loc3_ in param1)
         {
            if(param2 == null && _loc3_ == null)
            {
               return true;
            }
            if(param2 != null && param2.toLowerCase() == _loc3_.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }
      
      public static function join(param1:Array, param2:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:int = param1.length;
         if(_loc3_ == 0)
         {
            return "";
         }
         _loc4_ = param1[0];
         for each(_loc5_ in param1)
         {
            _loc4_.concat(param2,_loc5_);
         }
         return _loc4_;
      }
   }
}
