package d2network
{
   import utils.ReadOnlyData;
   
   public class EntityMovementInformations extends ReadOnlyData
   {
       
      
      public function EntityMovementInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get steps() : Object
      {
         return secure(_target.steps);
      }
   }
}
