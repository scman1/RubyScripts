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
def header(start_date,end_date) 
  "Changes between #{start_date} and #{end_date}:"
end

# 3 Method that prints the subsystem lines
def subsystem_line(subsystem_name, change_count)
  asterisks = asterisks_for(change_count)
#  subsystem_name.rjust(14) + ' ' + asterisks +
#   ' (' + change_count.inspect + ')'
  if change_count>0 
    "#{subsystem_name.ljust(24)}#{("("+change_count.to_s+" changes)").ljust(14)}#{asterisks}"
  else
    "#{subsystem_name.ljust(24)}#{"-".ljust(14)}#{asterisks}"
  end	  
end

#4 Method that returns the chain of asterisks given a number
def asterisks_for(an_integer)
  an_integer > 2 ? '*' * (an_integer / 5.0).round : '-'
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
# 8 fix blunder 1
def svn_date(a_time)
  a_time.strftime("%Y-%m-%d")
end

# 9 fix blunder 2

# 9.1 use regular expression to extract change number
def churn_line_to_int(line)
  #/\((\d+)\)/.match(line)[1].to_i
   match=/\((\d+) /.match(line)
   match==nil ? 0 : match[1].to_i
end

# 9.2 use spaceship operator to order based on change number
def order_by_descending_change_count(lines)
  lines.sort do | one, another |
    one_count = churn_line_to_int(one)
    another_count = churn_line_to_int(another)
    - (one_count <=> another_count)
  end
end

if $0 == __FILE__    #(1)
  #~ subsystem_names = ['audit', 'fulfillment', 'persistence',    #(2)
                     #~ 'ui', 'util', 'inventory']
  #~ start_date = month_before(Time.now)       #(3)
  #~ puts header(start_date)                   #(4)
  #~ subsystem_names.each do | name |
    #~ puts subsystem_line(name, change_count_for(name)) #(5)  
  #~ end
  directory_names = ["affinity-trip",   "exercise-solutions", "user-choices",
"arglist-facts",  "if-facts", "watchdog",  "churn", "inheritance",  "s4t-affinity-trip",
"clash-check",     "inventory", "s4t-utils", "class-facts", "module-facts", 
"scraping-alternatives"]
  start_date = svn_date(month_before(Time.now))
  end_date=svn_date(Time.now)
  puts header(start_date,end_date)  
  lines = directory_names.collect do | name |
    subsystem_line(name, git_change_count_for(name))
  end
  puts order_by_descending_change_count(lines)
end
