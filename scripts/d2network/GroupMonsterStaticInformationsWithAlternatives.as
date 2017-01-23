package d2network
{
   public class GroupMonsterStaticInformationsWithAlternatives extends GroupMonsterStaticInformations
   {
       
      
      public function GroupMonsterStaticInformationsWithAlternatives(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get alternatives() : Object
      {
         return secure(_target.alternatives);
      }
   }
}
