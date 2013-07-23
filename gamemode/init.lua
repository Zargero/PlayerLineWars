AddCSLuaFile( "cl_init.lua" ) --Tell the server that the client need to download cl_init.lua
AddCSLuaFile( "shared.lua" ) --Tell the server that the client need to download shared.lua
 
include( 'shared.lua' ) --Tell the server to load shared.lua
 
function GM:PlayerInitialSpawn( ply ) --"When the player first joins the server and spawns" function
 
    RunConsoleCommand( "team_menu" ) --Run the console command when the player first spawns
 
end --End the "when player first joins server and spawn" function
 
function GM:PlayerLoadout( ply ) --Weapon/ammo/item function
 
    if ply:Team() == 1 then --If the player is in team 1
 
        ply:Give( "weapon_physcannon" ) --Give them the Gravity Gun
ply:Spawn() -- Make the player respawn
 
    elseif ply:Team() == 2 then --If the player is in team 2
 
        ply:Give( "weapon_physgun" ) --Give the player the Physics Gun
ply:Spawn() -- Make the player respawn
 
    end --Here we end the if condition
 
end --Here we end the Loadout function

function team_1( ply )
 
    ply:SetTeam( 1 )
 
end
 
function team_2( ply )
 
    ply:SetTeam( 2 )
end
 
concommand.Add( "team_1", team_1 )
concommand.Add( "team_2", team_2 )
