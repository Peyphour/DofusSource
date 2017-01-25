package com.ankamagames.jerakine.managers
{
   import flash.display.DisplayObject;
   import flash.filters.BitmapFilter;
   import flash.utils.Dictionary;
   
   public class FiltersManager
   {
      
      private static var _self:FiltersManager;
       
      
      private var dFilters:Dictionary;
      
      public function FiltersManager(param1:PrivateClass#3083)
      {
         super();
         this.dFilters = new Dictionary(true);
      }
      
      public static function getInstance() : FiltersManager
      {
         if(_self == null)
         {
            _self = new FiltersManager(new PrivateClass#3083());
         }
         return _self;
      }
      
      public function addEffect(param1:DisplayObject, param2:BitmapFilter) : void
      {
         var _loc3_:Array = this.dFilters[param1] as Array;
         if(_loc3_ == null)
         {
            _loc3_ = this.dFilters[param1] = param1.filters;
         }
         _loc3_.push(param2);
         param1.filters = _loc3_;
      }
      
      public function removeEffect(param1:DisplayObject, param2:BitmapFilter) : void
      {
         var _loc3_:Array = this.dFilters[param1] as Array;
         if(_loc3_ == null)
         {
            _loc3_ = this.dFilters[param1] = param1.filters;
         }
         var _loc4_:int = this.indexOf(param1,param2);
         if(_loc4_ != -1)
         {
            _loc3_.splice(_loc4_,1);
            param1.filters = _loc3_;
         }
      }
      
      public function indexOf(param1:DisplayObject, param2:BitmapFilter) : int
      {
         var _loc5_:BitmapFilter = null;
         var _loc3_:Array = this.dFilters[param1] as Array;
         if(_loc3_ == null)
         {
            return -1;
         }
         var _loc4_:int = _loc3_.length;
         while(_loc4_--)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_ == param2)
            {
               return _loc4_;
            }
         }
         return -1;
      }
   }
}

class PrivateClass#3083
{
    
   
   function PrivateClass#3083()
   {
      super();
   }
}
