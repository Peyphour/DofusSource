package d2network
{
   public class FightResultTaxCollectorListEntry extends FightResultFighterListEntry
   {
       
      
      public function FightResultTaxCollectorListEntry(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get guildInfo() : BasicGuildInformations
      {
         return secure(_target.guildInfo);
      }
      
      public function get experienceForGuild() : int
      {
         return _target.experienceForGuild;
      }
   }
}
