package d2network
{
   import utils.ReadOnlyData;
   
   public class QuestObjectiveInformations extends ReadOnlyData
   {
       
      
      public function QuestObjectiveInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectiveId() : uint
      {
         return _target.objectiveId;
      }
      
      public function get objectiveStatus() : Boolean
      {
         return _target.objectiveStatus;
      }
      
      public function get dialogParams() : Object
      {
         return secure(_target.dialogParams);
      }
   }
}
