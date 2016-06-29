local MelfGS = {}

function MelfGS:new( name, gearSet )
   local GS = {}
   setmetatable( GS, self )
   self.__index = self;

   GS.index = 1
   GS.name = name
   GS.sets = { { "Base", gearSet } }
   GS.current = GS.sets[1]
   GS.previous = nil
   GS.rules = {}
   return GS;
end

function MelfGS:addMode( name, modeSet )
   if( not name or type( name ) ~= "string" ) then
      error( "A toggle wasn't installed because it gave no name", 3 )
	  return 0;
   elseif( not modeSet or type( modeSet ) ~= "table" ) then
      error( "A toggle wasn't installed because no set was given", 3 )
	  return 0;
   end
 
   self.sets[#self.sets + 1] = { name, set_combine( self.sets[1][2], modeSet ) }
   return #self.sets
end

function MelfGS:addRule( rule )
   if( type(rule) ~= "function" ) then
      error( "Tried to add a rule that was not a function.", 3 )
   end
   self.rules[#self.rules + 1] = rule
end

function MelfGS:up()
   self.previous = self.current
   self.index = self.index + 1
   
   if( self.sets[self.index] == nil ) then
      self.index = 1
   end
  
   self.current = self.sets[self.index]
   add_to_chat( self.name .. ": " .. self.current[1] )
end

function MelfGS:down()
   self.previous = self.current
   self.index = self.index - 1
   
   if( self.sets[self.index] == nil ) then
      self.index = #self.sets
   end
  
   self.current = self.sets[self.index]
   add_to_chat( self.name .. ": " ..  self.current[1])
end

function MelfGS:set( newIndex )
   if( not self.sets[newIndex] ) then
      add_to_chat( "That index is outside of the range." )
      return;
   end
   
   self.previous = self.current
   self.index = newIndex
   self.current = self.sets[self.index]
   
   add_to_chat( self.name .. ": " .. self.current[1] )
end

function MelfGS:equip( spell )
   if( #self.rules == 0 ) then
      equip( self.current[2] )
   else
      local ruleSet = set_combine( self.current[2] )
      for _, f in pairs( self.rules ) do ruleSet = f( spell, ruleSet ) or ruleSet; end
      equip( ruleSet )
   end
end

return MelfGS;
