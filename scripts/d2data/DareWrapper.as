package d2data
{
   import utils.ReadOnlyData;
   
   public class DareWrapper extends ReadOnlyData
   {
       
      
      public function DareWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get dareId() : Number
      {
         return _target.dareId;
      }
      
      public function get creatorId() : Number
      {
         return _target.creatorId;
      }
      
      public function get jackpot() : uint
      {
         return _target.jackpot;
      }
      
      public function get subscriptionFee() : uint
      {
         return _target.subscriptionFee;
      }
      
      public function get maxCountWinners() : uint
      {
         return _target.maxCountWinners;
      }
      
      public function get startDate() : Number
      {
         return _target.startDate;
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
      
      public function get subscribed() : Boolean
      {
         return _target.subscribed;
      }
      
      public function get won() : Boolean
      {
         return _target.won;
      }
      
      public function get countEntrants() : uint
      {
         return _target.countEntrants;
      }
      
      public function get countWinners() : uint
      {
         return _target.countWinners;
      }
   }
}
