module Api
  module V1
    module Admin
      class RoomsController < ApplicationController
      	before_action :find_room, only: [:show, :update, :destroy]
        swagger_controller :room, "Room Management"

        # GET /rooms
        # :nocov:
        swagger_api :index do
          summary "Fetches all Rooms"
          param :query, :page, :integer, :optional, "Page Number"
          response :ok, "Success", :Room
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def index
          authorize Room
          page = params[:page].present? && params[:page].to_i || 1
          total = Room.count
          rooms = Room.page(page)

          respone_collection_serializer(rooms, page, total, RoomSerializer)
        end

        # GET /rooms/:id
        # :nocov:
        swagger_api :show do
          summary "Fetches a single Room item"
          param :path, :id, :integer, :required, "Room Id"
          response :ok, "Success", :Room
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def show
          authorize @room
          respone_record_serializer(@room, RoomSerializer)
        end


        # POST /rooms
        # :nocov:
        swagger_api :create do
          summary "Creates a new Room"
          param :form, :name, :string, :required, "Room Name"
          response :created, "Success", :Room
          response :unauthorized
        end
        # :nocov:
        def create
          @room = Room.new(room_params)
          authorize @room
          if @room.save
            respone_record_serializer(@room, RoomSerializer, :created)
          else
            json_response(@room.errors.full_messages, :unprocessable_entity)
          end
        end

        # PUT /rooms/:id
        # :nocov:
        swagger_api :update do
          summary "Update a Room"
          param :path, :id, :integer, :required, "Room Id"
          param :form, :name, :string, :required, "Room Name"
          response :ok, "Success", :Room
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def update
          authorize @room
          if @room.update(room_params)
            respone_record_serializer(@room, RoomSerializer, :ok)
          else
            json_response(@room.errors.full_messages, :unprocessable_entity)
          end
        end

        # DELETE /rooms/:id
        # :nocov:
        swagger_api :destroy do
          summary "Delete a Room"
          param :path, :id, :integer, :required, "Room Id"
          response :no_content, "Success", :Room
          response :unauthorized
          response :not_found
        end
        # :nocov:
        def destroy
          authorize @room
          @room.destroy
          json_response( nil, :no_content)
        end

        private

        def room_params
          # whitelist params
          params.permit(:name)
        end

        def find_room
          @room = Room.find(params[:id])
        end

      end
    end
  end
end
