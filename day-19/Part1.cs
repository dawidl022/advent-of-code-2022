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
            qualitySum += i * Simulation.MaxGeodeCount(blueprint, Robots.Initial(), Materials.Initial(), 24,
                new Dictionary<int, int>());
            i++;
        }

        Console.WriteLine(qualitySum);
    }
}