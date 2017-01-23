package d2data
{
   import utils.ReadOnlyData;
   
   public class SpeakingItemText extends ReadOnlyData
   {
       
      
      public function SpeakingItemText(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get textId() : int
      {
         return _target.textId;
      }
      
      public function get textProba() : Number
      {
         return _target.textProba;
      }
      
      public function get textStringId() : uint
      {
         return _target.textStringId;
      }
      
      public function get textLevel() : int
      {
         return _target.textLevel;
      }
      
      public function get textSound() : int
      {
         return _target.textSound;
      }
      
      public function get textRestriction() : String
      {
         return _target.textRestriction;
      }
   }
}
