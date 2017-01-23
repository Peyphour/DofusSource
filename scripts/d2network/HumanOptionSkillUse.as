package d2network
{
   public class HumanOptionSkillUse extends HumanOption
   {
       
      
      public function HumanOptionSkillUse(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get elementId() : uint
      {
         return _target.elementId;
      }
      
      public function get skillId() : uint
      {
         return _target.skillId;
      }
      
      public function get skillEndTime() : Number
      {
         return _target.skillEndTime;
      }
   }
}
