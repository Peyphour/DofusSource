package d2data
{
   import utils.ReadOnlyData;
   
   public class EffectsWrapper extends ReadOnlyData
   {
       
      
      public function EffectsWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get spellName() : String
      {
         return _target.spellName;
      }
      
      public function get casterName() : String
      {
         return _target.casterName;
      }
   }
}
