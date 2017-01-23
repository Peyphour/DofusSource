package d2network
{
   public class FightResultFighterListEntry extends FightResultListEntry
   {
       
      
      public function FightResultFighterListEntry(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get alive() : Boolean
      {
         return _target.alive;
      }
   }
}
