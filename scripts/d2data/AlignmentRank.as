package d2data
{
   import utils.ReadOnlyData;
   
   public class AlignmentRank extends ReadOnlyData
   {
       
      
      public function AlignmentRank(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get orderId() : uint
      {
         return _target.orderId;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descriptionId() : uint
      {
         return _target.descriptionId;
      }
      
      public function get minimumAlignment() : int
      {
         return _target.minimumAlignment;
      }
      
      public function get objectsStolen() : int
      {
         return _target.objectsStolen;
      }
      
      public function get gifts() : Object
      {
         return secure(_target.gifts);
      }
   }
}
