package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentOrder extends ReadOnlyData
   {
       
      
      public function AlignmentOrder(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get sideId() : uint
      {
         return _target.sideId;
      }
   }
}
