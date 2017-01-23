package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   
   public class JobDescription
   {
       
      
      public function JobDescription()
      {
         super();
      }
      
      public function get jobId() : uint
      {
         return new uint();
      }
      
      public function get skills() : Vector.<SkillActionDescription>
      {
         return new Vector.<SkillActionDescription>();
      }
   }
}
