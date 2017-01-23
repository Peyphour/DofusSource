package d2network
{
   public class GameRolePlayMountInformations extends GameRolePlayNamedActorInformations
   {
       
      
      public function GameRolePlayMountInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get ownerName() : String
      {
         return _target.ownerName;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
