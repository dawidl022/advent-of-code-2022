fun parseInput(): Pair<List<Instruction>, List<List<Listing>>> {
    val instructions = mutableListOf<Instruction>()
    val listings = mutableListOf<List<Listing>>()

    val currentListing = mutableListOf<Listing>()
    var isListing = false

    while (true) {
        val line = try {
            readln()
        } catch (e: RuntimeException) {
            if (isListing) {
                listings.add(currentListing.map { it })
            }
            break
        }

        val tokens = line.split(" ")

        if (tokens.first() == "$") {
            if (isListing) {
                listings.add(currentListing.map { it })
                currentListing.clear()
            }
            when (tokens[1]) {
                "ls" -> {
                    instructions.add(ListInstruction)
                    isListing = true
                }
                "cd" -> {
                    instructions.add(DirInstruction(tokens[2]))
                    isListing = false
                }
            }
        } else {
            when (tokens[0]) {
                "dir" -> currentListing.add(DirListing(tokens[1]))
                else -> currentListing.add(
                    FileListing(
                        size = Integer.parseInt(tokens[0]),
                        name = tokens[1]
                    )
                )
            }
        }
    }
    return Pair(instructions, listings)
}

sealed interface Instruction

object ListInstruction : Instruction

data class DirInstruction(val target: String) : Instruction

sealed interface Listing {
    val name: String
}

data class FileListing(val size: Int, override val name: String) : Listing

data class DirListing(override val name: String) : Listing
