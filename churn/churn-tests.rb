#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---
require 'test/unit' 
require_relative 'churn'     


class ChurnTests < Test::Unit::TestCase 

  # test formatting of subsystem lines
  def test_normal_subsystem_line_format
    assert_equal('         audit ********* (45)' ,
                         subsystem_line("audit" , 45))
  end

  # Bootstraped test including more than one method in the test
  def test_month_before_is_28_days_bootstraped
    assert_equal(Time.local(2015, 1, 1),
                 month_before(Time.local(2015, 1, 29)))
  end

  # Direct test including only the method being tested
  def test_month_before_is_28_days_direct
    assert_equal("Changes since 2015-04-15:" ,
    header(Time.local(2015, 4, 15)))
  end
  
  def test_asterisks_for_divides_by_five
    assert_equal('****' , asterisks_for(20))
    assert_equal('****' , asterisks_for(18))
    assert_equal('***' , asterisks_for(17))
  end
  
  def test_subversion_log_can_have_no_changes
    assert_equal(0, extract_change_count_from_svn_log("-------------------------\
      -----------------------------\n"))
  end

  def test_subversion_log_with_changes
    assert_equal(2, extract_change_count_from_svn_log("-------------------------\
      ------------------------------=----------\nr2531 | bem | 2005-07-01 01:1\
      1:44 -0500 (Fri, 01 Jul 2005) | 1 line\n\nrevisions up through ch 3 exer\
      cises\n---------------------------------=-------------------------------\
      -\nr2524 | bem | 2005-06-30 18:45:59 -0500 (Thu, 30 Jun 2005) | 1 line\n\
      \nresults of read-through; including renaming mistyping to snapshots\n--\
      -------------------------------------------\n"))
end

  def test_header_format
    assert_equal("Changes since 2015-04-15:" ,
    header(month_before(Time.local(2015, 5, 13))))
  end
end
