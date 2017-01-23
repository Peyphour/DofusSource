package d2data
{
   import utils.ReadOnlyData;
   
   public class CompanionSpell extends ReadOnlyData
   {
       
      
      public function CompanionSpell(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get spellId() : int
      {
         return _target.spellId;
      }
      
      public function get companionId() : int
      {
         return _target.companionId;
      }
      
      public function get gradeByLevel() : String
      {
         return _target.gradeByLevel;
      }
   }
}
