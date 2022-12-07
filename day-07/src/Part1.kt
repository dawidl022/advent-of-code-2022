fun main() {
    val (instructions, listings) = parseInput()
    val tree = buildTree(instructions, listings)
    val result = sumDirectorySizes(tree, maxDirectorySize = 100000)
    println(result)
}

fun sumDirectorySizes(root: DirNode, maxDirectorySize: Int): Int {
    return root.calcSize()
        .let { if (it <= maxDirectorySize) it else 0 } + root.children
        .filter { it is DirNode }
        .fold(0) { size, dir ->
            size + sumDirectorySizes(dir as NonRootDirNode, maxDirectorySize)
        }
}
