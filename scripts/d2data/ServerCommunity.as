package d2data
{
   import utils.ReadOnlyData;
   
   public class ServerCommunity extends ReadOnlyData
   {
       
      
      public function ServerCommunity(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get shortId() : String
      {
         return _target.shortId;
      }
      
      public function get defaultCountries() : Object
      {
         return secure(_target.defaultCountries);
      }
   }
}
