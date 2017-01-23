package d2network
{
   public class StatisticDataString extends StatisticData
   {
       
      
      public function StatisticDataString(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : String
      {
         return _target.value;
      }
   }
}
