unless ARGV.length == 2
  puts "Usage: differences.rb old-inventory new-inventory"
  exit
end

def inventory_from(filename)
  # open the file
  inventory=File.open(filename)
  # convert to lowercase and delete trailing \n
  downcased=inventory.collect do | line |
    line.chomp.downcase
  end
  # reject all filenames containing temp and recycler
  downcased.reject do | line |
    boring?(line)
  end    
end

def boring?(line)
  line.split('/' ).include?('temp' ) or
  line.split('/' ).include?('recycler' )
end

old_inventory = inventory_from(ARGV[0])


new_inventory = inventory_from(ARGV[1])

x = (new_inventory - old_inventory).length
# Excercise: add number of added files
puts "The following #{x} file(s) have been added:"
puts new_inventory - old_inventory

y = (old_inventory - new_inventory).length

puts ""
# Excercise: add number of deleted files
puts "The following #{y}  file(s) have been deleted:"
puts old_inventory - new_inventory

x = new_inventory.length - x

y = old_inventory.length - y 

puts ""
# Excercise: add number of unchanged files
puts "Unchanged files: #{x} "
puts "Verification of unchanged files: #{y} "