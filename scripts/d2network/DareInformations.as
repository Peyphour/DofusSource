package d2network
{
   import utils.ReadOnlyData;
   
   public class DareInformations extends ReadOnlyData
   {
       
      
      public function DareInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get dareId() : Number
      {
         return _target.dareId;
      }
      
      public function get creator() : CharacterBasicMinimalInformations
      {
         return secure(_target.creator);
      }
      
      public function get subscriptionFee() : uint
      {
         return _target.subscriptionFee;
      }
      
      public function get jackpot() : uint
      {
         return _target.jackpot;
      }
      
      public function get maxCountWinners() : uint
      {
         return _target.maxCountWinners;
      }
      
      public function get endDate() : Number
      {
         return _target.endDate;
      }
      
      public function get isPrivate() : Boolean
      {
         return _target.isPrivate;
      }
      
      public function get guildId() : uint
      {
         return _target.guildId;
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
      
      public function get criterions() : Object
      {
         return secure(_target.criterions);
      }
      
      public function get startDate() : Number
      {
         return _target.startDate;
      }
   }
}
