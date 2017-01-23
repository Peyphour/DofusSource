package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.social.AbstractSocialGroupInfos;
   
   public class BasicAllianceInformations extends AbstractSocialGroupInfos
   {
       
      
      public function BasicAllianceInformations()
      {
         super();
      }
      
      public function get allianceId() : uint
      {
         return new uint();
      }
      
      public function get allianceTag() : String
      {
         return new String();
      }
   }
}
