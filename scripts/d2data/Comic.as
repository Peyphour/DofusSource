package d2data
{
   import utils.ReadOnlyData;
   
   public class Comic extends ReadOnlyData
   {
       
      
      public function Comic(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get remoteId() : String
      {
         return _target.remoteId;
      }
   }
}
