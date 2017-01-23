package d2network
{
   public class GuildMember extends CharacterMinimalInformations
   {
       
      
      public function GuildMember(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get rank() : uint
      {
         return _target.rank;
      }
      
      public function get givenExperience() : Number
      {
         return _target.givenExperience;
      }
      
      public function get experienceGivenPercent() : uint
      {
         return _target.experienceGivenPercent;
      }
      
      public function get rights() : uint
      {
         return _target.rights;
      }
      
      public function get connected() : uint
      {
         return _target.connected;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get hoursSinceLastConnection() : uint
      {
         return _target.hoursSinceLastConnection;
      }
      
      public function get moodSmileyId() : uint
      {
         return _target.moodSmileyId;
      }
      
      public function get accountId() : uint
      {
         return _target.accountId;
      }
      
      public function get achievementPoints() : int
      {
         return _target.achievementPoints;
      }
      
      public function get status() : PlayerStatus
      {
         return secure(_target.status);
      }
   }
}
