package com.ankamagames.dofus.types.data
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class ItemTooltipInfo
   {
       
      
      public var itemWrapper:ItemWrapper;
      
      public var shortcutKey:String;
      
      public function ItemTooltipInfo(param1:ItemWrapper, param2:String = null)
      {
         super();
         this.itemWrapper = param1;
         this.shortcutKey = param2;
      }
   }
}
