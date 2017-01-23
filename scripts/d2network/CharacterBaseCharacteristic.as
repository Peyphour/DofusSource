package d2network
{
   import utils.ReadOnlyData;
   
   public class CharacterBaseCharacteristic extends ReadOnlyData
   {
       
      
      public function CharacterBaseCharacteristic(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get base() : int
      {
         return _target.base;
      }
      
      public function get additionnal() : int
      {
         return _target.additionnal;
      }
      
      public function get objectsAndMountBonus() : int
      {
         return _target.objectsAndMountBonus;
      }
      
      public function get alignGiftBonus() : int
      {
         return _target.alignGiftBonus;
      }
      
      public function get contextModif() : int
      {
         return _target.contextModif;
      }
   }
}
