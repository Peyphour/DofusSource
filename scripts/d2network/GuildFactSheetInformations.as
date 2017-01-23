package d2network
{
   public class GuildFactSheetInformations extends GuildInformations
   {
       
      
      public function GuildFactSheetInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get leaderId() : Number
      {
         return _target.leaderId;
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
   }
}
