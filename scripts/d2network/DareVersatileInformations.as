package d2network
{
   import utils.ReadOnlyData;
   
   public class DareVersatileInformations extends ReadOnlyData
   {
       
      
      public function DareVersatileInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get dareId() : Number
      {
         return _target.dareId;
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
