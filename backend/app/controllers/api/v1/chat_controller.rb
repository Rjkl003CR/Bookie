module Api
  module V1
    # AI Customer Assistant streaming endpoint (FR-AI-01/02/03)
    class ChatController < ApplicationController
      def create
        ChatService.new(
          user: current_user,
          message: params.require(:message)
        ).stream(response)
      end
    end
  end
end
