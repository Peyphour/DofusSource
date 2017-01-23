package d2network
{
   public class HumanOptionOrnament extends HumanOption
   {
       
      
      public function HumanOptionOrnament(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get ornamentId() : uint
      {
         return _target.ornamentId;
      }
   }
}
