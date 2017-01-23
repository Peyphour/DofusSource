package d2data
{
   import utils.ReadOnlyData;
   
   public class Bonus extends ReadOnlyData
   {
       
      
      public function Bonus(param1:*, param2:Object)
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
      
      public function get amount() : int
      {
         return _target.amount;
      }
      
      public function get criterionsIds() : Object
      {
         return secure(_target.criterionsIds);
      }
   }
}
