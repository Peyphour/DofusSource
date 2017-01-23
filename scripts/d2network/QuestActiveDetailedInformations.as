package d2network
{
   public class QuestActiveDetailedInformations extends QuestActiveInformations
   {
       
      
      public function QuestActiveDetailedInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get stepId() : uint
      {
         return _target.stepId;
      }
      
      public function get objectives() : Object
      {
         return secure(_target.objectives);
      }
   }
}
