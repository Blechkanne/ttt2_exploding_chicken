SWEP.Author = "Blechkanne"
SWEP.Category = "Weapon"
SWEP.Spawnable = true
SWEP.PrintName = "Exploding Chicken Gun"
SWEP.Purpose = "Kill People"
SWEP.Instructions = "Shoot Chicken and wait"
SWEP.ViewModel = "models/sirgibs/ragdolls/chicken.mdl"
SWEP.WorldModel = "models/sirgibs/ragdolls/chicken.mdl"
SWEP.Slot = 1
SWEP.Primary.Ammo = "chicken_ammo"
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

SWEP.UseHands = true

-- TTT Customisation
if (engine.ActiveGamemode() == "terrortown") then
	SWEP.Base = "weapon_tttbase"
	SWEP.Kind = WEAPON_EQUIP1
	SWEP.AutoSpawnable = false
	SWEP.CanBuy = { ROLE_TRAITOR, ROLE_JACKAL }
	SWEP.LimitedStock = true
	SWEP.Slot = 7
	SWEP.Icon = "VGUI/ttt/icon_exploding_chicken.vtf"
	SWEP.ViewModelFlip = true
	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "Exploding Chicken",
		desc = [[Place the Chicken, it will target the next enemy and explode on impact]]
	}
end

function SWEP:Initialize()
	self.m_bInitialized = true
end

function SWEP:GetViewModelPosition(pos, ang)
	return pos + ang:Forward() * 10 + ang:Right() * 0 - ang:Up() * 18, ang
end

function SWEP:Think()
	if not self.m_bInitialized then
		self:Initialize()
	end
end

function SWEP:Equip()
    self:PlayIdleSound()
end

function SWEP:Deploy()
    self:PlayIdleSound()
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime() + 0.5 )
    local owner = self:GetOwner()
    if (not owner:IsValid()) then return end
    self:CreateChicken()

    self:TakePrimaryAmmo(1)
    if SERVER then
        if self:Clip1() == 0 then
            self:Remove()
        end
    end
end

function SWEP:CreateChicken() 
    if SERVER then
        local owner = self:GetOwner()
        local chickenEntity = ents.Create("ttt_chicken")
        if (not chickenEntity:IsValid()) then return end
        local shootPos = owner:GetShootPos()
        local eyeAngles = owner:EyeAngles()
        local forward = eyeAngles:Forward();

        chickenEntity:SetPos(shootPos + forward * 20)
        chickenEntity:SetAngles(Angle(0, eyeAngles.y, 0))
        chickenEntity:SetOwner(owner)
        chickenEntity:Spawn()
        chickenEntity:SetVelocity(forward * 1000)
        chickenEntity.fingerprints = self.fingerprints

        cleanup.Add(owner, "props", chickenEntity)
        undo.Create("chickenShot")
            undo.AddEntity(chickenEntity)
            undo.SetPlayer(owner)
        undo.Finish()
    end
end

function SWEP:SecondaryAttack() 
    self:PlayIdleSound()
end

function SWEP:PlayIdleSound()
    local owner = self:GetOwner()
    local random = math.Round(math.Rand(1,3))
    owner:EmitSound("chicken_idle" .. random)
end