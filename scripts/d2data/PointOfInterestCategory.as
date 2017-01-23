package d2data
{
   import utils.ReadOnlyData;
   
   public class PointOfInterestCategory extends ReadOnlyData
   {
       
      
      public function PointOfInterestCategory(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get actionLabelId() : uint
      {
         return _target.actionLabelId;
      }
   }
}
