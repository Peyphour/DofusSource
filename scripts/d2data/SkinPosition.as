package d2data
{
   import utils.ReadOnlyData;
   
   public class SkinPosition extends ReadOnlyData
   {
       
      
      public function SkinPosition(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get transformation() : Object
      {
         return secure(_target.transformation);
      }
      
      public function get clip() : Object
      {
         return secure(_target.clip);
      }
      
      public function get skin() : Object
      {
         return secure(_target.skin);
      }
   }
}
