using UnrealBuildTool;

public class SpaceKidsAliensAdventureServerTarget : TargetRules
{
	public SpaceKidsAliensAdventureServerTarget(TargetInfo Target) : base(Target)
	{
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
		Type = TargetType.Server;
		ExtraModuleNames.Add("SpaceKidsAliensAdventure");
	}
}
