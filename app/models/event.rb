class Event
  include Mongoid::Document
  include Mongoid::Extensions::Hash::IndifferentAccess
  include Mongoid::Timestamps::Created

  field :name, type: String
  field :total_bill, type: Integer
  field :start_time, type: DateTime
  field :status, type: String, default: 'upcoming'

  belongs_to :owner, class_name: 'User'
  has_many :rsvps, dependent: :destroy
  has_many :bills

  validates :status, inclusion: { in: %w(upcoming ended), message: "%{value} is not a valid status" }

  def sum_all_bills
    self.bills.pluck(:total).inject(:+)
  end

  def bill_for_user
    total_attendance = self.rsvps.count
    if total_attendance >= 1 && self.total_bill
      self.total_bill / total_attendance
    end
  end
end
