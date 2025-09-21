using UnrealBuildTool;

public class SpaceKidsAliensAdventureTarget : TargetRules
{
	public SpaceKidsAliensAdventureTarget(TargetInfo Target) : base(Target)
	{
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
		Type = TargetType.Game;
		ExtraModuleNames.Add("SpaceKidsAliensAdventure");
	}
}
