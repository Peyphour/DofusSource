package d2network
{
   import utils.ReadOnlyData;
   
   public class SkillActionDescription extends ReadOnlyData
   {
       
      
      public function SkillActionDescription(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get skillId() : uint
      {
         return _target.skillId;
      }
   }
}
