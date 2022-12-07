fun main() {
    val (instructions, listings) = parseInput()
    val tree = buildTree(instructions, listings)
    val result = findSizeOfDirToDelete(tree, totalSpace = 70000000, neededSpace = 30000000)
    println(result)
}

fun findSizeOfDirToDelete(root: DirNode, totalSpace: Int, neededSpace: Int): Int {
    val totalUsed = root.calcSize()
    val target = totalSpace - neededSpace
    val deficiency = totalUsed - target

    return findDirDeletionCandidates(root, deficiency)
        .minBy { it.calcSize() }
        .calcSize()
}

fun findDirDeletionCandidates(root: DirNode, minimumSize: Int): List<DirNode> {
    val dirs = mutableListOf<DirNode>()

    if (root.calcSize() >= minimumSize) {
        dirs.add(root)
    }

    root.children.filter { it is DirNode }.forEach {
        dirs.addAll(findDirDeletionCandidates(it as DirNode, minimumSize))
    }
    return dirs
}
