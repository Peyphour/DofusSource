package com.ankamagames.berilia.components.params
{
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.utils.UiProperties;
   import com.ankamagames.jerakine.utils.memory.WeakProxyReference;
   
   public class GridScriptProperties extends UiProperties
   {
       
      
      public var data;
      
      public var selected:Boolean;
      
      public var grid:WeakProxyReference;
      
      public function GridScriptProperties(param1:*, param2:Boolean = false, param3:Grid = null)
      {
         super();
         this.data = param1;
         this.selected = param2;
         this.grid = new WeakProxyReference(param3);
      }
   }
}
