module Api
  module V1
    class ReportsController < ApplicationController
      swagger_controller :report, "Filter the reporting"

      # GET reports?
      # :nocov:
      swagger_api :index do
        summary "Fetches all Rooms Booking in the range time"
        param :query, :room_id, :integer, :optional, "Room Id"
        param :query, :time_start, :DateTime, :required, "Time Start"
        param :query, :time_end, :DateTime, :required, "Time End"
        response :ok, "Success", :Room
        response :unauthorized
      end
      # :nocov:
      def index
        authorize self

        param! :page, Integer
        param! :room_id, Integer, required: false
        param! :time_start, DateTime, required: true
        param! :time_end, DateTime, required: true

        room_bookings = ReportService.range_date(params)

        render json: {
          data:
            ActiveModel::Serializer::CollectionSerializer.new(
              room_bookings, each_serializer: BookingSerializer
            ).as_json
        }
      end
    end
  end
end
