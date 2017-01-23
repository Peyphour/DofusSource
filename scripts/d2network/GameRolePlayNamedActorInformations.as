package d2network
{
   public class GameRolePlayNamedActorInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayNamedActorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
   }
}
