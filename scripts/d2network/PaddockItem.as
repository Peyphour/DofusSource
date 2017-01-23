package d2network
{
   public class PaddockItem extends ObjectItemInRolePlay
   {
       
      
      public function PaddockItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get durability() : ItemDurability
      {
         return secure(_target.durability);
      }
   }
}
