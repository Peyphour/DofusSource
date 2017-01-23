package d2network
{
   import utils.ReadOnlyData;
   
   public class ObjectEffect extends ReadOnlyData
   {
       
      
      public function ObjectEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get actionId() : uint
      {
         return _target.actionId;
      }
   }
}
