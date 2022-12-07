fun buildTree(instructions: List<Instruction>, listings: List<List<Listing>>): RootNode {
    val root = RootNode(children = mutableListOf())

    var current: DirNode = root
    var listingIndex = 0

    for (inst in instructions) {
        when (inst) {
            is DirInstruction -> current = current.traverseTo(inst.target, root)
            is ListInstruction -> {
                current.addChildren(listings[listingIndex])
                listingIndex++
            }
        }
    }
    return root
}

private fun DirNode.addChildren(listings: List<Listing>) {
    for (listing in listings) {
        children.firstOrNull { it.name == listing.name } ?: when (listing) {
            is DirListing -> {
                children.add(
                    NonRootDirNode(
                        parent = this,
                        children = mutableListOf(),
                        name = listing.name
                    )
                )
            }
            is FileListing -> {
                children.add(
                    FileNode(
                        parent = this,
                        name = listing.name,
                        size = listing.size
                    )
                )
            }
        }
    }
}

private fun DirNode.traverseTo(target: String, root: RootNode): DirNode {
    if (target == "/") {
        return root
    }

    return if (target == "..") {
        (this as NonRootDirNode).parent
    } else {
        (
                children.firstOrNull { it.name == target } ?: run {
                    val newChild = NonRootDirNode(
                        name = target,
                        children = mutableListOf(),
                        parent = this
                    )
                    children.add(newChild)
                    newChild
                }
                ) as DirNode
    }
}
