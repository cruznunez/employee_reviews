require 'minitest/autorun'
require 'minitest/pride'

#Note: This line is going to fail first.
require './employee.rb'
require './department.rb'
require "byebug"

$mock_inputs = []
def get_user_input
  $mock_inputs.shift
end

class EmployeeReviewTest < Minitest::Test

  def test_department_and_employee_classes_exits
    assert Department
    assert Employee
  end

  def test_employee_has_name
    assert_equal "Name", Employee.new(name: "name").name
  end

  def test_employee_has_emails
    assert_equal ["email@example.com"], Employee.new(email:"email@example.com").emails
  end

  def test_employee_can_have_one_phone_number
    assert_equal ['1234567890'], Employee.new(phone: '1234567890').phones
  end

  def test_employee_can_have_multiple_phone_numbers_from_initialize
    employee = Employee.new(phone: ['918-374-9187', '029.398.2934', '384 0844'])
    assert_equal ['9183749187', '0293982934', "3840844"], employee.phones
  end

  def test_employee_can_have_multiple_phone_numbers_from_add_phone_method
    employee = Employee.new(phone: '918-374-9187')
    employee.add_phone('029.398.2934')
    employee.add_phone('092 384 0844')
    employee.add_phone(5982340928)
    employee.add_phone("yooooo what's good?")
    assert_equal ['9183749187', '0293982934', '0923840844', '5982340928'], employee.phones
  end

  def test_employee_has_real_phone_numbers
    employee = Employee.new(phone: ['8', '990-376-233', '918-374-9187',
    'testing_1_2_3', '029.398.2934', '092 384 0844'])

    assert_equal ['9183749187', '0293982934', '0923840844'], employee.phones
  end

  def test_employee_has_salary
    assert Employee.new.salary
    dude = Employee.new(salary: 10000000000)
    assert_equal 10000000000, dude.salary
  end

  def test_department_has_name
    dept = Department.new("Food")
    assert_equal "Food", dept.name
  end

  def test_employee_can_belong_to_one_department
    peon1 = Employee.new(name: "Mason")
    peon2 = Employee.new(name: "Mathan")
    shoe_department = Department.new("shoe")
    hat_department = Department.new("Hat")
    shoe_department.add_employee(peon1)
    hat_department.add_employee(peon2)

    assert_equal "Shoe", peon1.department
    assert_equal "Hat", peon2.department
  end

  def test_department_can_have_many_employees
    peon1 = Employee.new(name: "Jack")
    peon2 = Employee.new(name: "Matt")

    department = Department.new('shoe')
    department.add_employee(peon1, peon2)

    assert_equal "Shoe", peon1.department
    assert_equal "Shoe", peon2.department
    assert_equal peon1.department, peon2.department
  end

  def test_total_salary_for_a_single_department
    dept = Department.new("shoe")
    peon = Employee.new(name: "Jack")
    dept.add_employee(peon)
    assert_equal 50000, dept.salaries
  end

  def test_total_salary_for_a_single_department_2
    dept = Department.new("shoe")
    peon1 = Employee.new(name: "Jack")
    peon2 = Employee.new(name: "Jill")
    peon3 = Employee.new(name: "John", salary: 60000)
    dept.add_employee(peon1, peon2, peon3)
    assert_equal 160000, dept.salaries
  end

  def review1
    {'monday' => "Joe is a good kid."}
  end

  def test_employee_can_have_reviews
    peon = Employee.new(name: "Joe", review: review1)
    assert peon.reviews
    assert_equal ["Joe is a good kid."], peon.reviews
    peon.add_review(review2)
    assert_equal ["Joe is a good kid.", "Joe spilled some milk today."], peon.reviews
    peon.add_review(review3)
    assert_equal ["Joe is a good kid.", "Joe spilled some milk today.", "Joe is a boss!"], peon.reviews
  end

  def review2
    {'tuesday' => "Joe spilled some milk today."}
  end

  def review3
    {'tuesday' => "Joe is a boss!"}
  end

  def test_reviews_can_have_dates
    peon = Employee.new(name: "Joe", review: review1)
    assert_equal "Joe is a good kid.", peon.review("monday")
  end

  def good_review
    {"monday" => 'Joe is a great worker. He likes engaging with others in'\
    ' conversation. He does not mind getting things for the customer. I bet he'\
    ' has a good relationship with his mother. I think he will go far in this'\
    ' business. Keep up the good work, Joe.'
    }
  end

  def test_review_can_be_good
    peon = Employee.new(name: "Joe", review: good_review)
    assert_equal good_review.values, peon.good_reviews
    peon.add_review(review1)
    assert_equal [good_review.values, review1.values].flatten, peon.good_reviews
  end

  def bad_review
    {"wednesday" => "Uhhh. Joe is a meanie. So today I asked him if they had a"\
      " certain shoe in other sizes. He said they were out of size 18. What a"\
      " jerk! Someone fire this clown. Zero out of ten, would not come again."
    }
  end

  def test_review_can_be_bad
    peon = Employee.new(name: "Joe", review: bad_review)
    assert_equal bad_review.values, peon.bad_reviews
  end

  def test_employee_gets_raise
    peon = Employee.new(name: "Cruz", salary: 40000)
    peon.give_raise(960000)
    assert_equal 1000000, peon.salary
  end

  def cruz_review
    {"Monday" => "Fire this kid right now. This guy said my feet stink! I mean"\
      " he's not lying, but then he said even the men's room smells"\
      " better! He's still right, but I mean that last part was uncalled for..."}
  end

  def chris_review
    {"Tuesday" =>"Can someone say employee of the year?! This guy. Whooo!"\
      " I kid you not, I was two steps into the store when he came up and"\
      " shook my hand, and took me to the shoes, grabbed a box, said here"\
      ", and sent me to checkout. All in under a minute! That's quick service."}
  end

  def bob_review
    {"Wednesday" => "Meh. Bob is kinda a weirdo but he did his stuff alright. At least"\
      " he's better than Cruz. Boy, that guy was mean. Bob's a good kid."}
  end

  def test_department_gets_raise
    cruz = Employee.new(name: "cruz", salary: 50000)
    chris = Employee.new(name: "chris", salary: 50000)
    bob = Employee.new(name: "bob", salary: 50000)
    department = Department.new("Shoe")
    department.add_employee(cruz, chris, bob)
    cruz.add_review(cruz_review)
    chris.add_review(chris_review)
    bob.add_review(bob_review)
    department.give_raises(100000)
    assert_equal 50000, cruz.salary
    assert_equal 100000, chris.salary
    assert_equal 100000, bob.salary
  end

  # def test_pathological
  #
  # end

  def test_give_raises_to_department_with_block
    cruz = Employee.new(name: "cruz", salary: 100000)
    chris = Employee.new(name: "chris", salary: 101000)
    bob = Employee.new(name: "bob", salary: 99000)
    department = Department.new("Shoe")
    department.add_employee(cruz, chris, bob)
    cruz.add_review(cruz_review)
    chris.add_review(chris_review)
    bob.add_review(bob_review)

    department.give_raises(5000) do |employee|
      employee.salary < 100000
    end

    assert_equal 100000, cruz.salary
    assert_equal 101000, chris.salary
    assert_equal 104000, bob.salary
  end

  def negative_review_1
    {"Monday" =>

      "Zeke is a very positive person and encourages those around him, but he"\
      " has not done well technically this year. There are two areas in which"\
      " Zeke has room for improvement. First, when communicating verbally (and"\
      " sometimes in writing), he has a tendency to use more words than are"\
      " required. This conversational style does put people at ease, which is"\
      " valuable, but it often makes the meaning difficult to isolate, and can"\
      " cause confusion. Second, when discussing new requirements with project"\
      " managers, less of the information is retained by Zeke long-term than"\
      " is expected. This has a few negative consequences: 1) time is spent"\
      " developing features that are not useful and need to be re-run, 2) bugs"\
      " are introduced in the code and not caught because the tests lack the"\
      " same information, and 3) clients are told that certain features are"\
      " complete when they are inadequate.  This communication limitation could"\
      " be the fault of project management, but given that other developers"\
      " appear to retain more information, this is worth discussing further."
    }
  end


  def negative_review_2
    {"Tuesday" =>

      "Thus far, there have been two concerns over Yvonne's performance, and both"\
      " have been discussed with her in internal meetings. First, in some cases,"\
      " Yvonne takes longer to complete tasks than would normally be expected."\
      " This most commonly manifests during development on existing applications,"\
      " but can sometimes occur during development on new projects, often during"\
      " tasks shared with Andrew. In order to accommodate for these preferences,"\
      " Yvonne has been putting more time into fewer projects, which has gone well."\
      " Second, while in conversation, Yvonne has a tendency to interrupt, talk"\
      " over others, and increase her volume when in disagreement.  In client"\
      " meetings, she also can dwell on potential issues even if the client or"\
      " other attendees have clearly ruled the issue out, and can sometimes get"\
      " off topic."
    }
  end


  def positive_review_1
    {"Wednesday" =>

      "Xavier is a huge asset to SciMed and is a pleasure to work with. He"\
      " quickly knocks out tasks assigned to him, implements code that rarely"\
      " needs to be revisited, and is always willing to help others despite his"\
      " heavy workload. When Xavier leaves on vacation, everyone wishes he"\
      " didn't have to go. Last year, the only concerns with Xavier performance"\
      " were around ownership. In the past twelve months, he has successfully"\
      " taken full ownership of both Acme and Bricks, Inc.  Aside from some false"\
      " starts with estimates on Acme, clients are happy with his work and"\
      " responsiveness, which is everything that his managers could ask for."
    }
  end

  def positive_review_2
    {"Thursday" =>
      "Wanda has been an incredibly consistent and effective developer. Clients"\
      " are always satisfied with her work, developers are impressed with her"\
      " productivity, and she's more than willing to help others even when she"\
      " has a substantial workload of her own. She is a great asset to Awesome"\
      " Company, and everyone enjoys working with her. During the past year, she"\
      " has largely been devoted to work with the Cement Company, and she is the"\
      " perfect woman for the job. We know that work on a single project can"\
      " become monotonous, however, so over the next few months, we hope to"\
      " spread some of the Cement Company work to others. This will also allow"\
      " Wanda to pair more with others and spread her effectiveness to other projects."
    }
  end


  def test_employee_can_perform_satisfactorily
    zeke = Employee.new(name: "zeke")
    yvonne = Employee.new(name: "yvonne")
    xavier = Employee.new(name: "xavier")
    wanda = Employee.new(name: "wanda")

    zeke.add_review(negative_review_1)
    yvonne.add_review(negative_review_2)
    xavier.add_review(positive_review_1)
    wanda.add_review(positive_review_2)

    refute zeke.keep?
    refute yvonne.keep?
    assert xavier.keep?
    assert wanda.keep?
  end

end
