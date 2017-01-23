package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentRankJntGift extends ReadOnlyData
   {
       
      
      public function AlignmentRankJntGift(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get gifts() : Object
      {
         return secure(_target.gifts);
      }
      
      public function get parameters() : Object
      {
         return secure(_target.parameters);
      }
      
      public function get levels() : Object
      {
         return secure(_target.levels);
      }
   }
}
