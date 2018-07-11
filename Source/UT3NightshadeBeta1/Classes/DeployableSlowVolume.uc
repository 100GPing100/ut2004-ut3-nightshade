class DeployableSlowVolume extends DeployableMine;

/*  */
var SlowVolume OwnedVolume;

function Deploy()
{
	/*local SlowVolume Volume;
	local vector SpawnLocation;
	local rotator Rot;
	
	SpawnLocation = Location;
	
	SpawnLocation.Z = Instigator.Location.Z;
	Rot = Instigator.Rotation;
	Rot.Pitch = 0;
	Rot.Roll = 0;
	Volume = Spawn(class'SlowVolume',,, SpawnLocation, Rot);
	if (Volume != None)
	{
		// ?
	}*/
	//Mines[2] = Spawn(Class'DeployableSlowVolume', Driver,, Location);
	local rotator rot;
	
	Super.Deploy();
	
	OwnedVolume = Spawn(class'SlowVolume', Instigator,, Location, Rotation);
	OwnedVolume.MineBase = self;
	
	rot = Rotation;
	rot.Pitch = 0;
	rot.Roll = 0;
	
	SetRotation(rot);
	OwnedVolume.SetRotation(rot);
}

event Destroyed()
{
	if (OwnedVolume != None)
		OwnedVolume.Destroy();
	
	Super.Destroyed();
}
