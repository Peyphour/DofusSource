package d2network
{
   public class BasicAllianceInformations extends AbstractSocialGroupInfos
   {
       
      
      public function BasicAllianceInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
      
      public function get allianceTag() : String
      {
         return _target.allianceTag;
      }
   }
}
