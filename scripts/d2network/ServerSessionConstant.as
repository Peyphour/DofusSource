package d2network
{
   import utils.ReadOnlyData;
   
   public class ServerSessionConstant extends ReadOnlyData
   {
       
      
      public function ServerSessionConstant(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
   }
}
