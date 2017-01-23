package d2data
{
   import utils.ReadOnlyData;
   
   public class EmblemBackground extends ReadOnlyData
   {
       
      
      public function EmblemBackground(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get order() : int
      {
         return _target.order;
      }
   }
}
