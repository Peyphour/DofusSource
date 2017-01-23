package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.ConfigPropertyChange;
   import types.ConfigProperty;
   
   public class ConfigUi
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var configApi:ConfigApi;
      
      protected var _properties:Array;
      
      public function ConfigUi()
      {
         super();
      }
      
      public function init(param1:Array) : void
      {
         var _loc2_:ConfigProperty = null;
         this._properties = param1;
         for each(_loc2_ in this._properties)
         {
            if(!_loc2_.associatedProperty)
            {
               this.uiApi.me().getElement(_loc2_.associatedComponent).disabled = true;
            }
            else
            {
               this.updateDisplay(_loc2_,this.configApi.getConfigProperty(_loc2_.associatedConfigModule,_loc2_.associatedProperty),true);
            }
         }
         this.sysApi.addHook(ConfigPropertyChange,this.onConfigPropertyChange);
      }
      
      public function reset() : void
      {
         var _loc1_:ConfigProperty = null;
         for each(_loc1_ in this._properties)
         {
            this.configApi.resetConfigProperty(_loc1_.associatedConfigModule,_loc1_.associatedProperty);
         }
      }
      
      public function setProperty(param1:String, param2:String, param3:*) : void
      {
         var _loc4_:ConfigProperty = null;
         for each(_loc4_ in this._properties)
         {
            if(param2 == _loc4_.associatedProperty && param1 == _loc4_.associatedConfigModule)
            {
               this.configApi.setConfigProperty(_loc4_.associatedConfigModule,_loc4_.associatedProperty,param3);
               this.updateDisplay(_loc4_,param3);
               break;
            }
         }
      }
      
      public function showDefaultBtn(param1:Boolean) : void
      {
         var _loc2_:Object = this.uiApi.getUi("optionContainer");
         if(_loc2_)
         {
            _loc2_.uiClass.btn_default.visible = param1;
         }
      }
      
      private function updateDisplay(param1:ConfigProperty, param2:*, param3:Boolean = false) : void
      {
         var _loc4_:Object = this.uiApi.me().getElement(param1.associatedComponent);
         switch(true)
         {
            case param2 is Boolean:
               _loc4_.selected = param2;
               if(param3)
               {
                  this.uiApi.addComponentHook(_loc4_ as GraphicContainer,"onRelease");
               }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:ConfigProperty = null;
         for each(_loc2_ in this._properties)
         {
            if(param1.name == _loc2_.associatedComponent)
            {
               this.configApi.setConfigProperty(_loc2_.associatedConfigModule,_loc2_.associatedProperty,param1.selected);
               this.updateDisplay(_loc2_,param1.selected);
               break;
            }
         }
      }
      
      private function onConfigPropertyChange(param1:String, param2:String, param3:*, param4:*) : void
      {
         var _loc5_:ConfigProperty = null;
         for each(_loc5_ in this._properties)
         {
            if(param1 == _loc5_.associatedConfigModule && param2 == _loc5_.associatedProperty)
            {
               this.updateDisplay(_loc5_,param3);
               break;
            }
         }
      }
   }
}
