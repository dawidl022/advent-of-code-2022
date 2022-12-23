public class Part2 : IChallengePart
{
    public void Solve()
    {
        int qualityProduct = 1;
        string? line;
        int i = 1;
        while (i <= 3 && (line = Console.In.ReadLine()) != null)
        {
            var blueprint = Blueprint.FromString(line);
            qualityProduct *= Simulation.MaxGeodeCount(blueprint, Robots.Initial(), Materials.Initial(), 32,
                new Dictionary<int, int>());
            i++;
        }

        Console.WriteLine(qualityProduct);
    }
}