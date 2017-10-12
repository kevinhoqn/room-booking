class Booking <  ActsAsBookable::Booking
  validates_datetime :time_end, :after => :time_start
  validates_datetime :time_start, :on => :create, :on_or_after => lambda { Time.zone.now }
  before_create :reset_time_end

  after_create :generate_next_schedule, if: :daily?
  after_create :send_email unless Rails.env.test?
  after_destroy :remove_future_schedule, if: :daily?

  scope :by_room, ->(room_id) { where(bookable_id: room_id) }

  private

  def send_email
    PubsubService.new.publish_books_message(self)
  end

  def generate_next_schedule
    RoomBookingService.new(self, 7).call
  end

  def remove_future_schedule
    RoomBookingService.new(self).call
  end

  def reset_time_end
    self.time_end = self.time_end - 1.second
  end
end