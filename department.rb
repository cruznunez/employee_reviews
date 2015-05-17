class Department
  attr_reader :name
  def initialize(name)
    @name = name.capitalize
    @employees = []
  end

  def add_employee(*employee)
    if employee.length > 1
      employee.map do |x|
        @employees << x
        x.add_department(self)
      end
    else
      @employees<<employee[0]
      employee[0].add_department(self)
    end
    @employees.flatten!
  end

  def salaries
    if @employees.length == 0
      false
    else
      @employees.inject(0){|sum, n| sum + n.salary}
    end
  end

  def give_raises(dollars)
    employees = @employees.length
    @employees.map do |employee|
      if employee.bad_reviews.length > employee.good_reviews.length
        employees -= 1
      end
    end
    raise = dollars/employees
    @employees.map do |employee|
      if employee.good_reviews.length > employee.bad_reviews.length
        employee.give_raise(raise)
      end
    end
  end
end
