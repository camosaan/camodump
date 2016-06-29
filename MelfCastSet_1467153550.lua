local MelfCS = {}

local AMII = {['Freeze II']=true,['Burst II']=true,['Quake II'] = true, ['Tornado II'] = true,['Flood II']=true,['Flare II']=true}

function MelfCS:new( name )
   local CS = {}
   setmetatable( CS, self )
   self.__index = self

   CS.name = name
   CS.collection = {}

   return CS
end

function MelfCS:addSet( MelfGS, ... )
   for _, name in pairs{...} do
      self.collection[name] = MelfGS
   end
end

function MelfCS:addSimpleWeaponCollection( MelfGS )
   self.collection["WeaponSkill"] = MelfGS
end

function MelfCS:equip( spell, arg )
   local mSet;

   if( arg ~= nil ) then
      mSet = self.collection[arg]
      if( mSet ~= nil ) then mSet:equip( spell ); return; end
   end

   if( not spell ) then return; end

   mSet = self.collection[spell.english]
   if( mSet ~= nil ) then mSet:equip( spell ); return; end
   
   mSet = self.collection[spell.type]
   if( mSet ~= nil ) then mSet:equip( spell ); return; end
   
   mSet = self.collection[spell.skill]
   if( mSet ~= nil ) then mSet:equip( spell ); return; end
   
   mSet = self.collection[self.name]
   if( mSet ~= nil ) then mSet:equip( spell ); return; end

end

function MelfCS.isAMII( spell )
   return AMII[spell.name]
end

return MelfCS
