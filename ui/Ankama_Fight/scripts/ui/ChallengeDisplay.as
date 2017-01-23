package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ChallengeTargetsListRequest;
   import d2hooks.ChallengeInfoUpdate;
   import d2hooks.FoldAll;
   
   public class ChallengeDisplay
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var ctr_challenges:GraphicContainer;
      
      public var btn_minimize:ButtonContainer;
      
      public var tx_background_grid:TextureBitmap;
      
      public var tx_button_minimize:Texture;
      
      private var _challenges:Array;
      
      private var _challengeIconOffset:int;
      
      private var _ctrChallengeHeightModifier:int;
      
      private var _ctrChallengeHeight:int;
      
      public function ChallengeDisplay()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         if(!param1)
         {
            param1 = {"challenges":[this.dataApi.getChallengeWrapper(1),this.dataApi.getChallengeWrapper(2)]};
         }
         this.sysApi.addHook(ChallengeInfoUpdate,this.onChallengeInfoUpdate);
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this._challengeIconOffset = this.uiApi.me().getConstant("challengeIconOffset");
         this._ctrChallengeHeightModifier = this.uiApi.me().getConstant("ctrChallengeHeightModifier");
         this._ctrChallengeHeight = this.uiApi.me().getConstant("ctrChallengeHeight");
         this._challenges = new Array();
         this.updateChallengeList(param1.challenges);
      }
      
      public function unload() : void
      {
      }
      
      private function updateChallengeList(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:uint = this._challengeIconOffset;
         var _loc3_:uint = 0;
         for each(_loc4_ in param1)
         {
            if(this._challenges.length <= _loc3_)
            {
               _loc5_ = new ChallengeEntry(this.uiApi.me(),this.ctr_challenges,_loc4_,3,_loc2_);
               this.uiApi.addComponentHook(_loc5_.btn_challenge,"onRelease");
               this.uiApi.addComponentHook(_loc5_.btn_challenge,"onRollOver");
               this.uiApi.addComponentHook(_loc5_.btn_challenge,"onRollOut");
               this._challenges.push(_loc5_);
            }
            else
            {
               this._challenges[_loc3_].data = _loc4_;
            }
            _loc2_ = _loc2_ + this._ctrChallengeHeightModifier;
            _loc3_++;
         }
         this.tx_background_grid.height = _loc2_ + this._ctrChallengeHeight;
      }
      
      private function _showChallengeList(param1:int = -1) : void
      {
         var _loc2_:* = false;
         if(param1 == 1)
         {
            _loc2_ = false;
         }
         else if(param1 == 0)
         {
            _loc2_ = true;
         }
         else
         {
            _loc2_ = !this.ctr_challenges.visible;
         }
         this.ctr_challenges.visible = _loc2_;
         if(this.ctr_challenges.visible)
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
         }
         else
         {
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
         }
      }
      
      private function getChallengeByButton(param1:Object) : ChallengeEntry
      {
         var _loc2_:ChallengeEntry = null;
         for each(_loc2_ in this._challenges)
         {
            if(_loc2_.btn_challenge == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:ChallengeEntry = null;
         switch(param1)
         {
            case this.btn_minimize:
               this._showChallengeList();
               break;
            default:
               _loc2_ = this.getChallengeByButton(param1);
               if(_loc2_)
               {
                  this.uiApi.hideTooltip();
                  this.sysApi.sendAction(new ChallengeTargetsListRequest(_loc2_.data.id));
               }
         }
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         if(param1)
         {
            this._showChallengeList(1);
         }
         else
         {
            this._showChallengeList(0);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:ChallengeEntry = this.getChallengeByButton(param1);
         if(_loc2_ && _loc2_.data)
         {
            this.uiApi.showTooltip(_loc2_.data,param1,false,"standard",0,2,3,null,null,null);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onChallengeInfoUpdate(param1:Object) : void
      {
         this.updateChallengeList(param1);
      }
   }
}
