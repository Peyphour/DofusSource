package d2network
{
   public class StatisticDataInt extends StatisticData
   {
       
      
      public function StatisticDataInt(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : int
      {
         return _target.value;
      }
   }
}
