package com.ankamagames.berilia.types.data
{
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import flash.display.DisplayObject;
   
   public class GridItem implements IDataCenter
   {
       
      
      public var index:uint;
      
      public var container:DisplayObject;
      
      public var data;
      
      public function GridItem(param1:uint, param2:DisplayObject, param3:*)
      {
         super();
         this.index = param1;
         this.container = param2;
         this.data = param3;
      }
   }
}
