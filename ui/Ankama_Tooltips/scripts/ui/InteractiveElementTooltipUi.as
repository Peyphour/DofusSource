package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   
   public class InteractiveElementTooltipUi
   {
      
      private static const MARGIN:uint = 5;
       
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var jobsApi:JobsApi;
      
      public var ctr_elementName:GraphicContainer;
      
      public var lbl_elementName:Label;
      
      public var lbl_enabledSkills:Label;
      
      public var lbl_disabledSkills:Label;
      
      public var ctr_line:GraphicContainer;
      
      public var main_ctr:GraphicContainer;
      
      public var ctr_stars:GraphicContainer;
      
      public var star00:Texture;
      
      public var star01:Texture;
      
      public var star02:Texture;
      
      public var star03:Texture;
      
      public var star04:Texture;
      
      public var star10:Texture;
      
      public var star11:Texture;
      
      public var star12:Texture;
      
      public var star13:Texture;
      
      public var star14:Texture;
      
      public var star20:Texture;
      
      public var star21:Texture;
      
      public var star22:Texture;
      
      public var star23:Texture;
      
      public var star24:Texture;
      
      public function InteractiveElementTooltipUi()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc2_:Object = param1.data;
         this.main_ctr.width = 0;
         this.ctr_line.width = 0;
         this.ctr_elementName.width = 1;
         this.ctr_line.removeFromParent();
         this.ctr_elementName.removeFromParent();
         this.lbl_disabledSkills.removeFromParent();
         this.lbl_enabledSkills.removeFromParent();
         this.ctr_stars.removeFromParent();
         this.lbl_elementName.text = _loc2_.interactive;
         this.lbl_elementName.x = 0;
         this.ctr_elementName.x = 5;
         this.lbl_elementName.fullWidth();
         this.main_ctr.addContent(this.ctr_line);
         this.ctr_line.y = this.lbl_elementName.y + this.lbl_elementName.contentHeight;
         if(_loc2_.enabledSkills != "")
         {
            this.lbl_enabledSkills.visible = true;
            this.lbl_enabledSkills.y = this.lbl_elementName.y + this.lbl_elementName.contentHeight + MARGIN;
            this.lbl_enabledSkills.text = _loc2_.enabledSkills.substr(0,_loc2_.enabledSkills.lastIndexOf("\n"));
            this.lbl_disabledSkills.y = this.lbl_enabledSkills.y + this.lbl_enabledSkills.contentHeight;
         }
         else
         {
            this.lbl_enabledSkills.visible = false;
            this.lbl_disabledSkills.y = this.lbl_elementName.y + this.lbl_elementName.contentHeight + MARGIN;
         }
         this.lbl_disabledSkills.text = _loc2_.disabledSkills.substr(0,_loc2_.disabledSkills.lastIndexOf("\n"));
         this.lbl_disabledSkills.x = 5;
         this.lbl_enabledSkills.x = 5;
         this.main_ctr.addContent(this.lbl_disabledSkills);
         if(_loc2_.enabledSkills != "")
         {
            this.main_ctr.addContent(this.lbl_enabledSkills);
         }
         var _loc3_:Number = this.main_ctr.contentWidth;
         if(_loc2_.isCollectable)
         {
            if(_loc2_.hasOwnProperty("ageBonus"))
            {
               _loc5_ = _loc4_ = _loc2_.ageBonus;
               this.ctr_stars.y = this.ctr_line.y;
               this.star00.visible = false;
               this.star01.visible = false;
               this.star02.visible = false;
               this.star03.visible = false;
               this.star04.visible = false;
               this.star10.visible = false;
               this.star11.visible = false;
               this.star12.visible = false;
               this.star13.visible = false;
               this.star14.visible = false;
               this.star20.visible = false;
               this.star21.visible = false;
               this.star22.visible = false;
               this.star23.visible = false;
               this.star24.visible = false;
               _loc6_ = 1;
               if(_loc4_ > 100)
               {
                  _loc6_ = 2;
                  _loc5_ = _loc5_ - 100;
               }
               _loc7_ = Math.round(_loc5_ / 20);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  this["star" + _loc6_ + "" + _loc8_].visible = true;
                  _loc8_++;
               }
               _loc8_ = _loc8_;
               while(_loc8_ < 5)
               {
                  this["star" + (_loc6_ - 1) + "" + _loc8_].visible = true;
                  _loc8_++;
               }
               this.main_ctr.addContent(this.ctr_stars);
               this.ctr_line.y = this.ctr_stars.y + this.ctr_stars.contentHeight + MARGIN;
               _loc9_ = this.ctr_line.y + MARGIN;
               if(this.lbl_enabledSkills.visible)
               {
                  this.lbl_enabledSkills.y = this.ctr_line.y + MARGIN;
                  _loc9_ = this.lbl_enabledSkills.y + this.lbl_enabledSkills.contentHeight;
               }
               this.lbl_disabledSkills.y = _loc9_;
               if(this.lbl_enabledSkills.visible)
               {
                  this.lbl_enabledSkills.fullWidth();
               }
               this.lbl_disabledSkills.fullWidth();
               _loc3_ = this.getMaxWidth();
               this.ctr_stars.x = (_loc3_ - this.ctr_stars.width) / 2 + 5;
            }
         }
         this.main_ctr.addContent(this.ctr_elementName);
         if(this.lbl_elementName.width > _loc3_)
         {
            _loc3_ = this.lbl_elementName.width;
         }
         this.ctr_elementName.width = _loc3_;
         this.main_ctr.width = _loc3_;
         if(_loc2_.isCollectable)
         {
            this.lbl_elementName.x = (_loc3_ - this.lbl_elementName.width) / 2;
         }
         this.ctr_line.width = _loc3_;
         this.ctr_line.x = (_loc3_ - this.ctr_line.width) / 2 + 5;
         this.uiApi.me().render();
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
      }
      
      private function getMaxWidth() : Number
      {
         var _loc1_:Number = NaN;
         if(this.lbl_elementName.width >= this.ctr_stars.width)
         {
            _loc1_ = this.lbl_elementName.width;
         }
         else if(this.ctr_stars.width > this.lbl_elementName.width)
         {
            _loc1_ = this.ctr_stars.width;
         }
         if(this.lbl_enabledSkills.visible && this.lbl_enabledSkills.width > _loc1_)
         {
            _loc1_ = this.lbl_enabledSkills.width;
         }
         if(this.lbl_disabledSkills.width > _loc1_)
         {
            _loc1_ = this.lbl_disabledSkills.width;
         }
         return _loc1_;
      }
      
      public function unload() : void
      {
      }
   }
}
