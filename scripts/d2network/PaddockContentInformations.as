package d2network
{
   public class PaddockContentInformations extends PaddockInformations
   {
       
      
      public function PaddockContentInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get paddockId() : int
      {
         return _target.paddockId;
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
      
      public function get subAreaId() : uint
      {
         return _target.subAreaId;
      }
      
      public function get abandonned() : Boolean
      {
         return _target.abandonned;
      }
      
      public function get mountsInformations() : Object
      {
         return secure(_target.mountsInformations);
      }
   }
}
