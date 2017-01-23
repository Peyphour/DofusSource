package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.ScrollContainer;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicNamedAllianceInformations;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.LeaveDialogRequest;
   import d2actions.NpcDialogReply;
   import d2hooks.AlliancePrismDialogQuestion;
   import d2hooks.AllianceTaxCollectorDialogQuestionExtended;
   import d2hooks.LeaveDialog;
   import d2hooks.NpcDialogQuestion;
   import d2hooks.NpcDialogRepliesVisible;
   import d2hooks.PortalDialogQuestion;
   import d2hooks.TaxCollectorDialogQuestionBasic;
   import d2hooks.TaxCollectorDialogQuestionExtended;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   
   public class NpcDialog
   {
      
      private static const ENTITY_FILTER:GlowFilter = new GlowFilter(0,0.4,8,8,2,BitmapFilterQuality.HIGH);
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      public var soundApi:SoundApi;
      
      public var socialApi:SocialApi;
      
      public var timeApi:TimeApi;
      
      private var _npc:Object;
      
      private var _replies:Object;
      
      private var _moreReplies:Object;
      
      private var _nIndexRep:uint = 0;
      
      private var _currentMsg:uint;
      
      private var _labelsWidth:uint = 250;
      
      private var _aLblReplies:Array;
      
      private var _aReplies:Array;
      
      private var _aRepliesIdFromBtn:Array;
      
      private var _lockAndWaitAnswers:Boolean = false;
      
      private var _comeBackNeeded:Boolean = false;
      
      private var _continueNeeded:Boolean = false;
      
      private var _textParams:Array;
      
      private var _colorOver:Object;
      
      private var _currentSelectedAnswer:int = -1;
      
      private var _lastAnswerIndex:int = -1;
      
      private var _contentHeight:int;
      
      public var mainNpcCtr:GraphicContainer;
      
      public var repliesContainer:GraphicContainer;
      
      public var ctr_content:ScrollContainer;
      
      public var entityDisplayer_npc:EntityDisplayer;
      
      public var tx_background:Texture;
      
      public var tx_mask:Texture;
      
      public var tx_deco:Texture;
      
      public var tx_highlight_top:Texture;
      
      public var tx_highlight_bottom:Texture;
      
      public var btn_close:Texture;
      
      public var lbl_title:Label;
      
      public var lbl_message:Label;
      
      public var lbl_hidden:Label;
      
      public var btn_rep0:ButtonContainer;
      
      public var btn_rep1:ButtonContainer;
      
      public var btn_rep2:ButtonContainer;
      
      public var btn_rep3:ButtonContainer;
      
      public var btn_rep4:ButtonContainer;
      
      public var lbl_rep0:Label;
      
      public var lbl_rep1:Label;
      
      public var lbl_rep2:Label;
      
      public var lbl_rep3:Label;
      
      public var lbl_rep4:Label;
      
      public var tx_over0:Texture;
      
      public var tx_over1:Texture;
      
      public var tx_over2:Texture;
      
      public var tx_over3:Texture;
      
      public var tx_over4:Texture;
      
      public function NpcDialog()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.tx_background.addContent(this.tx_mask);
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.sysApi.addHook(LeaveDialog,this.onLeaveDialog);
         this.sysApi.addHook(NpcDialogQuestion,this.onNpcDialogQuestion);
         this.sysApi.addHook(TaxCollectorDialogQuestionExtended,this.onTaxCollectorDialogQuestionExtended);
         this.sysApi.addHook(AllianceTaxCollectorDialogQuestionExtended,this.onAllianceTaxCollectorDialogQuestionExtended);
         this.sysApi.addHook(TaxCollectorDialogQuestionBasic,this.onTaxCollectorDialogQuestionBasic);
         this.sysApi.addHook(AlliancePrismDialogQuestion,this.onAlliancePrismDialogQuestion);
         this.sysApi.addHook(PortalDialogQuestion,this.onPortalDialogQuestion);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("upArrow",this.onShortcut);
         this.uiApi.addShortcutHook("downArrow",this.onShortcut);
         this.uiApi.addComponentHook(this.btn_rep0,"onRollOver");
         this.uiApi.addComponentHook(this.btn_rep0,"onRollOut");
         this.uiApi.addComponentHook(this.btn_rep1,"onRollOver");
         this.uiApi.addComponentHook(this.btn_rep1,"onRollOut");
         this.uiApi.addComponentHook(this.btn_rep2,"onRollOver");
         this.uiApi.addComponentHook(this.btn_rep2,"onRollOut");
         this.uiApi.addComponentHook(this.btn_rep3,"onRollOver");
         this.uiApi.addComponentHook(this.btn_rep3,"onRollOut");
         this.uiApi.addComponentHook(this.btn_rep4,"onRollOver");
         this.uiApi.addComponentHook(this.btn_rep4,"onRollOut");
         this.uiApi.addComponentHook(this.btn_rep0,"onRelease");
         this.uiApi.addComponentHook(this.btn_rep1,"onRelease");
         this.uiApi.addComponentHook(this.btn_rep2,"onRelease");
         this.uiApi.addComponentHook(this.btn_rep3,"onRelease");
         this.uiApi.addComponentHook(this.btn_rep4,"onRelease");
         this.uiApi.addComponentHook(this.entityDisplayer_npc,"onEntityReady");
         this._colorOver = this.uiApi.getColor(this.sysApi.getConfigEntry("colors.combobox.over"));
         this.entityDisplayer_npc.setAnimationAndDirection("AnimStatique",1);
         this.entityDisplayer_npc.look = param1[1];
         this.ctr_content.verticalScrollSpeed = 4;
         this._npc = this.dataApi.getNpc(param1[0]);
         this._textParams = [];
         if(this.playerApi.getPlayedCharacterInfo().sex == 0)
         {
            this._textParams["m"] = true;
            this._textParams["f"] = false;
         }
         else
         {
            this._textParams["m"] = false;
            this._textParams["f"] = true;
         }
         if(this._npc.gender == 0)
         {
            this._textParams["n"] = true;
            this._textParams["g"] = false;
         }
         else
         {
            this._textParams["n"] = false;
            this._textParams["g"] = true;
         }
         if(param1[0] == 1)
         {
            this.lbl_title.text = this.dataApi.getTaxCollectorFirstname(param1[2]).firstname + " " + this.dataApi.getTaxCollectorName(param1[3]).name;
         }
         else if(param1[0] == 2141)
         {
            this.lbl_title.text = this.uiApi.getText("ui.zaap.prism");
         }
         else
         {
            this.lbl_title.text = this._npc.name;
            this.lbl_hidden.visible = false;
            this._aLblReplies = new Array();
            this._aLblReplies[0] = this.lbl_rep0;
            this._aLblReplies[1] = this.lbl_rep1;
            this._aLblReplies[2] = this.lbl_rep2;
            this._aLblReplies[3] = this.lbl_rep3;
            this._aLblReplies[4] = this.lbl_rep4;
            this._aReplies = new Array();
            this._aReplies[0] = this.btn_rep0;
            this._aReplies[1] = this.btn_rep1;
            this._aReplies[2] = this.btn_rep2;
            this._aReplies[3] = this.btn_rep3;
            this._aReplies[4] = this.btn_rep4;
            this._aRepliesIdFromBtn = new Array();
            if(Roleplay.questions.length > 0)
            {
               this.onNpcDialogQuestion(Roleplay.questions[0].messageId,Roleplay.questions[0].dialogParams,Roleplay.questions[0].visibleReplies);
            }
         }
      }
      
      public function unload() : void
      {
         this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
         this.sysApi.enableWorldInteraction();
      }
      
      private function displayReplies(param1:Object, param2:Boolean = false) : void
      {
         var _loc5_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:ButtonContainer = null;
         var _loc13_:Object = null;
         var _loc14_:Rectangle = null;
         var _loc15_:int = 0;
         var _loc16_:* = undefined;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc3_:int = 400;
         var _loc4_:int = 0;
         this._continueNeeded = param2;
         this._contentHeight = this.lbl_message.height + 10;
         this.lbl_hidden.text = "";
         for(_loc5_ in this._aLblReplies)
         {
            this._aReplies[_loc5_].y = 0;
            this._aLblReplies[_loc5_].text = "";
            this._aRepliesIdFromBtn[_loc5_] = 0;
            this["tx_over" + _loc5_].height = 10;
            this["tx_over" + _loc5_].y = 0;
         }
         if(param1.length == 0)
         {
            this._aLblReplies[0].text = this.uiApi.getText("ui.npc.closeDialog");
            _loc4_ = _loc4_ + (this._aLblReplies[0].height + 5);
            this._aRepliesIdFromBtn[0] = -1;
         }
         var _loc6_:uint = 0;
         for each(_loc7_ in param1)
         {
            for each(_loc16_ in this._npc.dialogReplies)
            {
               _loc17_ = _loc16_[0];
               _loc18_ = _loc16_[1];
               if(_loc17_ == _loc7_)
               {
                  this.lbl_hidden.text = this.uiApi.decodeText(this.uiApi.getTextFromKey(_loc18_),this._textParams);
                  if(_loc6_ != 0)
                  {
                     this._aReplies[_loc6_].state = 0;
                     _loc19_ = this._aReplies[_loc6_ - 1].y + this._aReplies[_loc6_ - 1].height;
                     this._aReplies[_loc6_].y = _loc19_;
                  }
                  if(_loc4_ + this.lbl_hidden.height + 5 > _loc3_)
                  {
                     param2 = true;
                     _loc6_++;
                     break;
                  }
                  this._aLblReplies[_loc6_].text = this.lbl_hidden.text;
                  _loc4_ = _loc4_ + (this._aLblReplies[_loc6_].height + 5);
                  this._aRepliesIdFromBtn[_loc6_] = _loc17_;
               }
            }
            _loc6_++;
         }
         if(param2)
         {
            this._aReplies[_loc6_].state = 0;
            this._aLblReplies[_loc6_].text = this.uiApi.getText("ui.npc.showMore");
            this._aReplies[_loc6_].y = this._aReplies[_loc6_ - 1].y + this._aReplies[_loc6_ - 1].height;
            this._aReplies[_loc6_].reset();
         }
         else if(this._comeBackNeeded)
         {
            this._aReplies[_loc6_].state = 0;
            this._aLblReplies[_loc6_].text = this.uiApi.getText("ui.common.restart");
            this._aReplies[_loc6_].y = this._aReplies[_loc6_ - 1].y + this._aReplies[_loc6_ - 1].height;
            this._aReplies[_loc6_].reset();
         }
         this._lastAnswerIndex = -1;
         this._currentSelectedAnswer = -1;
         for(_loc8_ in this._aLblReplies)
         {
            this.unselectAnswer(int(_loc8_));
            if(this._aLblReplies[_loc8_].text == "")
            {
               this._aReplies[_loc8_].state = 0;
               this._aReplies[_loc8_].visible = false;
               this._aReplies[_loc8_].reset();
            }
            else
            {
               this._lastAnswerIndex = int(_loc8_);
               this._aReplies[_loc8_].visible = true;
               this._contentHeight = this._contentHeight + ((this._aLblReplies[_loc8_] as Label).contentHeight + 5);
            }
         }
         this.refreshBackground();
         _loc10_ = this.uiApi.getMouseX();
         _loc11_ = this.uiApi.getMouseY();
         _loc15_ = param1.length;
         _loc9_ = 0;
         while(_loc9_ < _loc15_)
         {
            _loc12_ = this["btn_rep" + _loc9_];
            _loc13_ = _loc12_.getStageRect();
            _loc14_ = new Rectangle(_loc13_.x,_loc13_.y,_loc13_.width,_loc13_.height);
            if(_loc14_.contains(_loc10_,_loc11_))
            {
               this.selectAnswer(_loc9_);
               break;
            }
            _loc9_++;
         }
         this.sysApi.dispatchHook(NpcDialogRepliesVisible,true);
      }
      
      private function showMore() : void
      {
         if(this._continueNeeded)
         {
            this._comeBackNeeded = true;
            if(this._moreReplies.length > 4)
            {
               this.displayReplies(this._moreReplies.slice(0,4),true);
               this._moreReplies = this._moreReplies.slice(4);
            }
            else
            {
               this.displayReplies(this._moreReplies);
            }
         }
         else if(this._comeBackNeeded)
         {
            this._comeBackNeeded = false;
            this.displayReplies(this._replies.slice(0,4),true);
            this._moreReplies = this._replies.slice(4);
         }
      }
      
      private function selectAnswer(param1:int) : void
      {
         if(!this._aReplies || this._aReplies.length == 0)
         {
            return;
         }
         this["tx_over" + param1].x = this._aReplies[param1].x;
         this["tx_over" + param1].y = this._aReplies[param1].y;
         this["tx_over" + param1].width = this._aReplies[param1].width;
         this["tx_over" + param1].height = this._aReplies[param1].height;
         this["tx_over" + param1].bgColor = this._colorOver.color;
         this["tx_over" + param1].bgAlpha = !!this._colorOver.hasOwnProperty("alpha")?this._colorOver.alpha:1;
         this._currentSelectedAnswer = param1;
      }
      
      private function unselectAnswer(param1:int) : void
      {
         this["tx_over" + param1].bgColor = -1;
      }
      
      private function refreshBackground() : void
      {
         this.tx_mask.y = this.uiApi.getStageHeight() - 200 - (this.ctr_content.height + 95);
         this.tx_background.mask = this.tx_mask;
         this.mainNpcCtr.x = this.uiApi.getStartWidth() / 2 - this.mainNpcCtr.width / 2;
         this.mainNpcCtr.y = this.uiApi.getStartHeight() - 200 - this.tx_background.height;
         this.tx_highlight_top.y = this.tx_mask.y - this.tx_highlight_top.height + 17;
         this.tx_highlight_bottom.y = this.uiApi.getStageHeight() - 200 + this.tx_highlight_bottom.height - 4;
         this.btn_close.y = this.tx_deco.y = this.tx_mask.y + 15;
         this.lbl_title.y = this.tx_mask.y + 22;
         this.ctr_content.y = this.tx_mask.y + 66;
         if(!this.mainNpcCtr.visible)
         {
            this.sysApi.addEventListener(this.onEnterFrame,"refreshBackground");
         }
      }
      
      private function onEnterFrame() : void
      {
         this.tx_background.visible = true;
         this.mainNpcCtr.visible = true;
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function onEntityReady(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1 == this.entityDisplayer_npc)
         {
            this.entityDisplayer_npc.fixedWidth = 270;
            if(this.entityDisplayer_npc.getEntityBounds().height > 500)
            {
               this.entityDisplayer_npc.fixedHeight = 500;
            }
            this.entityDisplayer_npc.filters = [ENTITY_FILTER];
            _loc2_ = this.entityDisplayer_npc.getEntityBounds();
            this.entityDisplayer_npc.x = this.entityDisplayer_npc.x - (_loc2_.x - 20 - (270 / 2 - _loc2_.width / 2));
            this.entityDisplayer_npc.y = this.entityDisplayer_npc.y - (_loc2_.y + (_loc2_.height - this.tx_background.height));
            this.entityDisplayer_npc.visible = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         if(this._lockAndWaitAnswers)
         {
            return;
         }
         switch(param1)
         {
            case this.btn_close:
               this.sysApi.sendAction(new LeaveDialogRequest());
               break;
            case this.btn_rep0:
               if(this._aRepliesIdFromBtn[0])
               {
                  if(this._aRepliesIdFromBtn[0] >= 0)
                  {
                     this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[0]));
                     this._lockAndWaitAnswers = true;
                  }
                  else
                  {
                     this.sysApi.sendAction(new LeaveDialogRequest());
                  }
                  this._comeBackNeeded = false;
               }
               else
               {
                  this.showMore();
               }
               break;
            case this.btn_rep1:
               if(this._aRepliesIdFromBtn[1])
               {
                  this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[1]));
                  this._lockAndWaitAnswers = true;
                  this._comeBackNeeded = false;
               }
               else
               {
                  this.showMore();
               }
               break;
            case this.btn_rep2:
               if(this._aRepliesIdFromBtn[2])
               {
                  this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[2]));
                  this._lockAndWaitAnswers = true;
                  this._comeBackNeeded = false;
               }
               else
               {
                  this.showMore();
               }
               break;
            case this.btn_rep3:
               if(this._aRepliesIdFromBtn[3])
               {
                  this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[3]));
                  this._lockAndWaitAnswers = true;
                  this._comeBackNeeded = false;
               }
               else
               {
                  this.showMore();
               }
               break;
            case this.btn_rep4:
               if(this._aRepliesIdFromBtn[4])
               {
                  this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[4]));
                  this._lockAndWaitAnswers = true;
                  this._comeBackNeeded = false;
               }
               else
               {
                  this.showMore();
               }
         }
         this.onRollOut(param1);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1)
         {
            case "validUi":
               if(this._currentSelectedAnswer == 0)
               {
                  if(this._aRepliesIdFromBtn[0])
                  {
                     if(this._aRepliesIdFromBtn[0] >= 0)
                     {
                        this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[0]));
                        this._lockAndWaitAnswers = true;
                     }
                     else
                     {
                        this.sysApi.sendAction(new LeaveDialogRequest());
                     }
                     this._comeBackNeeded = false;
                  }
                  else
                  {
                     this.showMore();
                  }
               }
               else if(this._currentSelectedAnswer > 0)
               {
                  if(this._aRepliesIdFromBtn[this._currentSelectedAnswer])
                  {
                     this.sysApi.sendAction(new NpcDialogReply(this._aRepliesIdFromBtn[this._currentSelectedAnswer]));
                     this._lockAndWaitAnswers = true;
                     this._comeBackNeeded = false;
                  }
                  else
                  {
                     this.showMore();
                  }
               }
               return true;
            case "closeUi":
               this.sysApi.sendAction(new LeaveDialogRequest());
               return true;
            case "upArrow":
               if(this._lastAnswerIndex == -1)
               {
                  return false;
               }
               if(this._currentSelectedAnswer == -1)
               {
                  this.selectAnswer(this._lastAnswerIndex);
               }
               else
               {
                  this.unselectAnswer(this._currentSelectedAnswer);
                  _loc2_ = this._currentSelectedAnswer - 1;
                  if(_loc2_ < 0)
                  {
                     _loc2_ = this._lastAnswerIndex;
                  }
                  this.selectAnswer(_loc2_);
               }
               return true;
            case "downArrow":
               if(this._lastAnswerIndex == -1)
               {
                  return false;
               }
               if(this._currentSelectedAnswer == -1)
               {
                  this.selectAnswer(0);
               }
               else
               {
                  this.unselectAnswer(this._currentSelectedAnswer);
                  _loc3_ = this._currentSelectedAnswer + 1;
                  if(_loc3_ > this._lastAnswerIndex)
                  {
                     _loc3_ = 0;
                  }
                  this.selectAnswer(_loc3_);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.name.indexOf("btn_rep") != -1)
         {
            _loc2_ = int(param1.name.substr(7,1));
            this.selectAnswer(_loc2_);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.name.indexOf("btn_rep") != -1)
         {
            _loc2_ = int(param1.name.substr(7,1));
            this.unselectAnswer(_loc2_);
         }
      }
      
      public function onNpcDialogQuestion(param1:uint = 0, param2:Object = null, param3:Object = null) : void
      {
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:* = undefined;
         this._replies = new Array();
         this._moreReplies = new Array();
         this._lockAndWaitAnswers = false;
         var _loc4_:Array = new Array();
         for each(_loc5_ in param2)
         {
            _loc4_.push(_loc5_);
         }
         this._currentMsg = param1;
         for each(_loc6_ in this._aLblReplies)
         {
            _loc6_.text = "";
         }
         for each(_loc7_ in this._npc.dialogMessages)
         {
            _loc8_ = _loc7_[0];
            _loc9_ = _loc7_[1];
            if(_loc8_ == param1)
            {
               _loc10_ = this.uiApi.decodeText(this.utilApi.getTextWithParams(_loc9_,_loc4_,"#"),this._textParams);
               this.lbl_message.text = _loc10_;
               for each(_loc11_ in param3)
               {
                  this._replies.push(_loc11_);
               }
               this.repliesContainer.x = this.lbl_message.x + 20;
               this.repliesContainer.y = this.lbl_message.y + 15 + this.lbl_message.height;
               if(this._replies.length > 5)
               {
                  this.displayReplies(this._replies.slice(0,4),true);
                  this._moreReplies = this._replies.slice(4);
               }
               else
               {
                  this.displayReplies(this._replies);
               }
            }
         }
         this.ctr_content.height = this._contentHeight;
         if(this.ctr_content.height > 550)
         {
            this.ctr_content.height = 550;
         }
         this.ctr_content.finalize();
         this.refreshBackground();
      }
      
      public function onTaxCollectorDialogQuestionExtended(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:int, param7:int, param8:int, param9:int, param10:int) : void
      {
         this.onAllianceTaxCollectorDialogQuestionExtended(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function onAllianceTaxCollectorDialogQuestionExtended(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:int, param7:int, param8:int, param9:int, param10:int, param11:BasicNamedAllianceInformations = null) : void
      {
         var _loc12_:* = undefined;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:String = null;
         if(this.sysApi.getCurrentServer().gameTypeId == 1)
         {
            if(param9 == 0)
            {
               if(param11)
               {
                  this._currentMsg = 18063;
               }
               else
               {
                  this._currentMsg = 18064;
               }
            }
            else if(param11)
            {
               this._currentMsg = 18065;
            }
            else
            {
               this._currentMsg = 18066;
            }
         }
         else if(param11)
         {
            this._currentMsg = 15427;
         }
         else
         {
            this._currentMsg = 1;
         }
         for each(_loc12_ in this._npc.dialogMessages)
         {
            _loc13_ = _loc12_[0];
            _loc14_ = _loc12_[1];
            if(_loc13_ == this._currentMsg)
            {
               if(this._currentMsg == 15427 || this._currentMsg == 18063 || this._currentMsg == 18065)
               {
                  _loc15_ = param11.allianceName;
                  if(_loc15_ == "#NONAME#")
                  {
                     _loc15_ = this.uiApi.getText("ui.guild.noName");
                  }
                  _loc16_ = param11.allianceTag;
                  if(_loc16_ == "#TAG#")
                  {
                     _loc16_ = this.uiApi.getText("ui.alliance.noTag");
                  }
                  if(this._currentMsg == 15427)
                  {
                     this.lbl_message.text = this.uiApi.getTextFromKey(_loc14_,"#",param1,param2,param3,param4,param5,this.utilApi.kamasToString(param7,""),this.utilApi.kamasToString(param8,""),this.utilApi.kamasToString(param9,""),this.utilApi.kamasToString(param10,""),_loc15_,"[" + _loc16_ + "]");
                  }
                  else if(this._currentMsg == 18065)
                  {
                     this.lbl_message.text = this.uiApi.getTextFromKey(_loc14_,"#",param1,param2,param3,param4,param5,this.utilApi.kamasToString(param9,""),this.utilApi.kamasToString(param10,""),_loc15_,"[" + _loc16_ + "]");
                  }
                  else if(this._currentMsg == 18063)
                  {
                     this.lbl_message.text = this.uiApi.getTextFromKey(_loc14_,"#",param1,param2,param3,param4,param5,_loc15_,"[" + _loc16_ + "]");
                  }
               }
               else if(this._currentMsg == 1)
               {
                  this.lbl_message.text = this.uiApi.getTextFromKey(_loc14_,"#",param1,param2,param3,param4,param5,this.utilApi.kamasToString(param7,""),this.utilApi.kamasToString(param8,""),this.utilApi.kamasToString(param9,""),this.utilApi.kamasToString(param10,""));
               }
               else if(this._currentMsg == 18066)
               {
                  this.lbl_message.text = this.uiApi.getTextFromKey(_loc14_,"#",param1,param2,param3,param4,param5,this.utilApi.kamasToString(param9,""),this.utilApi.kamasToString(param10,""));
               }
               else if(this._currentMsg == 18064)
               {
                  this.lbl_message.text = this.uiApi.getTextFromKey(_loc14_,"#",param1,param2,param3,param4,param5);
               }
               if(param6 > 0)
               {
                  this.lbl_message.text = this.lbl_message.text + ("\n\n" + this.uiApi.processText(this.uiApi.getText("ui.social.taxCollectorWaitBeforeAttack",param6),"m",param6 <= 1));
               }
               else if(param6 < 0)
               {
                  this.lbl_message.text = this.lbl_message.text + ("\n\n" + this.uiApi.getText("ui.social.taxCollectorNoAttack"));
               }
            }
         }
         this._contentHeight = this.lbl_message.height + 10;
         this.ctr_content.height = this._contentHeight;
         if(this.ctr_content.height > 550)
         {
            this.ctr_content.height = 550;
            this.ctr_content.finalize();
         }
         this.refreshBackground();
      }
      
      public function onTaxCollectorDialogQuestionBasic(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._currentMsg = 2;
         for each(_loc2_ in this._npc.dialogMessages)
         {
            _loc3_ = _loc2_[0];
            _loc4_ = _loc2_[1];
            if(_loc3_ == this._currentMsg)
            {
               this.lbl_message.text = this.uiApi.getTextFromKey(_loc4_,"#",param1);
            }
         }
         this._contentHeight = this.lbl_message.height + 10;
         this.ctr_content.height = this._contentHeight;
         if(this.ctr_content.height > 550)
         {
            this.ctr_content.height = 550;
            this.ctr_content.finalize();
         }
         this.refreshBackground();
      }
      
      public function onAlliancePrismDialogQuestion() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         this._currentMsg = 15428;
         var _loc1_:int = this.playerApi.currentSubArea().id;
         var _loc2_:PrismSubAreaWrapper = this.socialApi.getPrismSubAreaById(_loc1_);
         var _loc3_:AllianceWrapper = _loc2_.alliance;
         if(!_loc3_)
         {
            _loc3_ = this.socialApi.getAlliance();
         }
         for each(_loc4_ in this._npc.dialogMessages)
         {
            _loc5_ = _loc4_[0];
            _loc6_ = _loc4_[1];
            if(_loc5_ == this._currentMsg)
            {
               _loc7_ = this.timeApi.getDate(_loc2_.nextVulnerabilityDate * 1000) + " " + this.timeApi.getClock(_loc2_.nextVulnerabilityDate * 1000);
               this.lbl_message.text = this.uiApi.getTextFromKey(_loc6_,"#",_loc3_.allianceName,this.uiApi.getText("ui.prism.state" + _loc2_.state),_loc7_,this.utilApi.kamasToString(_loc2_.rewardTokenCount,""));
            }
         }
         this._contentHeight = this.lbl_message.height + 10;
         this.ctr_content.height = this._contentHeight;
         if(this.ctr_content.height > 550)
         {
            this.ctr_content.height = 550;
            this.ctr_content.finalize();
         }
         this.refreshBackground();
      }
      
      public function onPortalDialogQuestion(param1:int, param2:Number) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         for each(_loc3_ in this._npc.dialogMessages)
         {
            _loc4_ = _loc3_[0];
            _loc5_ = _loc3_[1];
            _loc6_ = this.timeApi.getDuration(param2);
            this.lbl_message.text = this.uiApi.getTextFromKey(_loc5_,"#",param1,_loc6_);
         }
         this._contentHeight = this.lbl_message.height + 10;
         this.ctr_content.height = this._contentHeight;
         if(this.ctr_content.height > 550)
         {
            this.ctr_content.height = 550;
            this.ctr_content.finalize();
         }
         this.refreshBackground();
      }
      
      private function onLeaveDialog() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
