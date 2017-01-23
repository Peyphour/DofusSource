package d2network
{
   import utils.ReadOnlyData;
   
   public class InteractiveElementSkill extends ReadOnlyData
   {
       
      
      public function InteractiveElementSkill(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get skillId() : uint
      {
         return _target.skillId;
      }
      
      public function get skillInstanceUid() : uint
      {
         return _target.skillInstanceUid;
      }
   }
}
