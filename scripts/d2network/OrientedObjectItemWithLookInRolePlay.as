package d2network
{
   public class OrientedObjectItemWithLookInRolePlay extends ObjectItemWithLookInRolePlay
   {
       
      
      public function OrientedObjectItemWithLookInRolePlay(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get direction() : uint
      {
         return _target.direction;
      }
   }
}
