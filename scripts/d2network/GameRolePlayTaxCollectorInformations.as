package d2network
{
   public class GameRolePlayTaxCollectorInformations extends GameRolePlayActorInformations
   {
       
      
      public function GameRolePlayTaxCollectorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get identification() : TaxCollectorStaticInformations
      {
         return secure(_target.identification);
      }
      
      public function get guildLevel() : uint
      {
         return _target.guildLevel;
      }
      
      public function get taxCollectorAttack() : int
      {
         return _target.taxCollectorAttack;
      }
   }
}
