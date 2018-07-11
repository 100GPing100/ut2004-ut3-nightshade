class SlowVolume extends PhysicsVolume;

/*  */
var float ScalingFactor;
/*  */
var float ProjectileScalingFactor;
/*  */
var float PawnLifeDrainPerSec;
/*  */
var DeployableMine MineBase;

simulated event PostBeginPlay()
{
	Activate();
	
	if (ROLE == ROLE_Authority)
		SetTimer(1.0, true);
}
simulated function Activate()
{
	local Actor A;
	
	SetCollision(true, false, false);
	
	foreach DynamicActors(class'Actor', A)
	{
		if (Encompasses(A))
		{
			if (A.IsA('Pawn'))
			{
				PawnLeavingVolume(Pawn(A));
			}
			else
			{
				ActorLeavingVolume(A);
			}
		}
	}
	
	if (Role == ROLE_Authority)
	{
		//PlaySound(DestroySound);
	}
}
simulated function PawnLeavingVolume(Pawn Other)
{
	local SVehicle V;
	local PlayerController PC;
	
	ActorLeavingVolume(Other);
	
	V = SVehicle(Other);
	if (V != None) // Maybe karma too?
		KarmaParamsRBFull(V.KParams).KMaxSpeed = KarmaParamsRBFull(V.KParams).Default.KMaxSpeed;
	
	PC = PlayerController(Other.Controller);
	if (PC != None)
	{
		//PC.ClientPlaySound(ExitSound);
		//AmbientSound = AmbientOutside;
		
		//PC.ConsoleCommand("SETSOUNDMODE 0", false);
	}
}
simulated function ActorLeavingVolume(Actor Other)
{
	/*if (Weapon(Other) == None)
	{
		Other.TimeDilatation = Other.Default.CustomTimeDilatation;
	}*/
	if (SVehicle(Other) != None)
		KarmaParamsRBFull(SVehicle(Other).KParams).KMaxSpeed = KarmaParamsRBFull(SVehicle(Other).KParams).Default.KMaxSpeed;
}
simulated event Destroyed()
{
	local Actor A;
	
	Super.Destroyed();
	
	foreach DynamicActors(class'Actor', A)
	{
		if (Encompasses(A))
		{
			if (A.IsA('Pawn'))
			{
				PawnLeavingVolume(Pawn(A));
			}
		}
	}
	
	if (Role == ROLE_Authority)
	{
		//PlaySound(DestroySound);
	}
	
	MineBase.Destroy();
}
simulated event ActorEnteredVolume(Actor Other)
{
	if (Projectile(Other) != None)
		Projectile(Other).Speed = ProjectileScalingFactor;
	/*else
		Other.CustomTimeDilation = ScalingFactor;*/
}
simulated event PawnEnteredVolume(Pawn Other)
{
	SlowPawn(Other);
}
simulated function SlowPawn(Pawn Other)
{
	local SVehicle V;
	
	Level.Game.BroadCast(self, "SlowingPawn.", 'Say');
	V = SVehicle(Other);
	if (V != None)
		KarmaParamsRBFull(V.KParams).KMaxSpeed = KarmaParamsRBFull(V.KParams).Default.KMaxSpeed * ScalingFactor;
	else
	{
		Other.GroundSpeed = Other.Default.GroundSpeed * ScalingFactor;
		Other.AirSpeed = Other.Default.AirSpeed * ScalingFactor;
	}
}
simulated function SlowPawnDown(Pawn Other)
{
	local SVehicle V;
	local PlayerController PC;
	
	ActorEnteredVolume(Other);
	
	V = SVehicle(Other);
	if (V != None) // Maybe karma too?
		KarmaParamsRBFull(V.KParams).KMaxSpeed = KarmaParamsRBFull(V.KParams).Default.KMaxSpeed * ScalingFactor;
	
	PC = PlayerController(Other.Controller);
	if (PC != None)
	{
		//PC.ClientPlaySound(EnterSound);
		//AmbientSound = InsideAmbientSound;
		
		//PC.ConsoleCommand("SETSOUNDMODE 1", false);
	}
}
function Timer()
{
	local Pawn P;
	local GameObjective O;
	
	foreach TouchingActors(class'Pawn', P)
	{
		if (P.PlayerReplicationInfo != None)
			LifeSpan -= PawnLifeDrainPerSec;
		if (P.GroundSpeed != P.Default.GroundSpeed * ScalingFactor)
			SlowPawn(P);
	}
	foreach TouchingActors(class'GameObjective', O)
	{
		if (!O.bDisabled)
			LifeSpan -= 1.5 * PawnLifeDrainPerSec;
	}
	if (LifeSpan == 0.0)
		LifeSpan = 0.001;
}
function Touch(Actor Other)
{
	local Pawn P;
	
	P = Pawn(Other);
	if (P != None && P.GroundSpeed != P.Default.GroundSpeed * ScalingFactor)
		SlowPawn(P);
	else if (P != None && P.GroundSpeed == P.Default.GroundSpeed)
	{
		P.GroundSpeed = P.Default.GroundSpeed;
		P.AirSpeed = P.Default.AirSpeed;
	}
}

DefaultProperties
{
	// Looks.
	StaticMesh = StaticMesh'UT3NightshadeSM.SlowVolumeCube';
	DrawType = DT_StaticMesh;
	MainScale = Scale(X=455,Y=455,Z=355);
	
	// Misc.
	LifeSpan = 180.0;
	Priority = 100000;
	
	// Collision.
	bProjTarget = true;
	bCollideActors = false;
	bBlockActors = false;
	bStatic = false;
	bNoDelete = false;
	bHidden = false;
	
	// Vars.
	ScalingFactor = 0.2;
	ProjectileScalingFactor = 0.125;
	PawnLifeDrainPerSec = 3.0;
	Gravity = (X=0,Y=0,Z=-190);
	
	// Network.
	RemoteRole = ROLE_Authority;
	bNetInitialRotation = true;
	NetUpdateFrequency = 1.0;
}
