require File.join(File.dirname(__FILE__), "../../config/require_all.rb")

class UserMailer < ApplicationMailer

  def reminder(object = {})
    @title = object["title"]
    @room_name = object["room"]["name"]
    @description = object["description"]
    @start_date =object["time_start"].to_datetime.strftime('%m-%d-%Y %H-%M')
    @end_date = object["time_end"].to_datetime.strftime('%m-%d-%Y %H-%M')
    user_email = object["user"]["email"]

    mail to: "#{user_email}", subject: "[Room Booking] Reminder - #{@title} will start in 10 minutes"
  end

end
