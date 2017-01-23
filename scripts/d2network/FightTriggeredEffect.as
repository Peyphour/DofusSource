package d2network
{
   public class FightTriggeredEffect extends AbstractFightDispellableEffect
   {
       
      
      public function FightTriggeredEffect(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get param1() : int
      {
         return _target.param1;
      }
      
      public function get param2() : int
      {
         return _target.param2;
      }
      
      public function get param3() : int
      {
         return _target.param3;
      }
      
      public function get delay() : int
      {
         return _target.delay;
      }
   }
}
