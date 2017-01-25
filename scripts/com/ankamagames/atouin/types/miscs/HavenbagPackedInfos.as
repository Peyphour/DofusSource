package com.ankamagames.atouin.types.miscs
{
   public class HavenbagPackedInfos
   {
       
      
      public var furnitureTypeIds:Vector.<int>;
      
      public var furnitureCellIds:Vector.<uint>;
      
      public var furnitureOrientations:Vector.<uint>;
      
      public function HavenbagPackedInfos()
      {
         this.furnitureTypeIds = new Vector.<int>();
         this.furnitureCellIds = new Vector.<uint>();
         this.furnitureOrientations = new Vector.<uint>();
         super();
      }
      
      public static function createFromSharedObject(param1:Object) : HavenbagPackedInfos
      {
         var _loc2_:HavenbagPackedInfos = new HavenbagPackedInfos();
         _loc2_.furnitureTypeIds = param1.furnitureTypeIds;
         _loc2_.furnitureCellIds = param1.furnitureCellIds;
         _loc2_.furnitureOrientations = param1.furnitureOrientations;
         return _loc2_;
      }
   }
}
