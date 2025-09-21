using UnrealBuildTool;

public class SpaceKidsAliensAdventure : ModuleRules
{
	public SpaceKidsAliensAdventure(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PrivateDependencyModuleNames.Add("Core");
		PrivateDependencyModuleNames.Add("Core");
	}
}
