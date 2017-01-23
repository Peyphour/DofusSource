package d2network
{
   import utils.ReadOnlyData;
   
   public class QuestActiveInformations extends ReadOnlyData
   {
       
      
      public function QuestActiveInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get questId() : uint
      {
         return _target.questId;
      }
   }
}
