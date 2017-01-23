package d2data
{
   import utils.ReadOnlyData;
   
   public class Recipe extends ReadOnlyData
   {
       
      
      public function Recipe(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get resultId() : int
      {
         return _target.resultId;
      }
      
      public function get resultNameId() : uint
      {
         return _target.resultNameId;
      }
      
      public function get resultTypeId() : uint
      {
         return _target.resultTypeId;
      }
      
      public function get resultLevel() : uint
      {
         return _target.resultLevel;
      }
      
      public function get ingredientIds() : Object
      {
         return secure(_target.ingredientIds);
      }
      
      public function get quantities() : Object
      {
         return secure(_target.quantities);
      }
      
      public function get jobId() : int
      {
         return _target.jobId;
      }
      
      public function get skillId() : int
      {
         return _target.skillId;
      }
   }
}
