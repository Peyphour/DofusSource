package d2network
{
   public class StatisticDataByte extends StatisticData
   {
       
      
      public function StatisticDataByte(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
