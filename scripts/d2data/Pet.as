package d2data
{
   import utils.ReadOnlyData;
   
   public class Pet extends ReadOnlyData
   {
       
      
      public function Pet(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get foodItems() : Object
      {
         return secure(_target.foodItems);
      }
      
      public function get foodTypes() : Object
      {
         return secure(_target.foodTypes);
      }
      
      public function get minDurationBeforeMeal() : int
      {
         return _target.minDurationBeforeMeal;
      }
      
      public function get maxDurationBeforeMeal() : int
      {
         return _target.maxDurationBeforeMeal;
      }
      
      public function get possibleEffects() : Object
      {
         return secure(_target.possibleEffects);
      }
   }
}
