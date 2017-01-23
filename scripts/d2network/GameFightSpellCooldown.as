package d2network
{
   import utils.ReadOnlyData;
   
   public class GameFightSpellCooldown extends ReadOnlyData
   {
       
      
      public function GameFightSpellCooldown(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get spellId() : int
      {
         return _target.spellId;
      }
      
      public function get cooldown() : uint
      {
         return _target.cooldown;
      }
   }
}
