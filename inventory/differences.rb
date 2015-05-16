unless ARGV.length == 2
  puts "Usage: differences.rb old-inventory new-inventory"
  exit
end

def inventory_from(filename)
  File.open(filename).collect do | line |
    line.downcase
  end
end

old_inventory = inventory_from(ARGV[0])


new_inventory = inventory_from(ARGV[1])

x = (new_inventory - old_inventory).length

puts "The following #{x} files have been added:"
puts new_inventory - old_inventory

y = (old_inventory - new_inventory).length

puts ""
puts "The following #{y}  files have been deleted:"
puts old_inventory - new_inventory

x = new_inventory.length - y

puts ""
puts "Unchanged files: #{x} "
