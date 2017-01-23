package d2network
{
   public class GameRolePlayPrismInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayPrismInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get prism() : PrismInformation
      {
         return secure(_target.prism);
      }
   }
}
