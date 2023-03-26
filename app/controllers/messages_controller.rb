class MessagesController < ApplicationController
  before_action :set_message, only: %i[show update destroy]

  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    render json: @message
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    head :no_content
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:title, :content)
  end
end
