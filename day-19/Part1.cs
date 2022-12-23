using System.Text.RegularExpressions;

public class Part1 : IChallengePart
{
    public void Solve()
    {
        int qualitySum = 0;
        string? line;
        int i = 1;
        while ((line = Console.In.ReadLine()) != null)
        {
            var blueprint = Blueprint.FromString(line);
            qualitySum += i * MaxGeodeCount(blueprint, Robots.Initial(), Materials.Initial(), 24,
                new Dictionary<MemoEntry, int>());
            i++;
        }

        Console.WriteLine(qualitySum);
    }

    private static int MaxGeodeCount(Blueprint blueprint, Robots robots, Materials inventory, int timeRemaining,
        Dictionary<MemoEntry, int> memo)
    {
        var memoEntry = new MemoEntry(robots, inventory, timeRemaining);
        if (memo.TryGetValue(memoEntry, out int value))
        {
            return value;
        }

        if (timeRemaining == 0)
        {
            memo[memoEntry] = 0;
            return 0;
        }

        Materials newInventory = new Materials(
            Ore: inventory.Ore + robots.OreRobotCount,
            Clay: inventory.Clay + robots.ClayRobotCount,
            Obsidian: inventory.Obsidian + robots.ObsidianRobotCount
        );

        int withGeodeRobot = 0;
        int withObsidianRobot = 0;
        int withClayRobot = 0;
        int withOreRobot = 0;

        if (inventory.CanAfford(blueprint.GeodeRobotCost))
        {
            withGeodeRobot = MaxGeodeCount(
                blueprint,
                robots.PlusGeode(),
                newInventory - blueprint.GeodeRobotCost,
                timeRemaining - 1,
                memo
            );
        }

        if (inventory.CanAfford(blueprint.ObsidianRobotCost))
        {
            withObsidianRobot = MaxGeodeCount(
                blueprint,
                robots.PlusObsidian(),
                newInventory - blueprint.ObsidianRobotCost,
                timeRemaining - 1,
                memo
            );
        }

        if (inventory.CanAfford(blueprint.ClayRobotCost))
        {
            withClayRobot = MaxGeodeCount(
                blueprint,
                robots.PlusClay(),
                newInventory - blueprint.ClayRobotCost,
                timeRemaining - 1,
                memo
            );
        }

        if (inventory.CanAfford(blueprint.OreRobotCost))
        {
            withOreRobot = MaxGeodeCount(
                blueprint,
                robots.PlusOre(),
                newInventory - blueprint.OreRobotCost,
                timeRemaining - 1,
                memo
            );
        }

        int withNoRobot = MaxGeodeCount(
            blueprint,
            robots,
            newInventory,
            timeRemaining - 1,
            memo
        );

        var result = robots.GeodeRobotCount + new[]
            { withGeodeRobot, withObsidianRobot, withClayRobot, withOreRobot, withNoRobot }.Max();
        memo[memoEntry] = result;
        return result;
    }

    private record MemoEntry(Robots Robots, Materials Inventory, int TimeRemaining);
}

public record Robots(int OreRobotCount, int ClayRobotCount, int ObsidianRobotCount, int GeodeRobotCount)
{
    public static Robots Initial()
    {
        return new Robots(1, 0, 0, 0);
    }

    public Robots PlusOre()
    {
        return this with { OreRobotCount = OreRobotCount + 1 };
    }

    public Robots PlusClay()
    {
        return this with { ClayRobotCount = ClayRobotCount + 1 };
    }

    public Robots PlusObsidian()
    {
        return this with { ObsidianRobotCount = ObsidianRobotCount + 1 };
    }

    public Robots PlusGeode()
    {
        return this with { GeodeRobotCount = GeodeRobotCount + 1 };
    }
}

public record Materials(int Ore, int Clay, int Obsidian)
{
    private class MaterialSpec
    {
        public int Count { get; }
        public string Type { get; }

        private MaterialSpec(int count, string type)
        {
            Count = count;
            Type = type;
        }

        public static MaterialSpec FromString(string source)
        {
            string[] spec = source.Split(" ");
            return new MaterialSpec(int.Parse(spec[0]), spec[1]);
        }
    }

    public static Materials FromString(string source)
    {
        string[] mats = source.Split(" and ");
        int ore = 0;
        int clay = 0;
        int obsidian = 0;
        foreach (string mat in mats)
        {
            MaterialSpec spec = MaterialSpec.FromString(mat);
            switch (spec.Type)
            {
                case "ore":
                    ore += spec.Count;
                    break;
                case "clay":
                    clay += spec.Count;
                    break;
                case "obsidian":
                    obsidian += spec.Count;
                    break;
                default:
                    throw new Exception("Unexpected material type");
            }
        }

        return new Materials(Ore: ore, Clay: clay, Obsidian: obsidian);
    }

    public static Materials Initial()
    {
        return new Materials(0, 0, 0);
    }

    public bool CanAfford(Materials other)
    {
        return Ore >= other.Ore && Clay >= other.Clay && Obsidian >= other.Obsidian;
    }

    public static Materials operator +(Materials a, Materials b)
    {
        return new Materials(Ore: a.Ore + b.Ore, Clay: a.Clay + b.Clay, Obsidian: a.Obsidian + b.Obsidian);
    }

    public static Materials operator -(Materials a, Materials b)
    {
        return a + new Materials(Ore: -b.Ore, Clay: -b.Clay, Obsidian: -b.Obsidian);
    }
}

public partial class Blueprint
{
    public Materials OreRobotCost { get; }
    public Materials ClayRobotCost { get; }
    public Materials ObsidianRobotCost { get; }
    public Materials GeodeRobotCost { get; }

    private Blueprint(Materials oreCost, Materials clayCost, Materials obsidianCost, Materials geodeCost)
    {
        OreRobotCost = oreCost;
        ClayRobotCost = clayCost;
        ObsidianRobotCost = obsidianCost;
        GeodeRobotCost = geodeCost;
    }

    public static Blueprint FromString(string source)
    {
        GroupCollection robotGroups = Expression().Match(source).Groups;
        return new Blueprint(
            oreCost: Materials.FromString(robotGroups[1].Value),
            clayCost: Materials.FromString(robotGroups[2].Value),
            obsidianCost: Materials.FromString(robotGroups[3].Value),
            geodeCost: Materials.FromString(robotGroups[4].Value)
        );
    }

    [GeneratedRegex(
        "Blueprint [0-9]+: Each ore robot costs (.*)\\. Each clay robot costs (.*)\\. Each obsidian robot costs (.*)\\. Each geode robot costs (.*)\\.")]
    private static partial Regex Expression();
}