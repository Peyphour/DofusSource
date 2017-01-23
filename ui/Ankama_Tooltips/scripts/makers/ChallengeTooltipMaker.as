package makers
{
   import blocks.ChallengeTooltipBlock;
   import blocks.DescriptionTooltipBlock;
   import blocks.TextTooltipBlock;
   import d2enums.ProtocolConstantsEnum;
   
   public class ChallengeTooltipMaker
   {
       
      
      private var _param:paramClass#117;
      
      public function ChallengeTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc3_:Object = Api.ui;
         this._param = new paramClass#117();
         if(param2)
         {
            if(param2.hasOwnProperty("name"))
            {
               this._param.name = param2.name;
            }
            if(param2.hasOwnProperty("description"))
            {
               this._param.description = param2.description;
            }
            if(param2.hasOwnProperty("effects"))
            {
               this._param.effects = param2.effects;
            }
         }
         var _loc4_:Object = Api.tooltip.createTooltip("chunks/base/baseWithBackground.txt","chunks/base/container.txt","chunks/base/separator.txt");
         if(this._param.name)
         {
            _loc4_.addBlock(new TextTooltipBlock(param1.name,{
               "content":param1.name,
               "css":"[local.css]tooltip_title.css",
               "cssClass":"spell"
            }).block);
         }
         if(this._param.description)
         {
            _loc5_ = param1.targetName + " (";
            if(param1.targetId > 0 && param1.targetLevel > ProtocolConstantsEnum.MAX_LEVEL)
            {
               _loc5_ = _loc5_ + (_loc3_.getText("ui.common.short.prestige") + (param1.targetLevel - ProtocolConstantsEnum.MAX_LEVEL) + ")");
            }
            else
            {
               _loc5_ = _loc5_ + (_loc3_.getText("ui.common.short.level") + param1.targetLevel + ")");
            }
            _loc6_ = param1.description;
            _loc6_ = _loc6_.replace("%1",_loc5_);
            _loc4_.addBlock(new DescriptionTooltipBlock(_loc6_).block);
         }
         if(this._param.effects)
         {
            _loc4_.addBlock(new ChallengeTooltipBlock(param1).block);
         }
         return _loc4_;
      }
   }
}

class paramClass#117
{
    
   
   public var name:Boolean = true;
   
   public var description:Boolean = true;
   
   public var effects:Boolean = true;
   
   function paramClass#117()
   {
      super();
   }
}
