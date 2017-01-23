package d2network
{
   import utils.ReadOnlyData;
   
   public class DareCriteria extends ReadOnlyData
   {
       
      
      public function DareCriteria(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get params() : Object
      {
         return secure(_target.params);
      }
   }
}
