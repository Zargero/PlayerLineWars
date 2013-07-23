if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "melee"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Sword" -- HA HA! I FIXED IT! And added custom sounds.		
	SWEP.Author				= "Stingwraith"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 7
	SWEP.ViewModelFOV		= 62
	SWEP.IconLetter			= "g"

end

SWEP.IronSightsPos = Vector (-11.374, -2.0045, -3.0521)
SWEP.IronSightsAng = Vector (-0.1663, 3.5401, -42.1101)

---------------------------------------------------
 
-- function SWEP:Reload() --To do when reloading
-- end 
 
function SWEP:Think() -- Called every frame
if (!self.player:Alive()) then
ent:Remove
end

function SWEP:Initialize()
util.PrecacheSound("weapons/stingwraith_sword/sword_flesh.wav")
util.PrecacheSound("weapons/stingwraith_sword/sword_hit.wav")
util.PrecacheSound("weapons/stingwraith_sword/swing_1.wav")
util.PrecacheSound("weapons/stingwraith_sword/swing_2.wav")
util.PrecacheSound("weapons/stingwraith_sword/swing_3.wav")
util.PrecacheSound("weapons/stingwraith_sword/swing_4.wav")
util.PrecacheSound("weapons/stingwraith_sword/longbladOUT.wav")
util.PrecacheSound("weapons/stingwraith_sword/longbladAWAY.wav")
self.Weapon:SetNetworkedBool( "Ironsights", false )
end
 
/*---------------------------------------------------------
		Unchoppable
---------------------------------------------------------*/
local non_human_npcs = { 
"npc_antlion", 
"npc_antlionguard", 
"npc_barnacle", 
"npc_crow", 
"npc_cscanner", 
"npc_pigeon", 
"npc_rollermine", 
"npc_dog", 
"npc_headcrab", 
"npc_zombie_torso", 
"npc_headcrab_black", 
"npc_headcrab_fast", 
"npc_manhack" };


/*---------------------------------------------------------
		Choppable
---------------------------------------------------------*/
local human_npcs = { 
"npc_alyx", 
"npc_barney", 
"npc_breen", 
"npc_combine_s", 
"npc_combine_p", 
"npc_combine_e", 
"npc_eli", 
"npc_dog", 
"npc_fastzombie", 
"npc_gman", 
"npc_kleiner", 
"npc_metropolice", 
"npc_monk", 
"npc_mossman", 
"npc_vortigaunt", 
"npc_zombie", 
"npc_citizen_rebel", 
"npc_citizen", 
"npc_citizen_dt", 
"npc_citizen_medic" };


function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime() + .4)

   local trace = self.Owner:GetEyeTrace()

 if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
 self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 1
	bullet.Damage = 25
 self.Owner:FireBullets(bullet) 
 self.Weapon:EmitSound("weapons/stingwraith_sword/sword_hit.wav")
 self.Weapon:SetNetworkedBool( "Ironsights", false )
 else
 self.Weapon:EmitSound("weapons/stingwraith_sword/swing_" .. math.random( 1, 4 ) .. ".wav")
 self.Weapon:SetNetworkedBool( "Ironsights", false )
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
 end

end

function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos ) then return
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights" )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3

 	if ( self:GetNetworkedBool( "Ironsights", true ) ) then
	local ent = ents.Create( "prop_physics" )
	    local a = self.Owner:GetAngles()
	    local k = self.Owner:GetAimVector()
	    local f = k:Angle()
	    f.p = a.p
	    f.r = a.r
	    local d = f:Forward()
	    local r = self.Owner:GetPos()
	    r.z = r.z + 31
	    a.p = a.p + 16
	    r = r + d * 50
	    ent:SetPos(r)
	    ent:SetAngles(a)
	    ent:SetModel( "models/props_debris/metal_panel02a.mdl")
	    ent:SetParent(self.Owner)
	ent:Spawn()
	else
	ent:Remove()
	end

end

function SWEP:Deploy()
self.Owner:EmitSound("weapons/stingwraith_sword/longbladOUT.wav")
self.Weapon:SetNetworkedBool( "Ironsights", false )
return true;
end

function SWEP:Holster()
self.Owner:EmitSound("weapons/stingwraith_sword/longbladAWAY.wav")
ent:Remove()
return true;
end

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

function SWEP:SetIronsights( b )

	if ( self.Weapon:GetNetworkedBool( "Ironsights" ) == b ) then return end
	self.Weapon:SetNetworkedBool( "Ironsights", b )

end


SWEP.NextSecondaryAttack = 0
-------------------------------------------------------------------
SWEP.Author   = "Stingwraith"
SWEP.Contact        = "stingwraith123@yahoo.com"
SWEP.Purpose        = "A weapon. For medieval times."
SWEP.Instructions   = "Primary fire to slash, Secondary to Block."
SWEP.Spawnable      = false
SWEP.AdminSpawnable  = true

SWEP.DrawCrosshairOnSec = false
-----------------------------------------------
SWEP.ViewModel      = "models/weapons/v_sword.mdl"
SWEP.WorldModel   = "models/weapons/w_sword.mdl"
-----------------------------------------------
SWEP.Primary.Delay		= 0.9
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 8
SWEP.Primary.NumShots		= 1		
SWEP.Primary.Cone		= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= false
SWEP.Primary.Ammo         	= "none" 
-------------------------------------------------
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
-------------------------------------------------