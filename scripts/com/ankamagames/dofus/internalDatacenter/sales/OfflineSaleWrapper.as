package com.ankamagames.dofus.internalDatacenter.sales
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class OfflineSaleWrapper implements IDataCenter
   {
      
      public static const TYPE_BIDHOUSE:uint = 1;
      
      public static const TYPE_MERCHANT:uint = 2;
      
      public static const TYPE_UNSOLD:uint = 3;
       
      
      public var index:uint;
      
      public var type:uint;
      
      public var itemId:uint;
      
      public var itemName:String;
      
      public var quantity:uint;
      
      public var kamas:Number;
      
      public function OfflineSaleWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint, param4:uint, param5:Number) : OfflineSaleWrapper
      {
         var _loc6_:OfflineSaleWrapper = new OfflineSaleWrapper();
         _loc6_.index = param1;
         _loc6_.type = param2;
         _loc6_.itemId = param3;
         _loc6_.itemName = Item.getItemById(_loc6_.itemId).name;
         _loc6_.quantity = param4;
         _loc6_.kamas = param5;
         return _loc6_;
      }
   }
}
