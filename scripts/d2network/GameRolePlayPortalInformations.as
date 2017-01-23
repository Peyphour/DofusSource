package d2network
{
   public class GameRolePlayPortalInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayPortalInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get portal() : PortalInformation
      {
         return secure(_target.portal);
      }
   }
}
