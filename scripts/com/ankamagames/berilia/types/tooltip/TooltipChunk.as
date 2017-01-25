package com.ankamagames.berilia.types.tooltip
{
   import flash.events.EventDispatcher;
   
   public class TooltipChunk extends EventDispatcher
   {
       
      
      private var _content:String;
      
      public function TooltipChunk(param1:String)
      {
         super();
         this._content = param1;
      }
      
      public function processContent(param1:Object, param2:Object = null) : String
      {
         var _loc4_:* = null;
         var _loc3_:String = this._content;
         for(_loc4_ in param1)
         {
            _loc3_ = _loc3_.split("#" + _loc4_).join(param1[_loc4_]);
         }
         if(param2)
         {
            for(_loc4_ in param2)
            {
               _loc3_ = _loc3_.split("#" + _loc4_).join(param2[_loc4_]);
            }
         }
         return _loc3_;
      }
      
      public function get content() : String
      {
         return this._content;
      }
   }
}
