package ui
{
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   
   public class TextWithShortcutTooltipUi
   {
       
      
      public var sysApi:SystemApi;
      
      public var tooltipApi:TooltipApi;
      
      public var mainCtr:Object;
      
      public var lbl_text:Object;
      
      public function TextWithShortcutTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.lbl_text.useCustomFormat = true;
         var _loc2_:* = param1.data.shortcut;
         if(_loc2_.indexOf("(") == 0 && _loc2_.indexOf(")") == _loc2_.length - 1)
         {
            _loc2_ = _loc2_.substr(1,_loc2_.length - 2);
         }
         var _loc3_:String = this.sysApi.getConfigEntry("colors.shortcut");
         _loc3_ = _loc3_.replace("0x","#");
         this.lbl_text.text = param1.data.text + " <font color=\'" + _loc3_ + "\'>(" + _loc2_ + ")</font>";
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
      }
   }
}
