package d2data
{
   import utils.ReadOnlyData;
   
   public class DareCriteriaWrapper extends ReadOnlyData
   {
       
      
      public function DareCriteriaWrapper(param1:*, param2:Object)
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
