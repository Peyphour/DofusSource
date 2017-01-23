package d2network
{
   public class InteractiveElementWithAgeBonus extends InteractiveElement
   {
       
      
      public function InteractiveElementWithAgeBonus(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get ageBonus() : int
      {
         return _target.ageBonus;
      }
   }
}
