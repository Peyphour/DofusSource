package d2data
{
   import utils.ReadOnlyData;
   
   public class Emoticon extends ReadOnlyData
   {
       
      
      public function Emoticon(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get shortcutId() : uint
      {
         return _target.shortcutId;
      }
      
      public function get order() : uint
      {
         return _target.order;
      }
      
      public function get defaultAnim() : String
      {
         return _target.defaultAnim;
      }
      
      public function get persistancy() : Boolean
      {
         return _target.persistancy;
      }
      
      public function get eight_directions() : Boolean
      {
         return _target.eight_directions;
      }
      
      public function get aura() : Boolean
      {
         return _target.aura;
      }
      
      public function get anims() : Object
      {
         return secure(_target.anims);
      }
      
      public function get cooldown() : uint
      {
         return _target.cooldown;
      }
      
      public function get duration() : uint
      {
         return _target.duration;
      }
      
      public function get weight() : uint
      {
         return _target.weight;
      }
   }
}
