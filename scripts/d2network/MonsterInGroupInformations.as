package d2network
{
   public class MonsterInGroupInformations extends MonsterInGroupLightInformations
   {
       
      
      public function MonsterInGroupInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get look() : EntityLook
      {
         return secure(_target.look);
      }
   }
}
