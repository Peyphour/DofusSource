package d2network
{
   public class ActorExtendedAlignmentInformations extends ActorAlignmentInformations
   {
       
      
      public function ActorExtendedAlignmentInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get honor() : uint
      {
         return _target.honor;
      }
      
      public function get honorGradeFloor() : uint
      {
         return _target.honorGradeFloor;
      }
      
      public function get honorNextGradeFloor() : uint
      {
         return _target.honorNextGradeFloor;
      }
      
      public function get aggressable() : uint
      {
         return _target.aggressable;
      }
   }
}
