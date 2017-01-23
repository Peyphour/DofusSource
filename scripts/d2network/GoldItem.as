package d2network
{
   public class GoldItem extends Item
   {
       
      
      public function GoldItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get sum() : uint
      {
         return _target.sum;
      }
   }
}
