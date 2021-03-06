# create usage method
def check_usage 
  unless ARGV.length == 2
    puts "Usage: differences.rb old-inventory new-inventory"
    exit
  end
end

def inventory_from(filename)
  # open the file
  inventory=File.open(filename)
  # convert to lowercase and delete trailing \n
  downcased=inventory.collect do | line |
    line.downcase
  end
  # reject all filenames containing temp and recycler
  downcased.reject do | line |
    boring?(line, ["temp","recycler"]) #changes for excercise 5.5
  end    
end

# Check if line can be ignored
# Excercise 5.2 change chomp to boring
def boring?(line)
  contains?(line, 'temp' ) or contains?(line, 'recycler' )
end

def boring?(line,boring_words)
  boring_words.any? do |a_boring_word|
    contains?(line,a_boring_word)
  end
end


# Excercise 5.3 move include to a method
  def contains?(line, string)
     line.chomp.split('/' ).include?(string)
  end
  
# create method for comparing directories
def compare_inventory_files(old_file, new_file)
  old_inventory = inventory_from(old_file)


  new_inventory = inventory_from(new_file)

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
end

# Check if the script is being run from the command or irb
# if command line try to run script else do nothing

if $0 == __FILE__
  check_usage
  compare_inventory_files(ARGV[0], ARGV[1])
end	
