package com.ankamagames.berilia.types.data
{
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   public class SlotDragAndDropData
   {
       
      
      public var currentHolder:ISlotDataHolder;
      
      public var slotData:ISlotData;
      
      public function SlotDragAndDropData(param1:ISlotDataHolder, param2:ISlotData)
      {
         super();
         this.currentHolder = param1;
         this.slotData = param2;
      }
   }
}
