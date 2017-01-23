package d2data
{
   import utils.ReadOnlyData;
   
   public class BonusCriterion extends ReadOnlyData
   {
       
      
      public function BonusCriterion(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
