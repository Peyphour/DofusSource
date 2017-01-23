package d2network
{
   public class SkillActionDescriptionCraft extends SkillActionDescription
   {
       
      
      public function SkillActionDescriptionCraft(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get probability() : uint
      {
         return _target.probability;
      }
   }
}
