if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
ENT.PrintName = "Chicken"
ENT.Author = "Blechkanne"
ENT.Purpose = "Does Chicken Stuff"
ENT.Instructions = "Do Chickchick"

-- Misc --
ENT.PrintName = "Template"
ENT.Category = "Other"
ENT.Models = {"models/sirgibs/ragdolls/chicken.mdl"}
ENT.Skins = {0, 1}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 10)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true

-- Stats --
ENT.SpawnHealth = 100
ENT.HealthRegen = 0
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- Sounds --
ENT.OnSpawnSounds = {"chicken_idle1", "chicken_idle2", "chicken_idle3"}
ENT.OnIdleSounds = {"chicken_idle1", "chicken_idle2", "chicken_idle3"}
ENT.IdleSoundDelay = 4
ENT.ClientIdleSounds = true
ENT.OnDamageSounds = {"chicken_hurt"}
ENT.DamageSoundDelay = 1
ENT.OnDeathSounds = {"chicken_die"}
ENT.OnDownedSounds = {"chicken_die"}
ENT.Footsteps = {}

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 20
ENT.ReachEnemyRange = 20
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {}
ENT.Frightening = false
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Locomotion --
ENT.Acceleration = 1000
ENT.Deceleration = 1000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Animations --
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_RUN
ENT.RunAnimRate = 1
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 2

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 150
ENT.RunSpeed = 300

-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = true
ENT.ClimbLadders = true
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = false
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 100
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
ENT.EyeBone = ""
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

-- Weapons --
ENT.UseWeapons = false
ENT.Weapons = {}
ENT.WeaponAccuracy = 1
ENT.WeaponAttachment = "Anim_Attachment_RH"
ENT.DropWeaponOnDeath = false
ENT.AcceptPlayerWeapons = false

-- Possession --
ENT.PossessionEnabled = false
ENT.PossessionPrompt = false
ENT.PossessionCrosshair = false
ENT.PossessionMovement = POSSESSION_MOVE_1DIR
ENT.PossessionViews = {}
ENT.PossessionBinds = {}

if SERVER then
    function ENT:CustomInitialize()
        local owner = self:GetOwner()
        self:SetBodygroup(1, 1)
        -- setting up the relations
        self:SetDefaultRelationship(D_NU)

        if (engine.ActiveGamemode() == "terrortown") then
            local ownerTeam = owner:GetTeam()

            for _, ply in ipairs(player.GetAll()) do
                if (ply:GetTeam() == ownerTeam) then
                    self:AddEntityRelationship(ply, D_LI, 5)
                else 
                    self:AddEntityRelationship(ply, D_HT, 5)
                end
            end
        else
            self:AddEntityRelationship(owner, D_LI, 5)
        end
    end
    function ENT:CustomThink()
    end

    -- These hooks are called when the nextbot has an enemy (inside the coroutine)
    function ENT:OnMeleeAttack(enemy)
        -- if (not enemy:IsPlayer()) then return end
        self:PlayActivityAndMove(ACT_JUMP, 1, self.FaceEnemy)

        local effectData = EffectData()
        effectData:SetMagnitude(50)
        effectData:SetRadius(200)
        effectData:SetScale(1)
        effectData:SetEntity(self)
        effectData:SetOrigin(self:GetPos())
        effectData:SetFlags(2)

        util.Effect("Explosion", effectData)
        util.BlastDamage(self, self, self:GetPos(), 200, 500)
        self:Remove()
    end

    function ENT:OnRangeAttack(enemy) 
    end
    function ENT:OnChaseEnemy(enemy) 
    end
    function ENT:OnAvoidEnemy(enemy) 
    end

    -- These hooks are called while the nextbot is patrolling (inside the coroutine)
    function ENT:OnReachedPatrol(pos)
        self:Wait(math.random(3, 7))
    end
    function ENT:OnPatrolUnreachable(pos)
        self:AddPatrolPos(self:RandomPos(1500))
    end
    function ENT:OnPatrolling(pos) end

    -- These hooks are called when the current enemy changes (outside the coroutine)
    function ENT:OnNewEnemy(enemy) end
    function ENT:OnEnemyChange(oldEnemy, newEnemy) end
    function ENT:OnLastEnemy(enemy) end

    -- Those hooks are called inside the coroutine
    function ENT:OnSpawn()

    end
    function ENT:OnIdle()
        self:AddPatrolPos(self:RandomPos(1500))
    end

    -- Called outside the coroutine
    function ENT:OnTakeDamage(dmg, hitgroup)
        self:SpotEntity(dmg:GetAttacker())
    end
    function ENT:OnFatalDamage(dmg, hitgroup) end
    
    -- Called inside the coroutine
    function ENT:OnTookDamage(dmg, hitgroup)
        self:SpotEntity(dmg:GetAttacker())
    end
    function ENT:OnDeath(dmg, hitgroup) end
    function ENT:OnDowned(dmg, hitgroup) end

else

    function ENT:CustomInitialize() end
    function ENT:CustomThink() end
    
    function ENT:CustomDraw()
        self:DrawModel()
        self:CreateShadow()
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)