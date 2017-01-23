package d2network
{
   import utils.ReadOnlyData;
   
   public class GroupMonsterStaticInformations extends ReadOnlyData
   {
       
      
      public function GroupMonsterStaticInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get mainCreatureLightInfos() : MonsterInGroupLightInformations
      {
         return secure(_target.mainCreatureLightInfos);
      }
      
      public function get underlings() : Object
      {
         return secure(_target.underlings);
      }
   }
}
