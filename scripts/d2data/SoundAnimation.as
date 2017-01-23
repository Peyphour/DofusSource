package d2data
{
   import utils.ReadOnlyData;
   
   public class SoundAnimation extends ReadOnlyData
   {
       
      
      public function SoundAnimation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get label() : String
      {
         return _target.label;
      }
      
      public function get filename() : String
      {
         return _target.filename;
      }
      
      public function get volume() : int
      {
         return _target.volume;
      }
      
      public function get rolloff() : int
      {
         return _target.rolloff;
      }
      
      public function get automationDuration() : int
      {
         return _target.automationDuration;
      }
      
      public function get automationVolume() : int
      {
         return _target.automationVolume;
      }
      
      public function get automationFadeIn() : int
      {
         return _target.automationFadeIn;
      }
      
      public function get automationFadeOut() : int
      {
         return _target.automationFadeOut;
      }
      
      public function get noCutSilence() : Boolean
      {
         return _target.noCutSilence;
      }
      
      public function get startFrame() : uint
      {
         return _target.startFrame;
      }
   }
}
