package d2network
{
   import utils.ReadOnlyData;
   
   public class ActorAlignmentInformations extends ReadOnlyData
   {
       
      
      public function ActorAlignmentInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get alignmentValue() : uint
      {
         return _target.alignmentValue;
      }
      
      public function get alignmentGrade() : uint
      {
         return _target.alignmentGrade;
      }
      
      public function get characterPower() : Number
      {
         return _target.characterPower;
      }
   }
}
