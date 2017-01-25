package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.criterion.GroupItemCriterion;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class TradeStockItemWrapper implements IDataCenter
   {
       
      
      public var itemWrapper:ItemWrapper;
      
      public var price:uint;
      
      public var category:int;
      
      public var criterion:GroupItemCriterion;
      
      public function TradeStockItemWrapper()
      {
         super();
      }
      
      public static function create(param1:ItemWrapper, param2:uint, param3:GroupItemCriterion = null) : TradeStockItemWrapper
      {
         var _loc4_:TradeStockItemWrapper = new TradeStockItemWrapper();
         var _loc5_:uint = Item.getItemById(param1.objectGID).category;
         _loc4_.itemWrapper = param1;
         _loc4_.price = param2;
         _loc4_.category = _loc5_;
         _loc4_.criterion = param3;
         return _loc4_;
      }
      
      public static function createFromObjectItemToSell(param1:Object, param2:GroupItemCriterion = null) : TradeStockItemWrapper
      {
         var _loc3_:TradeStockItemWrapper = new TradeStockItemWrapper();
         var _loc4_:ItemWrapper = ItemWrapper.create(0,param1.objectUID,param1.objectGID,param1.quantity,param1.effects,false);
         var _loc5_:uint = Item.getItemById(param1.objectGID).category;
         _loc3_.itemWrapper = _loc4_;
         _loc3_.price = param1.objectPrice;
         _loc3_.category = _loc5_;
         _loc3_.criterion = param2;
         return _loc3_;
      }
   }
}
