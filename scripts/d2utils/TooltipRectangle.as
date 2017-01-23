package d2utils
{
   import utils.DirectAccessObject;
   
   public dynamic class TooltipRectangle extends DirectAccessObject
   {
       
      
      public function TooltipRectangle(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get x() : Number
      {
         return _target.x;
      }
      
      public function get y() : Number
      {
         return _target.y;
      }
      
      public function get width() : Number
      {
         return _target.width;
      }
      
      public function get height() : Number
      {
         return _target.height;
      }
      
      public function set x(param1:Number) : void
      {
         _target.x = param1;
      }
      
      public function set y(param1:Number) : void
      {
         _target.y = param1;
      }
      
      public function set width(param1:Number) : void
      {
         _target.width = param1;
      }
      
      public function set height(param1:Number) : void
      {
         _target.height = param1;
      }
      
      public function localToGlobal(param1:Object) : Object
      {
         return _target.localToGlobal(param1);
      }
      
      public function globalToLocal(param1:Object) : Object
      {
         return _target.globalToLocal(param1);
      }
   }
}
