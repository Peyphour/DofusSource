package d2data
{
   import utils.ReadOnlyData;
   
   public class Challenge extends ReadOnlyData
   {
       
      
      public function Challenge(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get dareAvailable() : Boolean
      {
         return _target.dareAvailable;
      }
      
      public function get incompatibleChallenges() : Object
      {
         return secure(_target.incompatibleChallenges);
      }
   }
}
