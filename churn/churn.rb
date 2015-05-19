#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---

# 1 Method that calculates the start date
def month_before(a_time) 
  a_time - 28 * 24 * 60 * 60
end

# 2 Method that prints the header
def header(a_date) 
  "Changes since #{a_date}:"
end

# 3 Method that prints the subsystem lines
def subsystem_line(subsystem_name, change_count)
  asterisks = asterisks_for(change_count)
#  subsystem_name.rjust(14) + ' ' + asterisks +
#   ' (' + change_count.inspect + ')'
  "#{subsystem_name.rjust(14)} #{asterisks} (#{change_count})"
end

#4 Method that returns the chain of asterisks given a number
def asterisks_for(an_integer)
  '*' * (an_integer / 5.0).round
end

#5 Get log info from SVN
def svn_log(subsystem, start_date)
  timespan = "-revision 'HEAD:{#{start_date}}'"
  root = "svn://rubyforge.org//var/svn/churn-demo"
  `svn log #{timespan} #{root}/#{subsystem}`
end

#6 Get log info from git
def git_log(directory)
  `git log --since="28 days ago" --stat --oneline -- --relative= ../#{directory}`
end

def git_change_count_for(directory)
  extract_change_count_from_git_log(git_log(directory))
end

#Extract Change Count from git log
def extract_change_count_from_git_log(log_text)
  lines = log_text.split("\n" )
  change_lines=lines.find_all do | line |
    line.include?('changed')
  end
  change_lines.length
end

def change_count_for(name, start_date)
  extract_change_count_from(svn_log(name, start_date))
end

def extract_change_count_from_svn_log(log_text)
  lines = log_text.split("\n" )
  dashed_lines = lines.find_all do | line |
    line.include?('-----' )
  end
  dashed_lines.length - 1
end

def svn_date(a_time)
  a_time.strftime("%Y-%m-%d")
end
if $0 == __FILE__    #(1)
  #~ subsystem_names = ['audit', 'fulfillment', 'persistence',    #(2)
                     #~ 'ui', 'util', 'inventory']
  #~ start_date = month_before(Time.now)       #(3)



  #~ puts header(start_date)                   #(4)
  #~ subsystem_names.each do | name |
    #~ puts subsystem_line(name, change_count_for(name)) #(5)  
  #~ end
  directory_names = ["churn", "inventory","affinity-trip"]
  start_date = svn_date(Time.now)
  puts header(start_date)  
  directory_names.each do | name |
    puts subsystem_line(name, git_change_count_for(name))
  end
end
