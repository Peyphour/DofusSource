package d2network
{
   import utils.ReadOnlyData;
   
   public class FriendSpouseInformations extends ReadOnlyData
   {
       
      
      public function FriendSpouseInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get spouseAccountId() : uint
      {
         return _target.spouseAccountId;
      }
      
      public function get spouseId() : Number
      {
         return _target.spouseId;
      }
      
      public function get spouseName() : String
      {
         return _target.spouseName;
      }
      
      public function get spouseLevel() : uint
      {
         return _target.spouseLevel;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : int
      {
         return _target.sex;
      }
      
      public function get spouseEntityLook() : EntityLook
      {
         return secure(_target.spouseEntityLook);
      }
      
      public function get guildInfo() : GuildInformations
      {
         return secure(_target.guildInfo);
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
   }
}
