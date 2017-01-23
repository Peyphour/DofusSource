package d2network
{
   public class InteractiveElementNamedSkill extends InteractiveElementSkill
   {
       
      
      public function InteractiveElementNamedSkill(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
   }
}
