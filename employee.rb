class Employee
  attr_reader :name, :emails, :phones, :salary, :good_reviews, :bad_reviews

  def initialize(name: '', email: '', phone: '', salary: 50000, department: '', review: '')
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
    @reviews = {}
    @good_reviews = []
    @bad_reviews = []
    add_review(review)
  end

  def department
    @department.name
    # puts @department
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
    if @department == nil
      @department = department
      @no_department = false
    else return false
    end
  end

  def reviews
    @reviews.values.flatten
  end

  def add_review(review)
    if review != '' && review.class == Hash
      @reviews.merge!(review){|key, oldval, newval| ([oldval]<<newval).flatten}
      rate_review(review)
    end
  end

  def review(key)
    @reviews[key]
  end

  private def rate_review(review)
    string = review.values[0]
    good_words = string.scan(/good|great|quick service|good kid/i)
    bad_words = string.scan(/bad|terrible|jerk|fire/i)
    if good_words.length > bad_words.length
      @good_reviews << string
    elsif good_words.length < bad_words.length
      @bad_reviews << string
    end
  end

  def give_raise(dollars)
    @salary += dollars
  end
end
