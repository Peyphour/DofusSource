package com.ankama.codegen.client.model
{
   public class ThemisModel
   {
       
      
      public var model_id:Number = 0;
      
      public var model_success:Boolean = false;
      
      public var model_return:String = null;
      
      public var model_description:String = null;
      
      public function ThemisModel()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ThemisModel {\n");
         _loc1_.concat("  model_id: ").concat(this.model_id).concat("\n");
         _loc1_.concat("  model_success: ").concat(this.model_success).concat("\n");
         _loc1_.concat("  model_return: ").concat(this.model_return).concat("\n");
         _loc1_.concat("  model_description: ").concat(this.model_description).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
