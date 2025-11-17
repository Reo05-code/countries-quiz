# app/controllers/api/v1/countries_controller.rb
module Api
  module V1
    # 改善1: ActionController::API を継承
    class CountriesController < ActionController::API
      def random
        # 改善2: もし国が0件だった場合のnilを考慮
        country = Country.order("RANDOM()").first

        if country
          render json: {
            quiz_id: country.id,
            flag_url: country.flag_url,
            hints: [country.hint_1, country.hint_2, country.hint_3, country.hint_4].compact
          }, status: :ok
        else
          # データベースが空の場合のエラーハンドリング
          render json: { error: "No countries available." }, status: :not_found
        end
      end
    end
  end
end
