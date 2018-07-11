//============================================================
// UT3 Nightshade
// Credits: 100GPing100(José Luís)
// Copytight José Luís, 2012
// Contact: zeluis.100@gmail.com
//============================================================
class Weap_UT3Nightshade extends ONSWeapon;

state ProjectileFireMode
{
	function AltFire(Controller C) { }
}

function byte BestMode()
{
	return 1;
}

DefaultProperties
{
	// Looks.
	Mesh = SkeletalMesh'UT3NightshadeAnims.NightshadeWeap';
	RedSkin = Shader'UT3NightshadeTex.Nightshader.NightshadeSkin';
	BlueSkin = Shader'UT3NightshadeTex.Nightshader.NightshadeSkinBlue';
	
	// Bones.
	YawBone = "Turret_Yaw";
	//YawStartConstraint = 57344.0;
	//YawEndConstraint = 8192.0;
	PitchBone = "Turret_Pitch";
	WeaponFireAttachmentBone = "Turret_Pitch";
	
	// Fire offset/speed.
	WeaponFireOffset = 25.0;
	DualFireOffset = 0.0;
	RotationsPerSecond = 0.8;
	FireInterval = 0.2;
	AltFireInterval = 0.0;
	
	// Sound.
	FireSoundClass = Sound'ONSVehicleSounds-S.HoverBike.HoverBikeFire01';
	
	// Force feedback.
	FireForce = "HoverBikeFire";
	
	// Damage.
	ProjectileClass = Class'Onslaught.ONSHoverBikePlasmaProjectile';
	
	// AI.
	AIInfo(0)=(bLeadTarget=True)
	AIInfo(1)=(bLeadTarget=True)
}
