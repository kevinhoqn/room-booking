class Api::V1::BookingsController < ApplicationController

  # before_action :find_room, only: [:create]
  before_action :find_booking, only: [:show, :destroy]

  # GET /bookings
  def index
    authorize ActsAsBookable::Booking
    json_response(current_user.bookings)
  end

    # GET /bookings/:id
  def show
    authorize @booking
    if @booking.present?
      json_response(@booking)
    else
      json_response({message: Message.not_found('Book')}, :not_found)
    end
  end

  # POST /bookings
  def create
    request_param

    authorize ActsAsBookable::Booking
    find_room
    booking = current_user.book! @room, convert_param.merge(amount: 1)

    json_response(booking)
  end

  # DELETE /bookings/:id
  def destroy
    authorize @booking
    @booking.destroy
    json_response( nil, :no_content)
  end

  private

  def book_params
    # whitelist params
    params.permit(:title, :description, :time_start, :time_end, :room_id)
  end

  def convert_param
    books = book_params.except(:room_id)
    books.each { |key, p| books[key] = p.to_datetime if [:time_start, :time_end].include? key.to_sym }
  end

  def find_room
    @room = Room.find(book_params[:room_id])
  end

  def find_booking
    @booking = current_user.bookings.where(id: params[:id]).first
  end

  def request_param
    param! :title, String, required: true
    param! :room_id, Integer, required: true
    param! :time_start, DateTime, required: true
    param! :time_end, DateTime, required: true
    param! :project_id, Integer
  end
end
