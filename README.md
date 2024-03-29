<div align="center">
    <a href="https://discord.gg/Z9Mxu72zZ6" target="_blank">
        <img src="https://discordapp.com/api/guilds/857672921912836116/widget.png?style=banner2" alt="Andyyy Development Server" height="80px" />
    </a>
</div>

# For developers:

**Set aim animation:**
```lua
exports["ND_GunAnims"]:setAimAnim("gang")
```

**Get aim animation**
```lua
exports["ND_GunAnims"]:getAimAnim() -- default | gang | hillbilly
```

# Configuration

## **How to configure aim animations:**

Open `ND_GunAnims/data/aim.lua`, to create a command that changes aim animation you can do `command = "aim"` when player use /aim they can select their aim animation. If you want to disable command you can do `command = false`.
If you want to set a default aim animation for everyone you can do `default = "gang"` it will set the one hand aiming gun animation for all players. 

---

## **How to configure clothing holsters**

`ND_GunAnims/data/holster.lua` is the config that changes the holster clothing model, you can set it to any clothing and any wepaon you'd like.
They keys `male` and `female` are the clothing components for the selected variation, the first number is for when the weapon is holstered and the second is when the weapon is unholstered, for the variation you can find a list of variation numbers below:

0. Head
1. Beard
2. Hair
3. Torso
4. Legs
5. Hands
6. Foot
7. Scarfs/Neck Accessories
8. Accessories 1
9. Accessories 2
10. Decals
11. Auxiliary parts for torso

---

## **How to configure holster animations**

To configure the holster animations for different weapons you can do it in `ND_GunAnims/data/animations.lua`

#### info.animations

This is where you create the animations and give them names. Let's use this example:
```lua
police = {
    holster = { dict = "reaction@intimidation@cop@unarmed", clip = "intro", duration = 400, clothing = 300 },
    unholster = { dict = "rcmjosh4", clip = "josh_leadout_cop2", duration = 300, clothing = 0, cancel = true }
}
```
* `holster`: played when you holster the weapon.
* `unholster`: played when you pull out the weapon.
  * `dict`: animation dictionary.
  * `clip`: animation name.
  * `duration`: how long the animation will play.
  * `clothing`: optional and only needed if you use the animation with clothing in info.clothing. It is the time in ms of how long into the animtion the clothing component will change.
  * `cancel`: will cancel the animation when half the duration is reached.


#### info.default

The default anim for weapons not found in groups, weapons, or clothing.


#### info.weaponGroups

Animation name by weapon groups can be found here: https://docs.fivem.net/natives/?_0xC3287EE3050FB74C
This is a list of relevant weapon groups:
* `GROUP_HEAVY`
* `GROUP_MELEE`
* `GROUP_MG`
* `GROUP_PISTOL`
* `GROUP_RIFLE`
* `GROUP_SHOTGUN`
* `GROUP_SMG`
* `GROUP_SNIPER`
* `GROUP_STUNGUN`
* `GROUP_THROWN`
* `GROUP_UNARMED`

#### info.weapons

Animation name by weapon hash, if you add a weapon here it will ignore the animation on it's group and instead play a specific animation set here.

#### info.clothing

Animtion by clothing component, if wearing specific clothing such as a holster then everything else ignored and that anim is used.

* `holster`: animations played based on clothing when weapon is holstered.
* `unholster`: animations played based on clothing when weapon is unholstered.

  * `anim`: animation name in info.animations.
  * `weapons`: list of weapons that this is valid for.
  * `variation`: variation for the clothing components.
  * `male`: clothing components for male anim will be valid for.
  * `female`: clothing components for female anim will be valid for.












