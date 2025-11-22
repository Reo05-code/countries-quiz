module Api
  module V1
    class UserFlagsController < ActionController::API
      def index
        # 仮実装：最初のユーザーのコレクションを返す
        user = User.first

        if user
          flags = user.countries.select(:id, :name, :flag_url)
          render json: flags, status: :ok
        else
          render json: { error: "User not found" }, status: :not_found
        end
      end
    end
  end
end
