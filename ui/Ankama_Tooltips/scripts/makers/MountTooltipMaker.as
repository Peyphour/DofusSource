package makers
{
   import blocks.EffectsTooltipBlock;
   import blocks.TextTooltipBlock;
   import blocks.mount.MountSeparatorTooltipBlock;
   import blocks.mount.MountTooltipBlock;
   
   public class MountTooltipMaker
   {
      
      public static var lastUiName:String;
       
      
      public function MountTooltipMaker()
      {
         super();
      }
      
      public function createTooltip(param1:*, param2:Object) : Object
      {
         var _loc4_:String = null;
         var _loc11_:int = 0;
         var _loc3_:Object = Api.ui;
         if(param2.noBg)
         {
            _loc4_ = "chunks/base/base.txt";
         }
         else
         {
            _loc4_ = "chunks/base/baseWithBackground.txt";
         }
         var _loc5_:Object = Api.tooltip.createTooltip(_loc4_,"chunks/base/container.txt","chunks/base/empty.txt");
         var _loc6_:Object = new Object();
         var _loc7_:Object = param2.mount;
         _loc6_.mountName = _loc7_.name;
         _loc6_.mountType = _loc7_.description;
         _loc6_.mountLevel = _loc7_.level;
         lastUiName = param2.uiName;
         if(param2.noBg)
         {
            _loc6_.mountCssName = "[local.css]titleSmall.css";
         }
         else
         {
            _loc6_.mountCssName = "[local..css]tooltip_title.css";
         }
         if(_loc7_.sex)
         {
            _loc6_.mountSex = _loc3_.getText("ui.common.animalFemale");
         }
         else
         {
            _loc6_.mountSex = _loc3_.getText("ui.common.animalMale");
         }
         if(_loc7_.isRideable)
         {
            _loc6_.mountRideable = _loc3_.getText("ui.common.yes");
         }
         else
         {
            _loc6_.mountRideable = _loc3_.getText("ui.common.no");
         }
         if(_loc7_.isWild)
         {
            _loc6_.mountWild = _loc3_.getText("ui.common.yes");
         }
         else
         {
            _loc6_.mountWild = _loc3_.getText("ui.common.no");
         }
         _loc6_.mountES = _loc7_.energy + "/" + _loc7_.energyMax;
         _loc6_.mountEPBS = int(_loc7_.energy / _loc7_.energyMax * 112);
         _loc6_.mountXPS = _loc7_.experience + "/" + _loc7_.experienceForNextLevel;
         _loc6_.mountXPPBS = int((_loc7_.experience - _loc7_.experienceForLevel) / (_loc7_.experienceForNextLevel - _loc7_.experienceForLevel) * 112);
         _loc6_.mountTS = _loc7_.boostLimiter + "/" + _loc7_.boostMax;
         _loc6_.mountTPBS = int(_loc7_.boostLimiter / _loc7_.boostMax * 112);
         if(_loc7_.reproductionCount == -1)
         {
            _loc6_.mountRS = _loc3_.getText("ui.mount.castrated");
            _loc6_.mountRCSS = "[local.css]normal.css";
            _loc6_.mountReproductionVisible = "false";
         }
         else
         {
            _loc6_.mountRCSS = "[local.css]normal.css";
            _loc6_.mountReproductionVisible = "true";
            _loc6_.mountRPBS = int(_loc7_.reproductionCount / _loc7_.reproductionCountMax * 112);
            if(_loc7_.fecondationTime > 0)
            {
               _loc6_.mountRS = _loc3_.getText("ui.mount.fecondee");
            }
            else
            {
               _loc6_.mountRS = _loc7_.reproductionCount + "/" + _loc7_.reproductionCountMax;
            }
         }
         if(param2.noBg)
         {
            _loc6_.mountSizeGXP = 81;
         }
         else
         {
            _loc6_.mountSizeGXP = 100;
         }
         _loc6_.mountGXP = _loc7_.xpRatio + "%";
         _loc6_.mountAS = _loc7_.love + "/" + _loc7_.loveMax;
         _loc6_.mountAPBS = int(_loc7_.love / _loc7_.loveMax * 112);
         _loc6_.mountMS = _loc7_.maturity + "/" + _loc7_.maturityForAdult;
         _loc6_.mountMPBS = int(_loc7_.maturity / _loc7_.maturityForAdult * 112);
         _loc6_.mountSS = _loc7_.stamina + "/" + _loc7_.staminaMax;
         _loc6_.mountSPBS = int(_loc7_.stamina / _loc7_.staminaMax * 112);
         var _loc8_:int = _loc7_.aggressivityMax;
         _loc6_.mountSerenityPB = int((_loc7_.serenity - _loc8_) / (_loc7_.serenityMax - _loc8_) * 112);
         _loc5_.addBlock(new MountTooltipBlock(_loc6_).block);
         _loc5_.addBlock(new TextTooltipBlock(_loc3_.processText(_loc3_.getText("ui.common.capacity"),"n",false) + _loc3_.getText("ui.common.colon"),{
            "css":"[local.css]normal.css",
            "nameless":true
         }).block);
         var _loc9_:int = _loc7_.ability.length;
         if(_loc9_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc9_)
            {
               _loc5_.addBlock(new TextTooltipBlock("\t• " + _loc7_.ability[_loc11_].name,{
                  "css":"[local.css]normal.css",
                  "nameless":true
               }).block);
               _loc11_++;
            }
         }
         else
         {
            _loc5_.addBlock(new TextTooltipBlock("\t• " + _loc3_.processText(_loc3_.getText("ui.common.lowerNone"),"f",true),{
               "css":"[local.css]normal.css",
               "nameless":true
            }).block);
         }
         _loc5_.addBlock(new MountSeparatorTooltipBlock().block);
         var _loc10_:int = _loc7_.effectList.length;
         if(_loc10_)
         {
            _loc5_.addBlock(new EffectsTooltipBlock(_loc7_.effectList).block);
         }
         else
         {
            _loc5_.addBlock(new TextTooltipBlock(_loc3_.processText(_loc3_.getText("ui.common.effects"),"n",false) + _loc3_.getText("ui.common.colon"),{
               "css":"[local.css]normal.css",
               "nameless":true
            }).block);
            _loc5_.addBlock(new TextTooltipBlock("\t• " + _loc3_.processText(_loc3_.getText("ui.common.lowerNone"),"m",true),{
               "css":"[local.css]normal.css",
               "nameless":true
            }).block);
         }
         return _loc5_;
      }
   }
}
