package d2network
{
   public class QuestObjectiveInformationsWithCompletion extends QuestObjectiveInformations
   {
       
      
      public function QuestObjectiveInformationsWithCompletion(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get curCompletion() : uint
      {
         return _target.curCompletion;
      }
      
      public function get maxCompletion() : uint
      {
         return _target.maxCompletion;
      }
   }
}
