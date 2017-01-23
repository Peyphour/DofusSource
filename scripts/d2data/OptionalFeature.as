package d2data
{
   import utils.ReadOnlyData;
   
   public class OptionalFeature extends ReadOnlyData
   {
       
      
      public function OptionalFeature(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get keyword() : String
      {
         return _target.keyword;
      }
   }
}
