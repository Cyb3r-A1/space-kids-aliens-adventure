using UnrealBuildTool;

public class SpaceKidsAliensAdventureClientTarget : TargetRules
{
	public SpaceKidsAliensAdventureClientTarget(TargetInfo Target) : base(Target)
	{
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
		Type = TargetType.Client;
		ExtraModuleNames.Add("SpaceKidsAliensAdventure");
	}
}
