package d2network
{
   public class HumanOptionTitle extends HumanOption
   {
       
      
      public function HumanOptionTitle(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get titleId() : uint
      {
         return _target.titleId;
      }
      
      public function get titleParam() : String
      {
         return _target.titleParam;
      }
   }
}
