local shmode = 0;

function get_sets()
   sets.precast = {}
   sets.precast.Meditate = { head="Myochin Kabuto", hands="Saotome Kote"}
   
   sets.precast.WS = {
      main="Hagun",
      sub="Pole grip",
      ammo="Tiphia Sting",
      head="Shura zunari kabuto",
      body="Haubergeon +1",
      hands="Alkyoneus's bracelets",
      legs="Shura haidate",
      feet="Rutter sabatons",
      neck={ name="Chivalrous Chain", augments={'"Dual Wield"+1','Ice resistance+5','STR+1 DEX+1',}},
      waist={ name="Potent Belt", augments={'STR+1 VIT+1','INT+1','Attack+4','STR+1 DEX-0.5 VIT-0.5',}},
      left_ear="Fowling Earring",
	  right_ear="Bushinomimi",
      left_ring="Victory Ring",
      right_ring="Victory Ring",
      back="Amemet mantle +1"
   }
   
   sets.precast.Kaiten = {
       head={ name="Wyvern Helm", augments={'Wind resistance+1','"Counter"+1','Attack+5',}},
       body={ name="Byrnie +1", augments={'Accuracy+3','STR+1 DEX+1',}},
       hands="Alkyoneus's Brc.",
       legs="Shura Haidate",
       feet="Rutter Sabatons",
       neck={ name="Chivalrous Chain", augments={'Attack+5','Enmity+2',}},
       waist={ name="Potent Belt", augments={'STR+1 VIT+1','INT+1','Attack+4','STR+1 DEX-0.5 VIT-0.5',}},
       left_ear="Spike Earring",
       right_ear="Bushinomimi",
       left_ring="Victory Ring",
       right_ring="Victory Ring",
       back="Amemet mantle +1",
   }
   
   sets.engaged = {
      main="Hagun",
      sub="Pole grip",
      ammo="Tiphia Sting",
      head="Walahra Turban",
      body="Askar korazin",
      hands="Ochiudo's Kote",
      legs="Byakko's haidate",
      feet="Fuma Kyahan",
      neck={ name="Chivalrous Chain", augments={'Crit.hit rate+1','Earth resistance+1','Fire resistance+5',}},
      waist="Speed Belt",
      left_ear="Wyvern earring",
      right_ear="Bushinomimi",
      left_ring="Sniper's Ring +1",
      right_ring="Sniper's Ring +1",
      back="Amemet mantle +1"
   }
   
   sets.idle = {
      main="Hagun",
      sub="Pole grip",
      ammo="Tiphia Sting",
      head="Shura zunari kabuto",
      body="Askar korazin",
      hands="Alkyoneus's bracelets",
      legs="Byakko's haidate",
      feet="Fuma Kyahan",
      neck={ name="Chivalrous Chain", augments={'"Dual Wield"+1','Ice resistance+5','STR+1 DEX+1',}},
      waist="Speed Belt",
      left_ear="Spike Earring",
      right_ear="Bushinomimi",
      left_ring="Sniper's Ring +1",
      right_ring="Sniper's Ring +1",
      back="Amemet mantle +1"
   }
   
   sets.nightwsequip = {
      left_ear="Vampire earring",
	  right_ear="Vampire earring"
   }
end

function precast(spell)
   if( spell.type == "WeaponSkill" ) then
      if( spell.english == "Tachi: Kaiten" ) then
	     equip( sets.precast.Kaiten )
	  else
         equip( sets.precast.WS )
      end
	  if( isnight() == true ) then
	     equip( sets.nightwsequip )
      end
   elseif( spell.english == "Third Eye" and midaction() == true ) then
	  cast_delay(1)
   elseif( spell.english == "Seigan" and midaction() == true ) then
      cast_delay(2)
   elseif( spell.english == "Hasso" and midaction() == true ) then
	  cast_delay(2)
   elseif( spell.english == "Meditate" ) then
      equip( sets.precast.Meditate)
   end
end

function midcast(spell)
end

function aftercast(spell)
   if( player.status == "Engaged" ) then
      equip( sets.engaged )
   else
      equip( sets.idle )
   end
end

function isnight()
   if( world.time >= 1020 or world.time <= 360 ) then
      return true
   end
   return false
end

function status_change(new,tab)
   if( new == "Engaged" ) then
      if( buffactive['Third Eye'] == nil and buffactive.seigan ) then
         send_command( '@input /ja "Third Eye" <me>' )
	  end
	  equip( sets.engaged ) 
   else
      equip( sets.idle )
   end
end

function buff_change(status,gain_or_loss)
   if( player.status == "Engaged" and status == "Third Eye" and gain_or_loss == false  and buffactive.seigan ) then
      send_command( string.format( "wait %d;input /ja \"Third Eye\" <me>", windower.ffxi.get_ability_recasts()[133]+1 ) )
   end
   
   if( status == "Seigan" and gain_or_loss == false and shmode == 0 ) then
      send_command( '@input /ja "Seigan" <me>' )
   elseif( status == "Hasso" and gain_or_loss == false and shmode == 1 ) then
      send_command( '@input /ja "Hasso" <me>' )
   end
end

function self_command(command)
   if command == "hassomode" then
      shmode = 1
	  send_command( '@input /ja "Hasso" <me>' )
   elseif command == "seiganmode" then
      shmode = 0
	  send_command( '@input /ja "Seigan" <me>')
   end
end
function file_unload()
  send_command( '@input //gs l Melfie_SAM.lua')
end
