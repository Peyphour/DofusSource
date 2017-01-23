package d2network
{
   public class FightResultPvpData extends FightResultAdditionalData
   {
       
      
      public function FightResultPvpData(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
      
      public function get minHonorForGrade() : uint
      {
         return _target.minHonorForGrade;
      }
      
      public function get maxHonorForGrade() : uint
      {
         return _target.maxHonorForGrade;
      }
      
      public function get honor() : uint
      {
         return _target.honor;
      }
      
      public function get honorDelta() : int
      {
         return _target.honorDelta;
      }
   }
}
