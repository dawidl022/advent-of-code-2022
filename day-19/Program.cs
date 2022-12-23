public class Program
{
    public static void Main(string[] args)
    {
        if (args.Length < 1)
        {
            System.Console.WriteLine("Specify \"part1\" or \"part2\" as command line argument");
            System.Environment.Exit(1);
        }
        IChallengePart part = args[0] == "part2" ? new Part2() : new Part1();
        part.Solve();
    }
}

public interface IChallengePart
{
    public void Solve();
}
