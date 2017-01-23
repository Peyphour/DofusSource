package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   
   public class PrismTooltipInformation
   {
       
      
      public var allianceIdentity:AllianceWrapper;
      
      public var checkSuperposition:Boolean;
      
      public var cellId:int;
      
      public function PrismTooltipInformation(param1:AllianceWrapper, param2:Boolean = false, param3:int = -1)
      {
         super();
         this.allianceIdentity = param1;
         this.checkSuperposition = param2;
         this.cellId = param3;
      }
   }
}
