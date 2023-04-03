AddCSLuaFile("entities/ttt_chicken/cl_init.lua")
AddCSLuaFile("entities/ttt_chicken/shared.lua")

resource.AddFile("sound/die.wav")
resource.AddFile("sound/hurt.wav")
resource.AddFile("sound/idle1.wav")
resource.AddFile("sound/idle2.wav")
resource.AddFile("sound/idle3.wav")

util.PrecacheModel("models/sirgibs/ragdolls/chicken.mdl")


sound.Add({
	name = "chicken_idle1",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "chicken/idle1.wav"
})
sound.Add({
	name = "chicken_idle2",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "chicken/idle2.wav"
})
sound.Add({
	name = "chicken_idle3",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "chicken/idle3.wav"
})
sound.Add({
	name = "chicken_hurt",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "chicken/hurt.wav"
})
sound.Add({
	name = "chicken_die",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "chicken/die.wav"
})
