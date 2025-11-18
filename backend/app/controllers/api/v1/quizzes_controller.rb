module Api
  module V1
    class QuizzesController < ActionController::API
      def check
        country = Country.find_by(id: params[:quiz_id])
        return render json: { error: "Invalid quiz_id" }, status: :bad_request unless country

        # readingカラムとユーザーの回答を正規化して比較
        normalized_correct_answer = normalize_to_hiragana(country.reading.to_s)
        user_answer = normalize_to_hiragana(params[:answer].to_s)

        correct = (normalized_correct_answer == user_answer)

        render json: {
          correct: correct,
          correct_answer: country.name
        }, status: :ok
      end

      private

      def normalize_to_hiragana(text)
        # 前後の空白を削除してカタカナをひらがなに変換
        text.strip.tr("ァ-ヴ", "ぁ-ゔ")
      end
    end
  end
end
