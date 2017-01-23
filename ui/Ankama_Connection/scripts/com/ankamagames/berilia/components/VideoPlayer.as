package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   
   public class VideoPlayer extends GraphicContainer
   {
       
      
      public function VideoPlayer()
      {
         super();
      }
      
      public function get autoLoop() : Boolean
      {
         return new Boolean();
      }
      
      public function set autoLoop(param1:Boolean) : void
      {
      }
      
      public function get keepRatio() : Boolean
      {
         return new Boolean();
      }
      
      public function set keepRatio(param1:Boolean) : void
      {
      }
      
      public function connect() : void
      {
      }
      
      public function play() : void
      {
      }
      
      public function stop() : void
      {
      }
      
      public function pause() : void
      {
      }
      
      public function resume() : void
      {
      }
      
      public function get paused() : Boolean
      {
         return false;
      }
      
      public function get playing() : Boolean
      {
         return false;
      }
      
      public function get smoothing() : Boolean
      {
         return false;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
      }
      
      public function set flv(param1:String) : void
      {
      }
      
      public function get flv() : String
      {
         return null;
      }
      
      public function set fms(param1:String) : void
      {
      }
      
      public function get fms() : String
      {
         return null;
      }
      
      public function get autoPlay() : Boolean
      {
         return false;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
      }
      
      public function set mute(param1:Boolean) : void
      {
      }
      
      public function get mute() : Boolean
      {
         return false;
      }
   }
}
