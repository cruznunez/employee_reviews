class Department
  attr_reader :name
  def initialize(name)
    @name = name
    @employees = []
  end

  def add_employee(*employee)
    if employee.length > 1
      employee.map{|x| @employees<<x;x.add_department(self)}
    else
      @employees<<employee
    end
    # @employees << employee
    @employees = @employees.flatten(1)
  end

  def salaries
    if @employees.length == 0
      false
    elsif @employees.length == 1
      @employees[0].salary
    else
      @employees.reduce{|sum, n| (sum.salary) + (n.salary)}
    end
  end
end
