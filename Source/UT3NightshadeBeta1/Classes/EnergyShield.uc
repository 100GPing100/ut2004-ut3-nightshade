//============================================================
// Shield generator (spawns a shield to protect from damage).
// Credits: 100GPing100(Jos� Lu�s)
// Copytight Jos� Lu�s, 2012
// Contact: zeluis.100@gmail.com
//============================================================
class EnergyShield extends DeployableMine;

#exec audio import group=ShieldSounds file=..\Sounds\UT3Nightshade\Shield\Shield_Open.wav
#exec audio import group=ShieldSounds file=..\Sounds\UT3Nightshade\Shield\Shield_Close.wav

/*  */
var Shield ShieldActor;
/*  */
var Sound OpenSnd;
/*  */
var Sound CloseSnd;

simulated function Deploy()
{
	Super.Deploy();
	
	PlayAnim('Deploy');
	PlaySound(OpenSnd, SLOT_None);
	
	ShieldActor = Spawn(class'Shield', self,, Location);
	ShieldActor.SetCollision(true, false);
	ShieldActor.BaseMine = self;
	bCollideWorld = false;
}
simulated event Destroyed()
{
	Super.Destroyed();
	ShieldActor.Destroy();
	
	if (Role == ROLE_Authority)
	{
		PlaySound(CloseSnd, SLOT_None);
	}
}

DefaultProperties
{
	Mesh = SkeletalMesh'UT3NightshadeAnims.ShieldMine';
	DrawType = DT_Mesh;
	
	bHardAttach = true;
	bBlockActors = false;
	bAlwaysRelevant = true;
	LifeSpan = 90.0;
	
	// Sound.
	OpenSnd = Sound'UT3NightshadeBeta1.ShieldSounds.Shield_Open';
	CloseSnd = Sound'UT3NightshadeBeta1.ShieldSounds.Shield_Close';
}
