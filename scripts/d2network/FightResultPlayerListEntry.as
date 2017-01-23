package d2network
{
   public class FightResultPlayerListEntry extends FightResultFighterListEntry
   {
       
      
      public function FightResultPlayerListEntry(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get additional() : Object
      {
         return secure(_target.additional);
      }
   }
}
