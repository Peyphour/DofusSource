package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentBalance extends ReadOnlyData
   {
       
      
      public function AlignmentBalance(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get startValue() : int
      {
         return _target.startValue;
      }
      
      public function get endValue() : int
      {
         return _target.endValue;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
   }
}
