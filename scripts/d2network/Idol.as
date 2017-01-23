package d2network
{
   import utils.ReadOnlyData;
   
   public class Idol extends ReadOnlyData
   {
       
      
      public function Idol(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get xpBonusPercent() : uint
      {
         return _target.xpBonusPercent;
      }
      
      public function get dropBonusPercent() : uint
      {
         return _target.dropBonusPercent;
      }
   }
}
