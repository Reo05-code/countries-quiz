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

        # ユーザーを取得（仮実装：最初のユーザーを使用）
        user = User.first

        # クイズ挑戦履歴を保存
        # hint_level はフロントエンドから送られていないため、仮で 4 とする
        # 本来はフロントエンドから現在のヒントレベルを受け取るべき
        QuizAttempt.create!(
          user: user,
          country: country,
          correct: correct,
          hint_level: 4
        )

        if correct
          # 正解の場合、国旗を獲得（重複チェックはモデルのバリデーションで行われるが、find_or_create_byで安全に処理）
          UserFlag.find_or_create_by(user: user, country: country)
        end

        render json: {
          correct: correct,
          correct_answer: country.name,
          flag_url: correct ? country.flag_url : nil
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
