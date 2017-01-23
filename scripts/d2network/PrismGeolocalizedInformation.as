package d2network
{
   public class PrismGeolocalizedInformation extends PrismSubareaEmptyInfo
   {
       
      
      public function PrismGeolocalizedInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get worldX() : int
      {
         return _target.worldX;
      }
      
      public function get worldY() : int
      {
         return _target.worldY;
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get prism() : PrismInformation
      {
         return secure(_target.prism);
      }
   }
}
