package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentEffect extends ReadOnlyData
   {
       
      
      public function AlignmentEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get characteristicId() : uint
      {
         return _target.characteristicId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
   }
}
