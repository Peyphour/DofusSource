package com.ankamagames.dofus.logic.game.roleplay.types
{
   public class PortalTooltipInformation
   {
       
      
      public var areaId:int;
      
      public var checkSuperposition:Boolean;
      
      public var cellId:int;
      
      public function PortalTooltipInformation(param1:int, param2:Boolean = false, param3:int = -1)
      {
         super();
         this.areaId = param1;
         this.checkSuperposition = param2;
         this.cellId = param3;
      }
   }
}
