package d2network
{
   public class BasicNamedAllianceInformations extends BasicAllianceInformations
   {
       
      
      public function BasicNamedAllianceInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceName() : String
      {
         return _target.allianceName;
      }
   }
}
