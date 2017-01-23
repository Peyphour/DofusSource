package d2network
{
   import utils.ReadOnlyData;
   
   public class PlayerStatus extends ReadOnlyData
   {
       
      
      public function PlayerStatus(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get statusId() : uint
      {
         return _target.statusId;
      }
   }
}
