package d2network
{
   public class StatisticDataShort extends StatisticData
   {
       
      
      public function StatisticDataShort(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
