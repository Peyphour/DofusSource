package d2network
{
   public class FightResultMutantListEntry extends FightResultFighterListEntry
   {
       
      
      public function FightResultMutantListEntry(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
