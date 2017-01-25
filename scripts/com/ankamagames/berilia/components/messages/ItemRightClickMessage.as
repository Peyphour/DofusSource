package com.ankamagames.berilia.components.messages
{
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.types.data.GridItem;
   
   public class ItemRightClickMessage extends ComponentMessage
   {
       
      
      private var _gridItem:GridItem;
      
      public function ItemRightClickMessage(param1:Grid, param2:GridItem)
      {
         super(param1);
         this._gridItem = param2;
      }
      
      public function get item() : GridItem
      {
         return this._gridItem;
      }
   }
}
