package d2network
{
   public class ObjectItemWithLookInRolePlay extends ObjectItemInRolePlay
   {
       
      
      public function ObjectItemWithLookInRolePlay(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get entityLook() : EntityLook
      {
         return secure(_target.entityLook);
      }
   }
}
