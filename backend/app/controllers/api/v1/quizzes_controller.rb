# app/controllers/api/quizzes_controller.rb
module Api
  module V1
    class QuizzesController < ActionController::API
      def check
        country = Country.find_by(id: params[:quiz_id])
        return render json: { error: "Invalid quiz_id" }, status: :bad_request unless country


        correct = country.name.strip.downcase == params[:answer].to_s.strip.downcase
        render json: {
          correct: correct,
          correct_answer: country.name
        }, status: :ok
      end
    end
  end
end
