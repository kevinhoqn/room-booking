require 'sneakers'
require 'json'
require File.join(File.dirname(__FILE__), "../lib/mailer_service.rb")

class BookingEmailWorker
  include Sneakers::Worker
  from_queue ENV['EMAIL_AFTER_BOOKING_DESTINATION_QUEUE']

  def work(booking)
    puts "Sending email on Sneakers..."
    booking_params = JSON.parse(booking)
    MailerService.room_booking(booking_params)
    ack!
  end
end
