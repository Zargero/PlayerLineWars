local CLASS = {}
 
CLASS.DisplayName			= "Wizard"
CLASS.WalkSpeed 			= 350
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 450
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.PlayerModel			= "models/player/kliener.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = false
CLASS.MaxHealth				= 350
CLASS.StartHealth			= 50
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= false // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking
CLASS.FullRotation			= false // Allow the player's model to rotate upwards, etc etc
 
function CLASS:Loadout( pl )
 
	pl:Stripweapons()
	pl:Give( "weapon_Sword" )
 
end
 
function CLASS:OnSpawn( pl )
end
 
function CLASS:OnDeath( pl, attacker, dmginfo )
end
 
function CLASS:Think( pl )
end
 
function CLASS:Move( pl, mv )
end
 
function CLASS:OnKeyPress( pl, key )
end
 
function CLASS:OnKeyRelease( pl, key )
end
 
function CLASS:ShouldDrawLocalPlayer( pl )
	return false
end
 
function CLASS:CalcView( ply, origin, angles, fov )
end
 
player_class.Register( "Human", CLASS )
