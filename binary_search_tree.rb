
class Node
  attr_accessor :data, :left, :right
  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_reader :root
  def initialize(array)
    @array = array.uniq.sort
    @root = build_tree(@array)
  end
  def build_tree(array)
    return nil unless array.length > 0
    mid = array.length / 2
    return Node.new(array[mid], build_tree(array[0...mid]), build_tree(array[mid + 1...array.length]))
  end
  def insert(value)
    if @root == nil
      return @root = Node.new(value)
    end
    insert_rec(@root, value)
  end
  def delete(value)
    delete_rec(@root, value)
  end
  def find(value)
    find_rec(@root, value)
  end
  def level_order
    queue = []
    visited = []
    queue << @root
    while queue.length > 0
      node = queue.pop
      if block_given?
        visited << yield(node)
      else
        visited << node.data
      end
      queue << node.left if node.left
      queue << node.right if node.right
    end
    visited
  end
  def inorder(tree = @root, visited = [], &block)
    return if tree == nil
    inorder(tree.left, visited, &block)
    if block_given?
      visited << yield(tree)
    else
      visited << tree.data
    end
    inorder(tree.right, visited, &block)
    visited
  end
  def preorder(tree = @root, visited = [], &block)
    return if tree == nil
    if block_given?
      visited << yield(tree)
    else
      visited << tree.data
    end
    preorder(tree.left, visited, &block)
    preorder(tree.right, visited, &block)
    visited
  end
  def postorder(tree = @root, visited = [], &block)
    return if tree == nil
    postorder(tree.left, visited, &block)
    postorder(tree.right, visited, &block)
    if block_given?
      visited << yield(tree)
    else
      visited << tree.data
    end
    visited
  end
  def height(tree = @root, h = 0)
    return h if tree == nil
    [height(tree.left, h + 1), height(tree.right, h + 1)].max
  end
  def depth(value, tree = @root, d = 0)
    return if tree == nil
    return d if tree.data == value
    depth(value, tree.data > value ? tree.left : tree.right, d + 1)
  end
  def balanced?(tree = @root, h = 0)
    return true if tree == nil
    lh = height(tree.left)
    rh = height(tree.right)
    return (lh - rh).abs < 2 && balanced?(tree.left) && balanced?(tree.right) 
  end
  def rebalance
    @root = build_tree(inorder)
  end
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  private
  def insert_rec(root, value)
    if root == nil
      root = Node.new(value)
      return root
    end
    if value < root.data
      root.left = insert_rec(root.left, value)
    elsif value > root.data
      root.right = insert_rec(root.right, value)
    end
    root
  end
  def delete_rec(root, value)
    return root if root == nil
    if value < root.data
      root.left = delete_rec(root.left, value)
    elsif value > root.data
      root.right = delete_rec(root.right, value)
    else
      return root.right if root.left == nil 
      return root.left if root.right == nil

      root.data = min_value(root.right)
      root.right = delete_rec(root.right, root.data)
    end
  end
  def find_rec(root, value)
    return nil if root == nil
    if value < root.data
      return find_rec(root.left, value)
    elsif value > root.data
      return find_rec(root.right, value)
    end
    root
  end
  def min_value(root)
    min = root.data
    while root.left != nil
      min = root.data
      root = root.left
    end
    min
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })

puts "Is the tree balanced"
puts tree.balanced?

puts "Printing in different orders"
p tree.level_order { |n| n.data }
p tree.preorder { |n| n.data }
p tree.postorder { |n| n.data }
p tree.inorder { |n| n.data }

puts "Inserting numbers"
tree.insert(120)
tree.insert(125)
tree.insert(140)

puts "Is the tree balanced?"
puts tree.balanced?

puts "rebalancing"
tree.rebalance

puts "Is the tree balanced?"
puts tree.balanced?


puts "Printing in different orders"
p tree.level_order { |n| n.data }
p tree.preorder { |n| n.data }
p tree.postorder { |n| n.data }
p tree.inorder { |n| n.data }

puts "Here's the tree :)"
tree.pretty_print

# ruby binary_search_tree.rb
