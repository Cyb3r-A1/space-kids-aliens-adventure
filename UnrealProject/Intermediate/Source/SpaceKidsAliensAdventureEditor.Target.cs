using UnrealBuildTool;

public class SpaceKidsAliensAdventureEditorTarget : TargetRules
{
	public SpaceKidsAliensAdventureEditorTarget(TargetInfo Target) : base(Target)
	{
		DefaultBuildSettings = BuildSettingsVersion.Latest;
		IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
		Type = TargetType.Editor;
		ExtraModuleNames.Add("SpaceKidsAliensAdventure");
	}
}
