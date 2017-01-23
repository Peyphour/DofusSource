package d2network
{
   public class TaxCollectorGuildInformations extends TaxCollectorComplementaryInformations
   {
       
      
      public function TaxCollectorGuildInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guild() : BasicGuildInformations
      {
         return secure(_target.guild);
      }
   }
}
