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
    assert_equal "name", Employee.new(name: "name").name
  end

  def test_employee_has_emails
    assert_equal ["email@example.com"], Employee.new(email:"email@example.com").emails
  end

  def test_employee_can_have_one_phone_number
    assert_equal ['1234567890'], Employee.new(phone: '1234567890').phones
  end

  def test_employee_can_have_multiple_phone_numbers_from_initialize
    employee = Employee.new(phone: ['918-374-9187', '029.398.2934', '384 0844'])
    assert_equal ['9183749187', '0293982934', '3840844'], employee.phones
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
    peon1 = Employee.new(name: "Mason", department: "shoe")
    peon2 = Employee.new(name: "Mathon")
    peon2.add_department("Hat")

    assert_equal "Shoe", peon1.department
    refute peon2.add_department("Bandage")
    assert_equal "Hat", peon2.department
  end

  def test_department_can_have_many_employees
    peon1 = Employee.new(name: "Jack", department: "shoe")
    peon2 = Employee.new(name: "Matt")
    peon2.add_department("Shoe")

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

  # def test_total_salary_for_a_single_department_2
  #   dept = Department.new("shoe")
  #   peon1 = Employee.new(name: "Jack")
  #   peon2 = Employee.new(name: "Jill")
  #   peon3 = Employee.new(name: "John", salary: 60000)
  #   dept.add_employee(peon1, peon2, peon3)
  #   assert_equal 160000, dept.salaries

  # end

end
