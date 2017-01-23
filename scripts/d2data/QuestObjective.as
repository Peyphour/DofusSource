package d2data
{
   import utils.ReadOnlyData;
   
   public class QuestObjective extends ReadOnlyData
   {
       
      
      public function QuestObjective(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get stepId() : uint
      {
         return _target.stepId;
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get dialogId() : int
      {
         return _target.dialogId;
      }
      
      public function get parameters() : Object
      {
         return secure(_target.parameters);
      }
      
      public function get coords() : Object
      {
         return secure(_target.coords);
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
   }
}
