unless ARGV.length == 2
  puts "Usage: differences.rb old-inventory new-inventory"
  exit
end

old_inventory = File.open(ARGV[0]).collect do | line |
  line.downcase
end

new_inventory = File.open(ARGV[1]).collect do | line |
  line.downcase
end

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
