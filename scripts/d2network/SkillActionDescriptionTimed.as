package d2network
{
   public class SkillActionDescriptionTimed extends SkillActionDescription
   {
       
      
      public function SkillActionDescriptionTimed(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get time() : uint
      {
         return _target.time;
      }
   }
}
