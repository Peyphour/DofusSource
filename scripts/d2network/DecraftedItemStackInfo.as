package d2network
{
   import utils.ReadOnlyData;
   
   public class DecraftedItemStackInfo extends ReadOnlyData
   {
       
      
      public function DecraftedItemStackInfo(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objectUID() : uint
      {
         return _target.objectUID;
      }
      
      public function get bonusMin() : Number
      {
         return _target.bonusMin;
      }
      
      public function get bonusMax() : Number
      {
         return _target.bonusMax;
      }
      
      public function get runesId() : Object
      {
         return secure(_target.runesId);
      }
      
      public function get runesQty() : Object
      {
         return secure(_target.runesQty);
      }
   }
}
