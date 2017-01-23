package d2network
{
   public class StatisticDataBoolean extends StatisticData
   {
       
      
      public function StatisticDataBoolean(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get value() : Boolean
      {
         return _target.value;
      }
   }
}
