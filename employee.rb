class Employee
  attr_reader :name, :emails, :phones, :salary
  def initialize(name: '', email: '', phone: '', salary: 50000, department: '')
    @name = name
    @emails = []
    @emails << email if email != ''
    @phones = []
    @phones << check_phone(phone) if phone != ''
    @phones.flatten!
    @salary = salary
    @no_department = true
    @department = nil
    if department != ''
      @department = Department.new(department.capitalize)
      @no_department = false
      @department.add_employee(self)
    end
  end

  def department
    @department.name
  end

  def add_phone(phone)
    phone = phone.to_s
    if phone.scan(/\d/).join.empty?
      return
    end
    @phones << check_phone(phone) if phone != ''
    @phones.flatten!
  end

  private def check_phone(other)
    valid_phones = []
    if other.class == Array
      other.map{|x| valid_phones << x if x.length>7}
    else
      valid_phones << other.to_s
    end
    valid_phones = valid_phones.map{|x| x.scan(/\d/).join}
    output = valid_phones.select{|x| x.length == 7 || x.length == 10}
  end

  def add_department(department)
    if department.class == String && @no_department
      @department = Department.new(department.capitalize)
      @no_department = false
      @department.add_employee(self)
    else return false
    end
  end
end
