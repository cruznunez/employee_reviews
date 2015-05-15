class Department
  attr_reader :name
  def initialize(name)
    @name = name
    @employees = []
  end

  def add_employee(*employee)
    if employee.length > 1
      employee.map do |x|
        @employees << x
        x.add_department(self)
      end
    else
      @employees<<employee
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
end
