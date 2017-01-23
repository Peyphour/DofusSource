package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   
   public class AlliancePrismInformation extends PrismInformation
   {
       
      
      public function AlliancePrismInformation()
      {
         super();
      }
      
      public function get alliance() : AllianceInformations
      {
         return new AllianceInformations();
      }
   }
}
