fun DirNode.calcSize(): Int {
    return children.fold(0) { size, node ->
        size + when (node) {
            is FileNode -> node.size
            is DirNode -> node.calcSize()
        }
    }
}

interface Node {
    val name: String
}

sealed interface DirNode : Node {
    val children: MutableList<NonRootNode>
}

sealed interface NonRootNode : Node

class RootNode(override val children: MutableList<NonRootNode>) : DirNode {
    override val name = "/"
}

class NonRootDirNode(
    val parent: DirNode,
    override val children: MutableList<NonRootNode>,
    override val name: String
) :
    DirNode, NonRootNode

class FileNode(val parent: DirNode, override val name: String, val size: Int) : NonRootNode
