package d2network
{
   import utils.ReadOnlyData;
   
   public class AbstractContactInformations extends ReadOnlyData
   {
       
      
      public function AbstractContactInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get accountId() : uint
      {
         return _target.accountId;
      }
      
      public function get accountName() : String
      {
         return _target.accountName;
      }
   }
}
