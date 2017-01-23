package d2network
{
   import utils.ReadOnlyData;
   
   public class Achievement extends ReadOnlyData
   {
       
      
      public function Achievement(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get finishedObjective() : Object
      {
         return secure(_target.finishedObjective);
      }
      
      public function get startedObjectives() : Object
      {
         return secure(_target.startedObjectives);
      }
   }
}
