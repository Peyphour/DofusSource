package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.WindowResize;
   
   public class Proto
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var ctr_ui:GraphicContainer;
      
      public function Proto()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(WindowResize,this.onWindowResize);
         this.onWindowResize(this.uiApi.getWindowWidth(),this.uiApi.getWindowHeight(),this.uiApi.getWindowScale());
      }
      
      public function onWindowResize(param1:uint, param2:uint, param3:Number) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:Number = 1280 / 1024;
         if(param1 / param2 < _loc4_ + 0.01 && param1 / param2 > _loc4_ - 0.01)
         {
            return;
         }
         var _loc5_:uint = param1 * 1 / param3;
         var _loc6_:uint = param2 * 1 / param3;
         this.ctr_ui.width = _loc5_;
         this.ctr_ui.height = _loc6_;
         if(_loc5_ > _loc6_ * _loc4_)
         {
            _loc8_ = _loc6_;
            _loc7_ = _loc6_ * _loc4_;
         }
         else
         {
            _loc8_ = _loc5_ * 1 / _loc4_;
            _loc7_ = _loc5_;
         }
         this.ctr_ui.x = -(_loc5_ - _loc7_) / 2;
         this.ctr_ui.y = -(_loc6_ - _loc8_) / 2;
         this.uiApi.me().render();
      }
   }
}
