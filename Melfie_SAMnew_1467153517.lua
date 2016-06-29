-- Melfie's Samurai GearSwap
local MelfGS = require( "MelfGS" )
local MelfManager = require( "MelfCastSet" )
local shmode = 0
local automode = true
local tankmode = false
-- I will use less comments in this so you can view the raw code, unless I use something new.
function get_sets()
   preCast = MelfManager:new( "Precast" )
   midCast = MelfManager:new( "Midcast" )
   afterCast = MelfManager:new( "Aftercast" )

   -------------------
   -- Precast Stuff --
   -------------------
   -- Mediate
   -- Weapon Skills
   -- Dummy: Seigan|ThirdEye|Hasso

   tankModeDummy = MelfGS:new( "TankMode", {} )
   tankModeDummy:addRule( function( spell, dSet ) 
      if tankmode then
         if( buffactive.seigan ) then
    	    send_command( "cancel 354" )
	     elseif( buffactive.hasso ) then
	        send_command( "cancel 353" )
		 end
	  end   
   end )
   preCast:addSet( tankModeDummy, "Utsusemi: Ni", "Utsusemi: Ichi" )
   
   meditateSet = MelfGS:new( "MedSet",
   {
      head="Myochin Kabuto",
      hands="Saotome Kote",
   } )

   preCast:addSet( meditateSet, "Meditate" )

   generalWS = MelfGS:new( "General Weaponskill", {
      main="Hagun",
      sub="Katana Strap",
      ammo="Tiphia Sting",
      head="Shura zunari kabuto",
      body="Hachiman domaru",
      hands="Alkyoneus's bracelets",
      legs="Shura haidate",
      feet="Rutter sabatons",
      neck={ name="Chivalrous Chain", augments={'"Dual Wield"+1','Ice resistance+5','STR+1 DEX+1',}},
      waist={ name="Potent Belt", augments={'STR+1 VIT+1','INT+1','Attack+4','STR+1 DEX-0.5 VIT-0.5',}},
      left_ear="Fowling Earring",
      right_ear="Bushinomimi",
      left_ring="Rajas Ring",
      right_ring="Victory Ring +1",
      back="Cerberus Mantle"
   } )
   preCast:addSet( generalWS, "WeaponSkill" )

   generalWS:addRule( function( spell, dSet )
      if( world.time >= 1020 or world.time <= 360 ) then
         return set_combine( dSet, { left_ear="Vampire Earring" } )
      end
   end )

   pentaWS = MelfGS:new( "Penta Weaponskill", {
      head="Shura zunari kabuto",
	  body="Kirin's Osode",
      hands="Alkyoneus's bracelets",
      legs="Shura haidate",
      feet="Rutter sabatons",
      neck={ name="Chivalrous Chain", augments={'"Dual Wield"+1','Ice resistance+5','STR+1 DEX+1',}},
      waist="Warwolf Belt",
      left_ear="Fowling Earring",
      right_ear="Bushinomimi",
      left_ring="Rajas Ring",
      right_ring="Victory Ring +1",
	  back="Cerberus mantle"
   } )
   
   preCast:addSet( pentaWS, "Penta Thrust" )
   
   kaitenWS = MelfGS:new( "Kaiten Weaponskill", {
       head={ name="Wyvern Helm", augments={'Wind resistance+1','"Counter"+1','Attack+5',}},
       body={ name="Byrnie +1", augments={'Accuracy+3','STR+1 DEX+1',}},
       hands="Alkyoneus's Brc.",
       legs="Shura Haidate",
       feet="Rutter Sabatons",
       neck={ name="Chivalrous Chain", augments={'Attack+5','Enmity+2',}},
       waist={ name="Potent Belt", augments={'STR+1 VIT+1','INT+1','Attack+4','STR+1 DEX-0.5 VIT-0.5',}},
       left_ear="Spike Earring",
       right_ear="Bushinomimi",
       left_ring="Rajas Ring",
       right_ring="Victory Ring +1",
       back="Amemet mantle +1",
   } )
   
   preCast:addSet( kaitenWS, "Tachi: Kaiten" )

   kaitenWS:addRule( function( spell, dSet )
      if( world.time >= 1020 or world.time <= 360 ) then
         return set_combine( dSet, { left_ear="Vampire Earring" } ) -- I don't want to use my nightEquip gearTable because it will override my bushi, want to leave bushi in for Kaiten
      end
   end )

   sidewinderWS = MelfGS:new( "SideWinder WeaponSkill", {
      head="Abtal Turban",
      body="Kirin's Osode",
      hands="Seiryu's Kote",
      legs="Abtal Zerehs",
      feet="Abtal boots",
      neck={ name="Chivalrous Chain", augments={'"Dual Wield"+1','Ice resistance+5','STR+1 DEX+1',}},
      waist={ name="Potent Belt", augments={'STR+1 VIT+1','INT+1','Attack+4','STR+1 DEX-0.5 VIT-0.5',}},
      left_ear="Fowling Earring",
      right_ear="Bushinomimi",
      left_ring="Rajas Ring",
      right_ring="Flame Ring +1",
      back={ name="Amemet Mantle +1", augments={'DEX+1','Attack+5','Pet: "Dbl.Atk."+2 Pet: Crit.hit rate +2',}},
   } )
 
    midSWAcc = sidewinderWS:addMode( "MidACC", {
	   left_ring="Dragon Ring",
	   right_ring="Dragon Ring",
	   
	} )
	
	fullWSAcc= sidewinderWS:addMode( "FullAcc", {
	   neck="Peacock charm",
	   left_ring="Dragon Ring",
	   right_ring="Dragon Ring",
	   legs="Dusk Trousers",
	} )
 
    preCast:addSet( sidewinderWS, "Sidewinder" )
	
   -- I'm going to use a dummy set to control behaviours for certain abilities.
   dummyThirdSeiganHasso = MelfGS:new( "Dummy TSH", {} )
   dummyThirdSeiganHasso:addRule( function( spell, dSet )
      if( midaction() == true ) then
         cast_delay(2)
      end
   end )

   preCast:addSet( dummyThirdSeiganHasso, "Third Eye", "Seigan", "Hasso" )
   -- ok, what on earth are we doing with the above?
   -- We are creating a dummy set and adding a rule to it.
   -- What that rule does is check to see if you are in the middle of something(ie midaction), and if you are...
   -- Delay the casting of the current ability/skill for 2 seconds
   -- And, we are adding that set with "Third Eye", "Seigan" and "Hasso" triggers.
   -- What we are saying is, if I try to use THird Eye, Seigan, or Hasso while I'm in the middle of say... using a weaponsill, or curing waltz, delay third eye or seigan or hasso for 2 seconds
   -- Thus, we guarantee that it goes off.

   --------------------
   -- Aftercast Sets --
   --------------------
   -- TPSet
   -- IdleSet
   -- Dummy: Aftercast

   --------------------------------------------------------------
   -- Storing Gearsets in simple gearTables                    --
   --------------------------------------------------------------
   -- I am going to show you how to store your gear sets in simple lua tables, or gearTables as I've been refering to them.
   -- There aren't too many reasons to do this, most of the time you will be working with MelfGS objects that contain
   -- many gearTables in the forms of modes.
   -- This is another style of doing it, and its more of raw lua and GearSwap functionality.
   -- However, it can make things a bit more modular/resusable. 

   simpleTPSet = {
      main="Hagun", -- when I'm in dynamis and have a relic buy, I //gs disable main to prevent Hagun from being swapped in
      sub="Katana Strap",
      ammo="Tiphia Sting",
      head="Walahra Turban",
      body="Askar korazin",
      hands="Dusk Gloves",
      legs="Byakko's haidate",
      feet="Fuma Kyahan",
      neck={ name="Chivalrous Chain", augments={'Crit.hit rate+1','Earth resistance+1','Fire resistance+5',}},
      waist="Speed Belt",
      left_ear="Fowling Earring",
      right_ear="Bushinomimi",
      left_ring="Rajas Ring",
      right_ring="Sniper's Ring +1",
      back="Amemet mantle +1"
   }
   
   accTPSet = {
      main="Hagun", -- when I'm in dynamis and have a relic buy, I //gs disable main to prevent Hagun from being swapped in
      sub="Katana Strap",
      ammo="Tiphia Sting",
      head="Walahra Turban",
      body="Haubergeon +1",
      hands="Dusk Gloves",
      legs="Byakko's haidate",
      feet="Fuma Kyahan",
      neck="Peacock Charm",
      waist="Speed Belt",
      left_ear="Fowling Earring",
      right_ear="Bushinomimi",
      left_ring="Sniper's Ring +1",
      right_ring="Sniper's Ring +1",
      back="Amemet mantle +1"
   }
   simpleIdleSet = {
      main="Hagun",
      sub="Katana Strap",
      ammo="Tiphia Sting",
      head="Shura zunari kabuto",
      body="Askar korazin",
      hands="Alkyoneus's bracelets",
      legs="Byakko's haidate",
      feet="Fuma Kyahan",
      neck={ name="Chivalrous Chain", augments={'"Dual Wield"+1','Ice resistance+5','STR+1 DEX+1',}},
      waist="Speed Belt",
      left_ear="Fowling Earring",
      right_ear="Bushinomimi",
      left_ring="Rajas Ring",
      right_ring="Sniper's Ring +1",
      back="Amemet mantle +1"
   }
   
   -- I don't currently, but you can add modes(or rules) with increased accuracy to the TPSet and WeaponSkill sets
   TPSet = MelfGS:new( "TPSet", simpleTPSet ) -- notice how instead of doin a { and then goign to the next line and doing what I did above and then ending with a } ) on its own line, I can just put the variable in there instead
   firemode = TPSet:addMode( "Fire Mode", {
      main={ name="Hagun", augments={'Light resistance+5','Crit. hit damage +2%','MP+6',}},
      sub="Pole Grip",
      range="Cerberus Bow",
      head="Green Ribbon +1",
      body="Bastokan Harness",
      hands="Tarasque Mitts +1",
      legs="Dino Trousers",
      feet="Suzaku's Sune-Ate",
      neck="Buburimu Gorget",
      waist="Water Belt",
      left_ear={ name="Victory Earring +1", augments={'"Shield Mastery"+1','Attack+3','Pet: "Dbl.Atk."+1 Pet: Crit.hit rate +1',}},
      right_ear="Victory Earring +1",
      left_ring="Victory Ring +1",
      right_ring="Victory Ring +1",
      back={ name="Cerberus Mantle", augments={'Accuracy+2',}},
   } )
   
   accmode = TPSet:addMode( "Acc Mode", accTPSet )
   
   afterCast:addSet( TPSet, "Engaged" )

   -- if I engage, and I'm in seigan, I want to automatically use third eye
   TPSet:addRule( function( spell, dSet )
      if( buffactive['Third Eye'] == nil and buffactive.seigan ) then
         send_command( '@input /ja "Third Eye" <me>' )
      end
   end )

   idleSet = MelfGS:new( "IdleSet", simpleIdleSet )

   afterCast:addSet( idleSet, "Idle" )

   ------------------------------------------------------------------
   -- Dealing with Aftercast on Melee                             --
   ------------------------------------------------------------------
   -- Dealing with aftercast on melee jobs is a little more precarious than on mage.
   -- Mages don't engage, meaning they generally always return to their Idle states.
   -- Melee could return to "Engaged" or "Idle".
   -- Here, we will create a dummy "Aftercast" gearswap with a rule to deal with it.

   dummyACSet = MelfGS:new( "Dummy Aftercast Set", {} ) -- pass it an empty gearTable with just {}
   afterCast:addSet( dummyACSet, "Aftercast" ) -- since the afterCast melfmanager was created with the "Aftercast" string, that's its last resort trigger. We are adding the dummyACSet as its last resort sort.

   -- Now, we will add a rule to control this empty set reusing our modular simple gearSets we defined earlier.
   dummyACSet:addRule( function( spell, dSet )
      if( player.status == 'Engaged' ) then 
         TPSet:equip()
      else
         idleSet:equip()
      end
   end )
end

function precast(spell)
   preCast:equip( spell )
end

function midcast(spell)
end

function aftercast(spell)
   afterCast:equip( spell )
end

function status_change(new, tab)
   afterCast:equip( nil, new )
end

-- a little auto magic to keep third eye up every 30 seconds(will eventually create a dummy for this)
function buff_change(status,gain_or_loss)
   if( automode == true ) then
      if( player.status == "Engaged" and status == "Third Eye" and gain_or_loss == false  and buffactive.seigan ) then
         send_command( string.format( "wait %d;input /ja \"Third Eye\" <me>", windower.ffxi.get_ability_recasts()[133]+1 ) )
      end
   
      if( status == "Seigan" and gain_or_loss == false and shmode == 0 ) then
         send_command( '@input /ja "Seigan" <me>' )
      elseif( status == "Hasso" and gain_or_loss == false and shmode == 1 ) then
         send_command( '@input /ja "Hasso" <me>' )
      end
   end
end

function self_command(command)
   if command == "hassomode" then
      shmode = 1
      send_command( '@input /ja "Hasso" <me>' )
   elseif command == "seiganmode" then
      shmode = 0
      send_command( '@input /ja "Seigan" <me>')
   elseif command == "swacc" then
      sidewinderWS:up()
   elseif command == 'automode' then
      if( automode == false ) then
	     add_to_chat( "Automode ON(Automatically put Seigan/Hasso on when it wears and Third Eye on engaged if Seigan)" )
		 automode = true
      else
	     add_to_chat( "Automode Off" )
		 automode = false
	  end
   elseif command == 'tpmode' then
	  TPSet:up()
	  TPSet:equip()
   elseif command == 'tankmode' then
      if( tankmode == true ) then
	     add_to_chat( "DD Mode ON" )
		 tankmode = false
	  else
	     add_to_chat( "Tank Mode ON(AutoCancel Seigan|Hasso on Utsu)" )
		 tankmode = true
	  end
   end
end

function file_unload()
   send_command( '@input //gs l Melfie_SAMnew.lua' )
end
