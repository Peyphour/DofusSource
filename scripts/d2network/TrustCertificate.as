package d2network
{
   import utils.ReadOnlyData;
   
   public class TrustCertificate extends ReadOnlyData
   {
       
      
      public function TrustCertificate(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get hash() : String
      {
         return _target.hash;
      }
   }
}
