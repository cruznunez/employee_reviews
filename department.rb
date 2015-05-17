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
    if block_given?
      @employees.map{ |employee| !yield(employee) ? employees -= 1 : () }
      raise = dollars/employees
      @employees.map{ |employee| yield(employee) ? employee.give_raise(raise) : () }
    else
      @employees.map do |employee|
        !employee.keep? ? employees -= 1 : ()
      end
      raise = dollars/employees
      @employees.map do |employee|
        employee.keep? ? employee.give_raise(raise) : ()
      end
    end
  end
end
